`timescale 1ns / 1ps


module payroll_system_top(
    input wire clk,                    // 100MHz system clock
    input wire reset,                  // Reset button (active high)
    input wire btn_calculate,          // Calculate/Update wage button
    input wire [3:0] sw_emp_id,        // Employee ID (4 bits: 0-15)
    input wire [1:0] sw_category,      // Category (2 bits: 0-3)
    input wire [7:0] sw_hours,         // Working hours (8 bits: 0-255)
    output wire [6:0] seg,             // 7-segment display segments
    output wire [3:0] an,              // 7-segment display anodes
    output wire led_threshold          // LED indicator for wage > 2500
);

    // Internal signals
    wire btn_calc_db;                  // Debounced calculate button
    wire btn_reset_db;                 // Debounced reset button
    wire [15:0] calculated_wage;       // Calculated wage (16 bits)
    wire [15:0] stored_wage;           // Wage retrieved from memory
    wire [15:0] display_wage;          // Wage to display
    wire wage_valid;                   // Wage calculation valid flag
    
    // Clock divider for display refresh
    wire clk_display;
    
    // Instantiate clock divider for 7-segment display refresh (~1kHz)
    clock_divider #(.DIV_FACTOR(100000)) clk_div_display (
        .clk_in(clk),
        .reset(reset),
        .clk_out(clk_display)
    );
    
    // Debounce calculate button
    debouncer db_calc (
        .clk(clk),
        .reset(reset),
        .btn_in(btn_calculate),
        .btn_out(btn_calc_db)
    );
    
    // Debounce reset button
    debouncer db_reset (
        .clk(clk),
        .reset(1'b0),
        .btn_in(reset),
        .btn_out(btn_reset_db)
    );
    
    // Wage calculation unit
    wage_calculator wage_calc (
        .clk(clk),
        .reset(btn_reset_db),
        .category(sw_category),
        .hours(sw_hours),
        .calculate(btn_calc_db),
        .wage(calculated_wage),
        .valid(wage_valid)
    );
    
    // Memory unit to store wages for each employee
    wage_memory wage_mem (
        .clk(clk),
        .reset(btn_reset_db),
        .emp_id(sw_emp_id),
        .wage_in(calculated_wage),
        .write_enable(wage_valid),
        .wage_out(stored_wage)
    );
    
    // Select wage to display (stored wage for current employee)
    assign display_wage = stored_wage;
    
    // Threshold detector (wage > 2500)
    threshold_detector threshold_det (
        .wage(display_wage),
        .threshold_exceeded(led_threshold)
    );
    
    // 7-segment display controller
    seven_segment_controller seg_ctrl (
        .clk(clk_display),
        .reset(btn_reset_db),
        .wage(display_wage),
        .seg(seg),
        .an(an)
    );

endmodule

// Clock Divider Module
module clock_divider #(parameter DIV_FACTOR = 100000)(
    input wire clk_in,
    input wire reset,
    output reg clk_out
);
    reg [$clog2(DIV_FACTOR)-1:0] counter;
    
    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == DIV_FACTOR - 1) begin
                counter <= 0;
                clk_out <= ~clk_out;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule

// Button Debouncer Module
module debouncer(
    input wire clk,
    input wire reset,
    input wire btn_in,
    output reg btn_out
);
    reg [19:0] counter;
    reg btn_sync_0, btn_sync_1;
    reg btn_state;
    
    // Synchronize button input
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            btn_sync_0 <= 0;
            btn_sync_1 <= 0;
        end else begin
            btn_sync_0 <= btn_in;
            btn_sync_1 <= btn_sync_0;
        end
    end
    
    // Debounce logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            btn_state <= 0;
            btn_out <= 0;
        end else begin
            btn_out <= 0;  // Default: pulse output
            
            if (btn_sync_1 != btn_state) begin
                counter <= counter + 1;
                if (counter == 20'd999999) begin  // ~10ms at 100MHz
                    btn_state <= btn_sync_1;
                    counter <= 0;
                    if (btn_sync_1 && !btn_state) begin
                        btn_out <= 1;  // Rising edge detected
                    end
                end
            end else begin
                counter <= 0;
            end
        end
    end
endmodule

// Wage Calculator Module
module wage_calculator(
    input wire clk,
    input wire reset,
    input wire [1:0] category,
    input wire [7:0] hours,
    input wire calculate,
    output reg [15:0] wage,
    output reg valid
);
    // Pay rates per hour for each category (in Rupees)
    // Category 0: ₹50/hour  (Junior)
    // Category 1: ₹100/hour (Mid-level)
    // Category 2: ₹150/hour (Senior)
    // Category 3: ₹200/hour (Manager)
    
    reg [7:0] rate;
    reg [23:0] temp_wage;  // Temporary for multiplication
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wage <= 0;
            valid <= 0;
        end else if (calculate) begin
            // Select pay rate based on category
            case (category)
                2'b00: rate = 8'd50;   // Junior
                2'b01: rate = 8'd100;  // Mid-level
                2'b10: rate = 8'd150;  // Senior
                2'b11: rate = 8'd200;  // Manager
                default: rate = 8'd50;
            endcase
            
            // Calculate wage (rate * hours)
            temp_wage = rate * hours;
            
            // Limit to 16 bits (max wage: 65535)
            if (temp_wage > 16'hFFFF) begin
                wage <= 16'hFFFF;
            end else begin
                wage <= temp_wage[15:0];
            end
            
            valid <= 1;
        end else begin
            valid <= 0;
        end
    end
endmodule

// Wage Memory Module (stores wages for 16 employees)
module wage_memory(
    input wire clk,
    input wire reset,
    input wire [3:0] emp_id,
    input wire [15:0] wage_in,
    input wire write_enable,
    output reg [15:0] wage_out
);
    // Memory array for 16 employees
    reg [15:0] memory [0:15];
    integer i;
    
    // Write operation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1) begin
                memory[i] <= 0;
            end
        end else if (write_enable) begin
            memory[emp_id] <= wage_in;
        end
    end
    
    // Read operation (asynchronous for immediate display)
    always @(*) begin
        wage_out = memory[emp_id];
    end
endmodule

// Threshold Detector Module
module threshold_detector(
    input wire [15:0] wage,
    output wire threshold_exceeded
);
    parameter THRESHOLD = 16'd1000;
    
    assign threshold_exceeded = (wage > THRESHOLD) ? 1'b1 : 1'b0;
endmodule

// Seven Segment Display Controller
module seven_segment_controller(
    input wire clk,
    input wire reset,
    input wire [15:0] wage,
    output reg [6:0] seg,
    output reg [3:0] an
);
    reg [1:0] digit_select;
    reg [3:0] digit_value;
    reg [3:0] digit0, digit1, digit2, digit3;
    
    // Extract decimal digits from wage
    always @(*) begin
        digit0 = wage % 10;
        digit1 = (wage / 10) % 10;
        digit2 = (wage / 100) % 10;
        digit3 = (wage / 1000) % 10;
    end
    
    // Digit multiplexing
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            digit_select <= 0;
        end else begin
            digit_select <= digit_select + 1;
        end
    end
    
    // Select active digit
    always @(*) begin
        case (digit_select)
            2'b00: begin
                an = 4'b1110;
                digit_value = digit0;
            end
            2'b01: begin
                an = 4'b1101;
                digit_value = digit1;
            end
            2'b10: begin
                an = 4'b1011;
                digit_value = digit2;
            end
            2'b11: begin
                an = 4'b0111;
                digit_value = digit3;
            end
            default: begin
                an = 4'b1111;
                digit_value = 4'd0;
            end
        endcase
    end
    
    // 7-segment decoder (common anode, active low)
    always @(*) begin
        case (digit_value)
            4'd0: seg = 7'b1000000;  // 0
            4'd1: seg = 7'b1111001;  // 1
            4'd2: seg = 7'b0100100;  // 2
            4'd3: seg = 7'b0110000;  // 3
            4'd4: seg = 7'b0011001;  // 4
            4'd5: seg = 7'b0010010;  // 5
            4'd6: seg = 7'b0000010;  // 6
            4'd7: seg = 7'b1111000;  // 7
            4'd8: seg = 7'b0000000;  // 8
            4'd9: seg = 7'b0010000;  // 9
            default: seg = 7'b1111111;  // Blank
        endcase
    end
endmodule
