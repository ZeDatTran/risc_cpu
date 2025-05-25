RISC CPU Design in Verilog
This repository contains a Verilog implementation of a simple RISC (Reduced Instruction Set Computer) CPU. The design includes a basic instruction set, a finite state machine (FSM) controller, and modules for memory, ALU, and program counter management.
Table of Contents

Overview
Features
Instruction Set
Project Structure
Prerequisites
Installation and Setup
Usage
Debugging
Limitations
Contributing
License

Overview
The RISC CPU is designed to execute a limited set of instructions stored in a 32-byte memory. It features an 8-bit data path, a 5-bit address space, and a controller that manages instruction fetch, decode, and execution through an 8-state FSM. The CPU supports operations like arithmetic (ADD), logical (AND, XOR), data transfer (LDA, STO), control flow (JMP, SKZ), and halting (HLT).
Features

8-bit Data Path: Processes 8-bit data with an 8-bit accumulator (AC).
5-bit Address Space: Supports up to 32 memory locations for instructions and data.
Instruction Format: 3-bit opcode + 5-bit operand.
Finite State Machine: 8 states to handle instruction fetch, operand fetch, ALU operations, and result storage.
Debug Support: Built-in $display statements for monitoring CPU state, ALU operations, and memory access.

Instruction Set
The CPU supports the following instructions:



Opcode
Mnemonic
Description



000
HLT
Halt the CPU


001
SKZ
Skip next instruction if ALU output is zero


010
ADD
Add memory data to accumulator (AC)


011
AND
Bitwise AND between AC and memory data


100
XOR
Bitwise XOR between AC and memory data


101
LDA
Load memory data into AC


110
STO
Store AC value to memory


111
JMP
Jump to address specified by operand


Project Structure
The project consists of the following Verilog files:

risc_cpu.v: Top-level module integrating all components.
controller.v: FSM-based controller for instruction execution.
alu.v: Arithmetic Logic Unit for performing operations.
program_counter.v: Manages the program counter (PC).
memory.v: 32-byte memory module with read/write support.
address_mux.v: Multiplexer for selecting memory address (PC or operand).
register.v: Generic 8-bit register used for Instruction Register (IR) and Accumulator (AC).
test/program2.mem: Memory initialization file (replace with your program).

Prerequisites

Verilog Simulator: Icarus Verilog, ModelSim, or Vivado.
Synthesis Tool (optional): Xilinx Vivado or Quartus for FPGA synthesis.
Text Editor: VS Code, Sublime Text, or any editor for modifying Verilog files.
Git: For cloning and managing the repository.

Installation and Setup

Clone the Repository:
git clone https://github.com/your-username/risc-cpu-verilog.git
cd risc-cpu-verilog


Prepare the Memory File:

The memory.v module loads initial memory content from test/program2.mem.
Create or modify test/program2.mem with your program in binary format (8-bit instructions).
Example format for program2.mem:10100001  // LDA from address 0x01
01000010  // ADD from address 0x02
11000011  // STO to address 0x03
00000000  // HLT




Install a Verilog Simulator:

For Icarus Verilog (Linux/Mac/Windows):sudo apt-get install iverilog  # Ubuntu/Debian
brew install icarus-verilog   # macOS





Usage

Compile the Verilog Code:Using Icarus Verilog:
iverilog -o risc_cpu risc_cpu.v controller.v alu.v program_counter.v memory.v address_mux.v register.v


Run the Simulation:
vvp risc_cpu

This will execute the CPU and print debug information (PC, AC, IR, ALU output, etc.) to the console.

View Debug Output:

The modules include $display statements that output the state of the CPU, memory, and ALU at each clock cycle.
Example output:Controller: state = 0, opcode = 000, zero = 0, sel = 1, rd = 0, ld_ir = 0, halt = 0, ...
Memory read: addr = 00, data = a1
ALU: opcode = 101, inA = 00, inB = ff, out = ff, is_zero = 0




Modify the Program:

Edit test/program2.mem to change the program.
Re-run the simulation to test the new program.



Debugging

Console Output: Use the $display statements in risc_cpu.v, controller.v, alu.v, and memory.v to trace CPU behavior.
Waveform Analysis: Use a simulator like ModelSim or Vivado to generate and inspect waveforms.
Testbench: Create a testbench to automate testing. Example testbench:module tb_risc_cpu;
    reg clk, rst;
    risc_cpu cpu (.clk(clk), .rst(rst));
    initial begin
        clk = 0; rst = 1;
        #10 rst = 0;
        #200 $finish;
    end
    always #5 clk = ~clk;
endmodule



Limitations

Memory Size: Limited to 32 bytes (5-bit address space).
Instruction Set: Only 8 instructions, suitable for simple tasks.
Performance: Multi-cycle execution (up to 8 cycles per instruction).
No Interrupts: The design does not support interrupts or advanced control features.

Contributing
Contributions are welcome! To contribute:

Fork the repository.
Create a new branch (git checkout -b feature-name).
Make your changes and commit (git commit -m "Add feature").
Push to the branch (git push origin feature-name).
Open a Pull Request.

Please ensure your code follows the existing style and includes appropriate comments.
License
This project is licensed under the MIT License. See the LICENSE file for details.
