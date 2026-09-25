# 8-bit ALU in Verilog and VHDL

An 8-bit combinational ALU written in Verilog and in VHDL. It has self-checking testbenches, and the Verilog design is synthesized to logic gates with Yosys and checked again with a gate-level simulation.

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

**Verilog (Icarus Verilog)** - `tb/tb_alu8.v` has a reference model and compares the result and all four flags.

- 12 directed cases for corner values (0x7F + 1, 0xFF + 1, 0x80 - 1, equal operands, etc.)
- 2000 random cases across all opcodes
- Dumps a VCD waveform for GTKWave

```
Tests run : 2012
Errors    : 0
RESULT    : PASS
```

**VHDL (GHDL)** - `vhdl/tb_alu8.vhd` tests every possible input: 8 opcodes x 256 x 256 values.

```
Tests run : 524288
Errors    : 0
RESULT    : PASS
```

## Synthesis (Yosys)

`synth/synth.ys` synthesizes the Verilog ALU into basic logic gates and writes a gate-level netlist. The same Verilog testbench is then run on the netlist (gate-level simulation) and passes with 0 errors.

```
Number of cells: 240
  AND 80, NAND 85, OR 41, NOR 8, XOR 13, XNOR 2, NOT 11
```

## Run

```
sh run.sh          # Verilog simulation
sh run_vhdl.sh     # VHDL simulation
sh run_synth.sh    # Yosys synthesis + gate-level simulation
gtkwave build/alu8.vcd
```

Needs Icarus Verilog, GHDL and Yosys. GTKWave is optional.

## Structure

```
rtl/alu8.v         Verilog ALU
tb/tb_alu8.v       Verilog self-checking testbench
vhdl/alu8.vhd      VHDL ALU
vhdl/tb_alu8.vhd   VHDL exhaustive testbench
synth/synth.ys     Yosys synthesis script
run.sh             Verilog simulation
run_vhdl.sh        VHDL simulation
run_synth.sh       synthesis + gate-level simulation
```
