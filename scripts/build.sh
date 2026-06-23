#!/usr/bin/env bash

# ==========================================
# RvNOVA Build & Test Automation Script
# ==========================================

set -euo pipefail

# Color codes for pretty printing
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0;0m' # No Color

# Default values
TOP_TB="tb/tb_riscv_top.v"
SIM_OUT="sim.out"
WAVE_VCD="wave.vcd"

show_help() {
    cat << EOF
Usage: ./build.sh [COMMAND]

Commands:
  (no arguments)  Compile default top-level design ($TOP_TB), run simulation,
                  and open the waveform in GTKWave.
  test            Compile and run all testbenches under tb/ to verify correctness.
  clean           Remove all generated simulation outputs (.out) and waveforms (.vcd).
  help, -h, --help Show this help message.
EOF
}

clean_temp_files() {
    rm -f "$SIM_OUT" "$WAVE_VCD" regfile.vcd csr_regfile.vcd sim_tb.out test_run.log
}

build_default() {
    echo -e "${BLUE}[1/3] Compiling default top-level design...${NC}"
    if iverilog -g2012 -o "$SIM_OUT" rtl/core/*.v "$TOP_TB"; then
        echo -e "${GREEN}Compilation successful.${NC}"
    else
        echo -e "${RED}Compilation failed!${NC}"
        exit 1
    fi

    echo -e "${BLUE}[2/3] Running simulation...${NC}"
    if vvp "$SIM_OUT"; then
        echo -e "${GREEN}Simulation completed successfully.${NC}"
    else
        echo -e "${RED}Simulation crashed or failed!${NC}"
        exit 1
    fi

    echo -e "${BLUE}[3/3] Opening waveform in GTKWave...${NC}"
    if [ -f "$WAVE_VCD" ]; then
        echo -e "${BLUE}Running: gtkwave $WAVE_VCD${NC}"
        gtkwave "$WAVE_VCD" &
    else
        echo -e "${YELLOW}Warning: $WAVE_VCD was not generated. Cannot open GTKWave.${NC}"
    fi
}

run_tests() {
    echo -e "${BLUE}==================================================${NC}"
    echo -e "${BLUE}           RvNOVA Test Suite Runner               ${NC}"
    echo -e "${BLUE}==================================================${NC}"

    local passed=0
    local failed=0
    local testbenches=()

    # Find all testbenches under tb/
    for tb_file in tb/*.v; do
        if [ -f "$tb_file" ]; then
            testbenches+=("$tb_file")
        fi
    done

    local total="${#testbenches[@]}"
    if [ "$total" -eq 0 ]; then
        echo -e "${YELLOW}No testbenches found under tb/.${NC}"
        exit 0
    fi

    local temp_out="sim_tb.out"
    local temp_log="test_run.log"

    for tb in "${testbenches[@]}"; do
        local tb_name
        tb_name=$(basename "$tb" .v)
        echo -n -e "Running testbench ${BLUE}$tb_name${NC} ... "

        # Compile testbench
        if ! iverilog -g2012 -o "$temp_out" rtl/core/*.v "$tb" > "$temp_log" 2>&1; then
            echo -e "${RED}[COMPILE FAILED]${NC}"
            echo -e "${RED}--- Compiler Errors: ---${NC}"
            cat "$temp_log"
            echo -e "${RED}------------------------${NC}"
            failed=$((failed + 1))
            continue
        fi

        # Run testbench simulation
        local vvp_exit=0
        vvp "$temp_out" > "$temp_log" 2>&1 || vvp_exit=$?

        # Check for failure indications in log or non-zero exit code
        if [ "$vvp_exit" -ne 0 ] || grep -qiE "fail|fatal|assertion failed|error" "$temp_log"; then
            echo -e "${RED}[FAILED]${NC}"
            echo -e "${RED}--- Simulation Logs: ---${NC}"
            cat "$temp_log"
            echo -e "${RED}------------------------${NC}"
            failed=$((failed + 1))
        else
            echo -e "${GREEN}[PASSED]${NC}"
            passed=$((passed + 1))
        fi
    done

    # Cleanup temporary test files
    rm -f "$temp_out" "$temp_log"

    echo -e "${BLUE}==================================================${NC}"
    echo -e "Test Summary:"
    echo -e "  Passed: ${GREEN}$passed / $total${NC}"
    if [ "$failed" -gt 0 ]; then
        echo -e "  Failed: ${RED}$failed / $total${NC}"
        echo -e "${RED}Some tests failed!${NC}"
        exit 1
    else
        echo -e "${GREEN}All tests passed!${NC}"
        exit 0
    fi
}

# Main Command Router
if [ $# -eq 0 ]; then
    build_default
else
    case "$1" in
        test)
            run_tests
            ;;
        clean)
            echo -e "${BLUE}Cleaning up generated simulation files...${NC}"
            clean_temp_files
            echo -e "${GREEN}Clean completed.${NC}"
            ;;
        help|-h|--help)
            show_help
            ;;
        *)
            echo -e "${RED}Unknown command: $1${NC}"
            show_help
            exit 1
            ;;
    esac
fi
