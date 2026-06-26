# Payroll Management System on FPGA

A Payroll Management System implemented on the Basys 3 FPGA board using Verilog HDL. The system calculates employee wages based on category and working hours, stores wage records, displays results on a 4-digit seven-segment display, and provides LED indication when wages exceed a predefined threshold.

## Features

* Wage calculation based on employee category and working hours
* Support for 16 employee records
* Real-time wage storage and retrieval
* 4-digit seven-segment display output
* Threshold detection using onboard LED
* Button debouncing for reliable operation
* Modular Verilog HDL design

## Hardware Used

* Basys 3 FPGA Board
* Xilinx Vivado Design Suite

## Employee Categories

| Category | Rate (₹/hour) |
| -------- | ------------- |
| 00       | 80            |
| 01       | 100           |
| 10       | 150           |
| 11       | 200           |

## System Architecture

Inputs:

* Employee ID (4-bit)
* Employee Category (2-bit)
* Working Hours (8-bit)
* Calculate Button
* Reset Button

Processing Modules:

* Debouncer
* Wage Calculator
* Wage Memory
* Threshold Detector
* Clock Divider
* Seven Segment Controller

Outputs:

* 4-Digit Seven Segment Display
* LED Threshold Indicator

## Project Structure

```text
Payroll-Management-System-FPGA/
│
├── payroll_system_top.v
├── payroll_system_constraints.xdc
├── block diagram.png
├── block diagram.png  
├── README.md
```

## Working

1. Select Employee ID using switches.
2. Select Employee Category.
3. Enter Working Hours.
4. Press the Calculate button.
5. Wage is calculated and stored in memory.
6. Wage is displayed on the 4-digit seven-segment display.
7. LED turns ON when the wage exceeds the threshold value.

## FPGA Resource Utilization

Implemented using Verilog HDL on the Basys 3 FPGA board and synthesized using Xilinx Vivado.

## Learning Outcomes

* FPGA-based digital system design
* Verilog HDL development
* Memory implementation
* Clock division and timing management
* Seven-segment display interfacing
* Debouncing techniques
* Hardware debugging and verification

## Authors

Developed as a Semester 3 Logic Circuit Design Group Project.

