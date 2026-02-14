# ===============================
# RISC-V Core Makefile (Icarus)
# ===============================

IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

TOP      = tb_riscv_top
OUT      = sim.out
VCD      = wave.vcd

SRC      = rdl/core/*.v tb/tb_riscv_top.v

all: run

compile:
	$(IVERILOG) -g2012 -o $(OUT) $(SRC)

run: compile
	$(VVP) $(OUT)

wave: run
	$(GTKWAVE) $(VCD)

clean:
	rm -f $(OUT) $(VCD)

.PHONY: all compile run wave clean
