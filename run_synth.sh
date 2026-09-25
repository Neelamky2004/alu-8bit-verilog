#!/bin/sh
set -e
mkdir -p build
yosys -q -l build/synth.log synth/synth.ys
cat build/synth_stat.txt
iverilog -g2012 -o build/alu8_gls build/alu8_netlist.v tb/tb_alu8.v
cd build && vvp alu8_gls | grep -E "Tests|Errors|RESULT"
