#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="build/experiments"
mkdir -p "$OUT_DIR"

# header
CSV="$OUT_DIR/predictor_results.csv"
echo "tb_name,total_branches,cycles,bimodal_mispred,bimodal_acc,gshare_mispred,gshare_acc,tournament_mispred,tournament_acc,perceptron_mispred,perceptron_acc" > "$CSV"

# Find testbenches
mapfile -d '' -t tbs < <(find sim -type f -name 'tb_*.v' -print0 2>/dev/null || true)

if [ "${#tbs[@]}" -eq 0 ]; then
    echo "No testbenches found"
    exit 1
fi

for tb in "${tbs[@]}"; do
    tb_name=$(basename "$tb" .v)
    echo "Running $tb_name..."

    # collect core files from rtl and include sim/predictor_tb.v if present
    shopt -s globstar nullglob
    core_files=(rtl/**/*.v)
    if [ -f sim/predictor_tb.v ]; then
        core_files+=(sim/predictor_tb.v)
    fi

    outlog="$OUT_DIR/${tb_name}.log"
    iverilog -g2012 -o "$OUT_DIR/sim_${tb_name}.out" "${core_files[@]}" "$tb" > "$outlog" 2>&1 || true
    vvp "$OUT_DIR/sim_${tb_name}.out" >> "$outlog" 2>&1 || true

    # extract predictor report block
    awk '/----- Branch Predictor Report -----/{flag=1;next}/-----------------------------------/{flag=0}flag{print}' "$outlog" > "$OUT_DIR/${tb_name}_predictor.txt" || true

    # parse numbers (handle missing predictor report)
    total=0; cycles=0; bim=0; gsh=0; tourn=0; perc=0
    if [ -s "$OUT_DIR/${tb_name}_predictor.txt" ]; then
        cycles=$(grep -m1 "Cycles simulated" -h "$OUT_DIR/${tb_name}_predictor.txt" | awk '{print $3}' || echo 0)
        total=$(grep -m1 "Total branches" -h "$OUT_DIR/${tb_name}_predictor.txt" | awk '{print $3}' || echo 0)
        bim=$(grep -m1 "Bimodal mispredictions" -h "$OUT_DIR/${tb_name}_predictor.txt" | awk '{print $3}' || echo 0)
        gsh=$(grep -m1 "Gshare mispredictions" -h "$OUT_DIR/${tb_name}_predictor.txt" | awk '{print $3}' || echo 0)
        tourn=$(grep -m1 "Tournament mispredictions" -h "$OUT_DIR/${tb_name}_predictor.txt" | awk '{print $3}' || echo 0)
        perc=$(grep -m1 "Perceptron mispredictions" -h "$OUT_DIR/${tb_name}_predictor.txt" | awk '{print $3}' || echo 0)
    else
        echo "Warning: No predictor report for $tb_name; recording zeros." >&2
    fi

    # compute accuracies (percent) with two decimal places
    if [ "${total:-0}" -gt 0 ]; then
        bim_acc=$(awk -v t="$total" -v m="$bim" 'BEGIN{printf "%.2f", 100*(t-m)/t}')
        gsh_acc=$(awk -v t="$total" -v m="$gsh" 'BEGIN{printf "%.2f", 100*(t-m)/t}')
        tourn_acc=$(awk -v t="$total" -v m="$tourn" 'BEGIN{printf "%.2f", 100*(t-m)/t}')
        perc_acc=$(awk -v t="$total" -v m="$perc" 'BEGIN{printf "%.2f", 100*(t-m)/t}')
    else
        bim_acc="0.00"
        gsh_acc="0.00"
        tourn_acc="0.00"
        perc_acc="0.00"
    fi

    echo "$tb_name,$total,$cycles,$bim,$bim_acc,$gsh,$gsh_acc,$tourn,$tourn_acc,$perc,$perc_acc" >> "$CSV"
    echo "Done $tb_name: branches=$total cycles=$cycles bim=$bim($bim_acc%) gsh=$gsh($gsh_acc%) tourn=$tourn($tourn_acc%) perc=$perc($perc_acc%)"

done

echo "Results saved to $CSV"
