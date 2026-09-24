#!/bin/sh
set -e
mkdir -p build
iverilog -g2012 -Wall -o build/alu8_sim rtl/alu8.v tb/tb_alu8.v
cd build && vvp alu8_sim
