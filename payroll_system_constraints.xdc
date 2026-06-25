## Basys 3 FPGA Constraints File for Payroll Management System
## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

## Switches for Employee ID (SW3-SW0)
set_property PACKAGE_PIN V17 [get_ports {sw_emp_id[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_emp_id[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw_emp_id[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_emp_id[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw_emp_id[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_emp_id[2]}]
set_property PACKAGE_PIN W17 [get_ports {sw_emp_id[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_emp_id[3]}]

## Switches for Category (SW5-SW4)
set_property PACKAGE_PIN W15 [get_ports {sw_category[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_category[0]}]
set_property PACKAGE_PIN V15 [get_ports {sw_category[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_category[1]}]

## Switches for Working Hours (SW13-SW6)
set_property PACKAGE_PIN W14 [get_ports {sw_hours[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_hours[0]}]
set_property PACKAGE_PIN W13 [get_ports {sw_hours[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_hours[1]}]
set_property PACKAGE_PIN V2 [get_ports {sw_hours[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_hours[2]}]
set_property PACKAGE_PIN T3 [get_ports {sw_hours[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_hours[3]}]
set_property PACKAGE_PIN T2 [get_ports {sw_hours[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_hours[4]}]
set_property PACKAGE_PIN R3 [get_ports {sw_hours[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_hours[5]}]
set_property PACKAGE_PIN W2 [get_ports {sw_hours[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_hours[6]}]
set_property PACKAGE_PIN U1 [get_ports {sw_hours[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_hours[7]}]

## Buttons
# Center button - Calculate/Update wage
set_property PACKAGE_PIN U18 [get_ports btn_calculate]
set_property IOSTANDARD LVCMOS33 [get_ports btn_calculate]

# Reset button (can use Up or Down button)
set_property PACKAGE_PIN T18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

## 7-Segment Display
# Segments
set_property PACKAGE_PIN W7 [get_ports {seg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN V5 [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

# Anodes
set_property PACKAGE_PIN U2 [get_ports {an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]

## LED for Threshold Indicator
set_property PACKAGE_PIN U16 [get_ports led_threshold]
set_property IOSTANDARD LVCMOS33 [get_ports led_threshold]

## Configuration options
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
