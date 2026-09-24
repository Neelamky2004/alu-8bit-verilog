# 8-bit ALU in Verilog

A combinational 8-bit ALU written in Verilog with a self-checking testbench, simulated using Icarus Verilog and viewed in GTKWave.

## Operations

| op  | Operation | Flags updated |
|-----|-----------|---------------|
| 000 | ADD       | Z, C, N, V |
| 001 | SUB       | Z, C (borrow), N, V |
| 010 | AND       | Z, N |
| 011 | OR        | Z, N |
| 100 | XOR       | Z, N |
| 101 | NOT A     | Z, N |
| 110 | Shift left  | Z, C (bit shifted out), N |
| 111 | Shift right | Z, C (bit shifted out), N |

Flags: Z = zero, C = carry/borrow, N = negative (MSB), V = signed overflow.

## Verification

The testbench in `tb/tb_alu8.v` has a reference model and compares the DUT output and all four flags for every input.

- 12 directed cases for corner values (0x7F + 1, 0xFF + 1, 0x80 - 1, equal operands, etc.)
- 2000 random cases across all opcodes
- Prints PASS/FAIL with a mismatch log and dumps a VCD waveform

```
Tests run : 2012
Errors    : 0
RESULT    : PASS
```

## Run

```
sh run.sh
gtkwave build/alu8.vcd
```

Needs Icarus Verilog (`iverilog`, `vvp`). GTKWave is optional for waveforms. The code also runs on EDA Playground.

## Structure

```
rtl/alu8.v       ALU design
tb/tb_alu8.v     self-checking testbench
run.sh           compile + simulate
```
