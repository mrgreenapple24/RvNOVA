#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="build/experiments"
mkdir -p "$OUT_DIR"

# header
CSV="$OUT_DIR/predictor_results.csv"
echo "tb_name,total_branches,bimodal_mispred,gshare_mispred,tournament_mispred,perceptron_mispred" > "$CSV"

# Find testbenches
mapfile -d '' -t tbs < <(find sim -type f -name 'tb_*.v' -print0 2>/dev/null || true)

if [ "${#tbs[@]}" -eq 0 ]; then
    echo "No testbenches found"
    exit 1
fi

for tb in "${tbs[@]}"; do
    tb_name=$(basename "$tb" .v)
    echo "Running $tb_name..."

    # collect core files excluding testbenches
    mapfile -d '' -t core_files < <(find rtl sim -type f -name '*.v' ! -name 'tb_*.v' -print0 2>/dev/null || true)
    if [ "${#core_files[@]}" -eq 0 ]; then
        shopt -s globstar nullglob
        core_files=(rtl/**/*.v)
    fi

    outlog="$OUT_DIR/${tb_name}.log"
    iverilog -g2012 -o "$OUT_DIR/sim_${tb_name}.out" "${core_files[@]}" "$tb" > "$outlog" 2>&1 || true
    vvp "$OUT_DIR/sim_${tb_name}.out" >> "$outlog" 2>&1 || true

    # extract predictor report block
    awk '/----- Branch Predictor Report -----/{flag=1;next}/-----------------------------------/{flag=0}flag{print}' "$outlog" > "$OUT_DIR/${tb_name}_predictor.txt" || true

    # parse numbers
    total=$(grep -m1 "Total branches" -h "$OUT_DIR/${tb_name}_predictor.txt" | awk '{print $3}')
    bim=$(grep -m1 "Bimodal mispredictions" -h "$OUT_DIR/${tb_name}_predictor.txt" | awk '{print $3}')
    gsh=$(grep -m1 "Gshare mispredictions" -h "$OUT_DIR/${tb_name}_predictor.txt" | awk '{print $3}')
    tourn=$(grep -m1 "Tournament mispredictions" -h "$OUT_DIR/${tb_name}_predictor.txt" | awk '{print $3}')
    perc=$(grep -m1 "Perceptron mispredictions" -h "$OUT_DIR/${tb_name}_predictor.txt" | awk '{print $3}')

    echo "$tb_name,$total,$bim,$gsh,$tourn,$perc" >> "$CSV"
    echo "Done $tb_name: branches=$total bim=$bim gsh=$gsh tourn=$tourn perc=$perc"
done

echo "Results saved to $CSV"
