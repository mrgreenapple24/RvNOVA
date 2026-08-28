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
SIM_OUT="sim.out"
WAVE_VCD="wave.vcd"

# Determine top-level testbench. Prefer tb/tb_riscv_top.v, then search sim/ for tb_riscv_top.v or tb_*.v.
TOP_TB="tb/tb_riscv_top.v"
choose_top_tb() {
    # Prefer explicit tb/ path
    if [ -f "tb/tb_riscv_top.v" ]; then
        TOP_TB="tb/tb_riscv_top.v"
        return
    fi

    # Search sim/ for tb_riscv_top.v or any tb_*.v, handling filenames with spaces safely.
    local -a candidates
    mapfile -d '' -t candidates < <(find sim -type f \( -name 'tb_riscv_top.v' -o -name 'tb_*.v' \) -print0 2>/dev/null || true)
    if [ "${#candidates[@]}" -gt 0 ]; then
        TOP_TB="${candidates[0]}"
        return
    fi

    # Fallback: find any tb_*.v anywhere
    mapfile -d '' -t candidates < <(find . -type f -path '*/tb_*.v' -print0 2>/dev/null || true)
    if [ "${#candidates[@]}" -gt 0 ]; then
        TOP_TB="${candidates[0]}"
        return
    fi

    # last resort leave default
    TOP_TB="tb/tb_riscv_top.v"
}

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
    choose_top_tb
    echo -e "${BLUE}Using top-level testbench: ${TOP_TB}${NC}"

    # Collect all RTL sources (core, soc, ...) using recursive glob to ensure SoC testbenches find their modules
    # Enable globstar and nullglob so the pattern expands safely even if no files match
    # collect RTL and sim sources but exclude testbench files (tb_*.v)
    mapfile -d '' -t core_files < <(find rtl sim -type f -name '*.v' ! -name 'tb_*.v' -print0 2>/dev/null || true)
    tb_files=("$TOP_TB")
    # If core_files is empty, fall back to rtl/**/*.v
    if [ "${#core_files[@]}" -eq 0 ]; then
        shopt -s globstar nullglob
        core_files=(rtl/**/*.v)
    fi

    if iverilog -g2012 -o "$SIM_OUT" "${core_files[@]}" "${tb_files[@]}"; then
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

    # Find all testbenches under tb/ and sim/ (recursively), handling filenames with spaces
    while IFS= read -r -d '' tb_file; do
        testbenches+=("$tb_file")
    done < <(find tb sim -type f -name 'tb_*.v' -print0 2>/dev/null || true)

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

        # Compile testbench: include all RTL sources (core, soc, ...) to satisfy SoC testbenches
        # collect RTL and sim sources but exclude testbench files (tb_*.v)
        mapfile -d '' -t core_files < <(find rtl sim -type f -name '*.v' ! -name 'tb_*.v' -print0 2>/dev/null || true)
        if [ "${#core_files[@]}" -eq 0 ]; then
            shopt -s globstar nullglob
            core_files=(rtl/**/*.v)
        fi
        if ! iverilog -g2012 -o "$temp_out" "${core_files[@]}" "$tb" > "$temp_log" 2>&1; then
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

        # Determine pass/fail: prefer vvp exit code; if zero, accept explicit "all ... passed" summaries
        if [ "$vvp_exit" -ne 0 ]; then
            status_failed=1
        else
            if grep -qiE "all .* passed|tests passed" "$temp_log"; then
                status_failed=0
            elif grep -qiE "fail|fatal|error" "$temp_log"; then
                status_failed=1
            else
                status_failed=0
            fi
        fi

        if [ "$status_failed" -ne 0 ]; then
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
