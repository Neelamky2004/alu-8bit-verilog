#!/bin/sh
set -e
mkdir -p build/vhdl
cd build/vhdl
ghdl -a --std=08 ../../vhdl/alu8.vhd ../../vhdl/tb_alu8.vhd
ghdl -e --std=08 tb_alu8
ghdl -r --std=08 tb_alu8
