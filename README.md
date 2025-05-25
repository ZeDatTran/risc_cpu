# RISC CPU Design in Verilog

This repository contains a Verilog implementation of a simple RISC (Reduced Instruction Set Computer) CPU. The design includes a basic instruction set, a finite state machine (FSM) controller, and modules for memory, ALU, and program counter management.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Instruction Set](#instruction-set)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation and Setup](#installation-and-setup)
- [Usage](#usage)
- [Debugging](#debugging)
- [Limitations](#limitations)
- [Contributing](#contributing)
- [License](#license)

## Overview
The RISC CPU is designed to execute a limited set of instructions stored in a 32-byte memory. It features an 8-bit data path, a 5-bit address space, and a controller that manages instruction fetch, decode, and execution through an 8-state FSM. The CPU supports operations like arithmetic (ADD), logical (AND, XOR), data transfer (LDA, STO), control flow (JMP, SKZ), and halting (HLT).

## Features
- **8-bit Data Path**: Processes 8-bit data with an 8-bit accumulator (AC).
- **5-bit Address Space**: Supports up to 32 memory locations for instructions and data.
- **Instruction Format**: 3-bit opcode + 5-bit operand.
- **Finite State Machine**: 8 states to handle instruction fetch, operand fetch, ALU operations, and result storage.
- **Debug Support**: Built-in `$display` statements for monitoring CPU state, ALU operations, and memory access.

## Instruction Set
The CPU supports the following instructions:

| Opcode | Mnemonic | Description                                      |
|--------|----------|--------------------------------------------------|
| `000`  | HLT      | Halt the CPU                                    |
| `001`  | SKZ      | Skip next instruction if ALU output is zero      |
| `010`  | ADD      | Add memory data to accumulator (AC)             |
| `011`  | AND      | Bitwise AND between AC and memory data          |
| `100`  | XOR      | Bitwise XOR between AC and memory data          |
| `101`  | LDA      | Load memory data into AC                        |
| `110`  | STO      | Store AC value to memory                        |
| `111`  | JMP      | Jump to address specified by operand            |

## Project Structure
The project consists of the following Verilog files:

- `risc_cpu.v`: Top-level module integrating all components.
- `controller.v`: FSM-based controller for instruction execution.
- `alu.v`: Arithmetic Logic Unit for performing operations.
- `program_counter.v`: Manages the program counter (PC).
- `memory.v`: 32-byte memory module with read/write support.
- `address_mux.v`: Multiplexer for selecting memory address (PC or operand).
- `register.v`: Generic 8-bit register used for Instruction Register (IR) and Accumulator (AC).
- `test/program2.mem`: Memory initialization file (replace with your program).
