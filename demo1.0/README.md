# Demo1 – NASM String & Integer Conversion (Linux x86-64)

## Overview
This demo is a Linux x86-64 NASM program that reads multiple string inputs,
converts numeric strings to integers, performs simple arithmetic, and converts
the result back to a string for output.

The program is split into multiple assembly files to demonstrate basic
modular design and linker usage in NASM.

## Key Learning Goals
1. Use Linux system calls (`read`, `write`, `exit`) directly in NASM.
2. Convert between ASCII strings and integers (`string2integer`, `integer2string`).
3. Understand caller-saved vs callee-saved registers.
4. Split a single assembly program into multiple files using `global` and `extern`.

## File Structure
- `main.asm` – program entry point and control flow
- `io.asm` – input/output helper functions (syscalls)
- `convert.asm` – string ↔ integer conversion logic
- `data.asm` – shared data, buffers, and constants

## Build & Run
```bash
nasm -f elf64 data.asm -o data.o
nasm -f elf64 io.asm -o io.o
nasm -f elf64 convert.asm -o convert.o
nasm -f elf64 main.asm -o main.o
ld data.o io.o convert.o main.o -o demo1
./demo1
