#!/usr/bin/env python3
import os
import csv

OUT_DIR = "build/experiments"
CSV = os.path.join(OUT_DIR, "predictor_results.csv")
PNG = os.path.join(OUT_DIR, "predictor_summary.png")
PNG2 = os.path.join(OUT_DIR, "predictor_accuracy.png")

if not os.path.exists(CSV):
    print("CSV not found:", CSV)
    raise SystemExit(1)

try:
    import matplotlib.pyplot as plt
except Exception as e:
    print("matplotlib not available:", e)
    raise SystemExit(1)

# Read CSV using csv.DictReader to avoid pandas dependency
labels = []
data = {
    'bimodal_mispred': [],
    'gshare_mispred': [],
    'tournament_mispred': [],
    'perceptron_mispred': [],
    'bimodal_acc': [],
    'gshare_acc': [],
    'tournament_acc': [],
    'perceptron_acc': []
}

with open(CSV, newline='') as f:
    reader = csv.DictReader(f)
    for row in reader:
        labels.append(row['tb_name'])
        for k in data.keys():
            v = row.get(k, '0')
            try:
                data[k].append(float(v))
            except:
                data[k].append(0.0)

# Mispredictions grouped bar chart
x = list(range(len(labels)))
width = 0.18
fig, ax = plt.subplots(figsize=(max(8, len(labels)*0.8), 6))
preds = ['bimodal', 'gshare', 'tournament', 'perceptron']
for i, pred in enumerate(preds):
    ax.bar([p + (i-1.5)*width for p in x], data[f"{pred}_mispred"], width, label=pred)

ax.set_xticks(x)
ax.set_xticklabels(labels, rotation=45, ha='right')
ax.set_ylabel('Mispredictions')
ax.set_title('Branch Predictor Mispredictions per Testbench')
ax.legend()
plt.tight_layout()
plt.savefig(PNG)
print('Saved', PNG)

# Accuracy plot
fig2, ax2 = plt.subplots(figsize=(max(8, len(labels)*0.8), 6))
for pred in preds:
    ax2.plot(labels, data[f"{pred}_acc"], marker='o', label=pred)

ax2.set_xticklabels(labels, rotation=45, ha='right')
ax2.set_ylabel('Accuracy (%)')
ax2.set_title('Branch Predictor Accuracy per Testbench')
ax2.set_ylim(0, 100)
ax2.legend()
plt.tight_layout()
plt.savefig(PNG2)
print('Saved', PNG2)
