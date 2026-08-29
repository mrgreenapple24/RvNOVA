# ===============================
# RISC-V Core Makefile (Icarus)
# ===============================

IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

TOP      = tb_riscv_top
OUT      = sim.out
VCD      = wave.vcd

SRC      = rtl/core/*.v rtl/predictor/*.v rtl/config/*.v tb/tb_riscv_top.v tb/predictor_tb.v

all: run

compile:
	$(IVERILOG) -g2012 -o $(OUT) $(SRC)

run: compile
	$(VVP) $(OUT)

wave: run
	$(GTKWAVE) $(VCD)

clean:
	rm -f $(OUT) $(VCD)

branch_compare:
	@pred_names=("static_not_taken" "static_taken" "1bit" "2bit" "gshare" "tournament")
	@pred_vals=(0 1 2 3 4 5)
	@rm -f branch_compare.csv
	@for i in $${!pred_vals[@]}; do \
		VAL=$${pred_vals[$$i]}; \
		NAME=$${pred_names[$$i]}; \
		$(IVERILOG) -g2012 +define+PREDICTOR_TYPE=$$VAL -o $(OUT) $(SRC); \
		$(VVP) $(OUT) > /dev/null; \
		if [ $$i -eq 0 ]; then \
			cat results_$$VAL.csv >> branch_compare.csv; \
		else \
			tail -n +2 results_$$VAL.csv >> branch_compare.csv; \
		fi; \
	done

# ==========================================
# Firmware Build
# ==========================================

CC       = riscv64-unknown-elf-gcc
OBJCOPY  = riscv64-unknown-elf-objcopy

CFLAGS   = -march=rv32i -mabi=ilp32 -nostdlib -nostartfiles
LDFLAGS  = -T firmware/linker.ld

FIRMWARE_ELF = build/firmware.elf
FIRMWARE_MEM = build/firmware.mem
FIRMWARE_HEX = build/firmware.hex

firmware: $(FIRMWARE_HEX)

$(FIRMWARE_ELF): firmware/startup.S firmware/main.c firmware/linker.ld
	mkdir -p build
	$(CC) $(CFLAGS) $(LDFLAGS) \
		firmware/startup.S \
		firmware/main.c \
		-o $(FIRMWARE_ELF)

$(FIRMWARE_MEM): $(FIRMWARE_ELF)
	$(OBJCOPY) -O verilog \
		$(FIRMWARE_ELF) \
		$(FIRMWARE_MEM)

$(FIRMWARE_HEX): $(FIRMWARE_MEM)
	python3 scripts/converttohex.py \
		$(FIRMWARE_MEM) \
		$(FIRMWARE_HEX)

firmware-clean:
	rm -f build/firmware.*

.PHONY: firmware firmware-clean
