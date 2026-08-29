#!/usr/bin/env python3
"""
branch_predictor.py

Simulate branch predictors on synthetic traces and report counts/accuracies.
Generates traces of N branches for types: if, switch, loop, mixed.
Predictors: always-taken, always-not, bimodal (2-bit), gshare.

Usage: python3 branch_predictor.py [--trials N] [--branches N] [--seed S]
"""

import argparse
import random
from collections import defaultdict


class StaticPredictor:
    def __init__(self, always_taken: bool):
        self.always_taken = always_taken

    def predict(self, pc):
        return self.always_taken

    def update(self, pc, outcome):
        pass


class BimodalPredictor:
    def __init__(self, table_bits=10):
        self.size = 1 << table_bits
        self.table = [1] * self.size  # 2-bit counters init weakly not taken (01)

    def _idx(self, pc):
        return pc & (self.size - 1)

    def predict(self, pc):
        return self.table[self._idx(pc)] >= 2

    def update(self, pc, outcome):
        i = self._idx(pc)
        if outcome:
            if self.table[i] < 3:
                self.table[i] += 1
        else:
            if self.table[i] > 0:
                self.table[i] -= 1


class GSharePredictor:
    def __init__(self, hist_bits=8, table_bits=10):
        self.hist_bits = hist_bits
        self.history = 0
        self.mask = (1 << hist_bits) - 1
        self.size = 1 << table_bits
        self.table = [1] * self.size

    def _idx(self, pc):
        return ((pc ^ (self.history & self.mask)) & (self.size - 1))

    def predict(self, pc):
        return self.table[self._idx(pc)] >= 2

    def update(self, pc, outcome):
        i = self._idx(pc)
        if outcome:
            if self.table[i] < 3:
                self.table[i] += 1
        else:
            if self.table[i] > 0:
                self.table[i] -= 1
        self.history = ((self.history << 1) | (1 if outcome else 0)) & ((1 << self.hist_bits) - 1)


# Trace generators

def gen_if_trace(n_branches, n_sites=200, biases=None):
    if biases is None:
        # a mix of biased and near-random sites
        biases = [random.choice([0.5, 0.6, 0.7, 0.9, 0.1, 0.2]) for _ in range(n_sites)]
    pc_ids = list(range(n_sites))
    for i in range(n_branches):
        pc = random.choice(pc_ids)
        p = biases[pc]
        yield pc, random.random() < p


def gen_loop_trace(n_branches, n_sites=100, max_loop=20):
    loop_counts = [random.randint(2, max_loop) for _ in range(n_sites)]
    pc_ids = list(range(n_sites))
    produced = 0
    while produced < n_branches:
        pc = random.choice(pc_ids)
        L = loop_counts[pc]
        # produce L-1 taken then one not-taken
        for t in range(L - 1):
            if produced >= n_branches:
                break
            yield pc, True
            produced += 1
        if produced >= n_branches:
            break
        yield pc, False
        produced += 1


def gen_switch_trace(n_branches, n_sites=150, n_cases=4):
    pc_ids = list(range(n_sites))
    for i in range(n_branches):
        pc = random.choice(pc_ids)
        case = random.randint(0, n_cases - 1)
        # Model a branch that is taken when case==0 (prob 1/n_cases)
        yield pc, (case == 0)


def gen_mixed_trace(n_branches):
    # Mix chunks from different types to emulate realistic variety
    chunk = 200
    produced = 0
    while produced < n_branches:
        choice = random.choice(['if', 'loop', 'switch'])
        size = min(chunk, n_branches - produced)
        if choice == 'if':
            for pc, out in gen_if_trace(size):
                yield pc, out
        elif choice == 'loop':
            for pc, out in gen_loop_trace(size):
                yield pc, out
        else:
            for pc, out in gen_switch_trace(size):
                yield pc, out
        produced += size


def evaluate_predictor(predictor, trace_iterable):
    correct = 0
    total = 0
    for pc, outcome in trace_iterable:
        pred = predictor.predict(pc)
        if pred == outcome:
            correct += 1
        predictor.update(pc, outcome)
        total += 1
    return correct, total


def run_experiment(trials=20, n_branches=1000, seed=None):
    if seed is not None:
        random.seed(seed)

    types = [
        ('if', lambda: gen_if_trace(n_branches)),
        ('switch', lambda: gen_switch_trace(n_branches)),
        ('loop', lambda: gen_loop_trace(n_branches)),
        ('mixed', lambda: gen_mixed_trace(n_branches)),
    ]

    predictors_factories = [
        ('always-taken', lambda: StaticPredictor(True)),
        ('always-not', lambda: StaticPredictor(False)),
        ('bimodal-2bit', lambda: BimodalPredictor(table_bits=10)),
        ('gshare-8', lambda: GSharePredictor(hist_bits=8, table_bits=10)),
    ]

    results = defaultdict(lambda: defaultdict(list))

    for tname, genfun in types:
        for tr in range(trials):
            trace_list = list(genfun())
            for pname, pfactory in predictors_factories:
                pred = pfactory()
                # pass a fresh iterator over the list
                correct, total = evaluate_predictor(pred, iter(trace_list))
                results[tname][pname].append((correct, total))

    # Summarize averages
    for tname, _ in types:
        print(f"\nBranch type: {tname}")
        for pname, _ in predictors_factories:
            runs = results[tname][pname]
            avg_correct = sum(c for c, _ in runs) / len(runs)
            avg_total = sum(t for _, t in runs) / len(runs)
            avg_acc = 100.0 * avg_correct / avg_total
            print(f"  {pname:12s}: avg correct = {avg_correct:.1f}/{avg_total:.0f} ({avg_acc:.2f}%)")

    # Sample single-run counts for one trace per type
    print("\nSample single-run counts (one trace of {n_branches} branches):")
    for tname, genfun in types:
        trace = list(genfun())
        print(f"\nType: {tname}")
        for pname, pfactory in predictors_factories:
            pred = pfactory()
            correct, total = evaluate_predictor(pred, iter(trace))
            print(f"  {pname:12s}: {correct}/{total} correct ({100.0*correct/total:.2f}%)")


import subprocess
import os
import re
import shutil


def run_verilog_testbench(tb_path, workdir=None):
    """Compile and run a Verilog testbench (tb_path) and parse the branch predictor report.
    Returns a dict: { 'cycles': int, 'total_branches': int, 'bimodal_mis': int, 'gshare_mis': int, 'tournament_mis': int, 'perceptron_mis': int, 'accuracy_*': float }
    """
    if workdir is None:
        workdir = os.getcwd()
    tb_abs = os.path.join(workdir, tb_path)
    if not os.path.exists(tb_abs):
        raise FileNotFoundError(f"Testbench not found: {tb_abs}")

    # Collect RTL core files from rtl/ (only, no sim/), and predictor_tb
    core_files = []
    
    # First: Add RTL core files
    find_cmd = "find rtl -type f -name '*.v' 2>/dev/null | sort"
    proc = subprocess.run(find_cmd, shell=True, cwd=workdir, capture_output=True, text=True)
    core_files.extend([p for p in proc.stdout.splitlines() if p.strip()])
    
    # Second: Add the predictor monitor module (not a testbench, just a monitor)
    predictor_tb = os.path.join(workdir, 'sim', 'predictor_tb.v')
    if os.path.exists(predictor_tb):
        core_files.append(predictor_tb)
    
    # Third: Add the specific testbench (the one we want to run)
    core_files.append(tb_abs)

    iv_out = os.path.join(workdir, 'sim_temp.out')
    # Build iverilog command
    iverilog = shutil.which('iverilog')
    vvp = shutil.which('vvp')
    if not iverilog or not vvp:
        raise RuntimeError('iverilog or vvp not found in PATH; install Icarus Verilog to run simulations')

    cmd = [iverilog, '-g2012', '-o', iv_out] + core_files
    comp = subprocess.run(cmd, cwd=workdir, capture_output=True, text=True)
    if comp.returncode != 0:
        raise RuntimeError(f'iverilog failed:\n{comp.stderr}\n{comp.stdout}')

    run = subprocess.run([vvp, iv_out], cwd=workdir, capture_output=True, text=True)
    out = run.stdout + '\n' + run.stderr

    # Parse report from the output
    # Looking for "----- Branch Predictor Report -----" section
    res = {}
    m = re.search(r'Cycles simulated:\s*(\d+)', out)
    res['cycles'] = int(m.group(1)) if m else None
    m = re.search(r'Total branches:\s*(\d+)', out)
    res['total_branches'] = int(m.group(1)) if m else None
    m = re.search(r'Bimodal mispredictions:\s*(\d+)\s*\(accuracy:\s*([0-9.]+)%\)', out)
    res['bimodal_mis'] = int(m.group(1)) if m else None
    res['bimodal_acc'] = float(m.group(2)) if m else None
    m = re.search(r'Gshare mispredictions:\s*(\d+)\s*\(accuracy:\s*([0-9.]+)%\)', out)
    res['gshare_mis'] = int(m.group(1)) if m else None
    res['gshare_acc'] = float(m.group(2)) if m else None
    m = re.search(r'Tournament mispredictions:\s*(\d+)\s*\(accuracy:\s*([0-9.]+)%\)', out)
    res['tournament_mis'] = int(m.group(1)) if m else None
    res['tournament_acc'] = float(m.group(2)) if m else None
    m = re.search(r'Perceptron mispredictions:\s*(\d+)\s*\(accuracy:\s*([0-9.]+)%\)', out)
    res['perceptron_mis'] = int(m.group(1)) if m else None
    res['perceptron_acc'] = float(m.group(2)) if m else None

    return res


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--trials', type=int, default=20)
    parser.add_argument('--branches', type=int, default=1000)
    parser.add_argument('--seed', type=int, default=None)
    parser.add_argument('--verilog', action='store_true', help='Run Verilog testbench integration and parse hardware report')
    parser.add_argument('--tb', type=str, default='sim/top DUTs/tb_branch.v', help='Path to Verilog testbench (relative to repo root)')
    parser.add_argument('--mispred-penalty', type=int, default=3, help='Assumed cycle penalty per misprediction')
    parser.add_argument('--write-docs', action='store_true', help='Append changelog and README notes about this run')
    args = parser.parse_args()

    if args.verilog:
        print('Running Verilog testbench and parsing branch predictor report...')
        try:
            stats = run_verilog_testbench(args.tb)
        except Exception as e:
            print(f'Verilog run failed: {e}')
            print('Falling back to synthetic mode.')
            run_experiment(trials=args.trials, n_branches=args.branches, seed=args.seed)
        else:
            if all(v is None for v in stats.values()):
                print(f'ERROR: Could not parse branch predictor report from {args.tb}')
                print('Full output capture may have failed. Ensure --tb points to a testbench with branch_predictor_tb instantiation.')
                import sys
                sys.exit(1)
            
            print('\n=== Parsed Hardware Report ===')
            print(f'Cycles simulated: {stats["cycles"]}')
            print(f'Total branches: {stats["total_branches"]}')
            print()
            
            # Display per-predictor mispredictions and accuracies
            print('=== Predictor Performance ===')
            predictors = {
                'bimodal': ('bimodal_mis', 'bimodal_acc'),
                'gshare': ('gshare_mis', 'gshare_acc'),
                'tournament': ('tournament_mis', 'tournament_acc'),
                'perceptron': ('perceptron_mis', 'perceptron_acc'),
            }
            
            base_cycles = stats.get('cycles') or 0
            total_branches = stats.get('total_branches') or 1
            
            for name, (mis_key, acc_key) in predictors.items():
                mispreds = stats.get(mis_key)
                accuracy = stats.get(acc_key)
                if mispreds is not None:
                    # Compute effective cycles with misprediction penalty
                    eff_cycles = base_cycles + mispreds * args.mispred_penalty
                    ratio = (eff_cycles / base_cycles) if base_cycles else 0
                    correct = total_branches - mispreds
                    print(f'{name:12s}: {mispreds:3d} mispreds out of {total_branches:3d} '
                          f'({accuracy:6.2f}% accurate) | '
                          f'base: {base_cycles:5d} cycles -> {eff_cycles:5d} cycles '
                          f'(ratio: {ratio:.3f})')
            
            print()
            print(f'Note: Effective cycles calculated with {args.mispred_penalty} cycle penalty per misprediction')
            
            if args.write_docs:
                # Append short notes to CHANGELOG.md and README.md
                changelog = os.path.join(os.getcwd(), 'CHANGELOG.md')
                readme = os.path.join(os.getcwd(), 'README.md')
                note = (f'\n## [unreleased] - Branch predictor hardware analysis run\n\n'
                        f'### Added\n'
                        f'- Hardware branch predictor analysis with misprediction penalty of {args.mispred_penalty} cycles.\n'
                        f'- Analysis run on testbench: {args.tb}\n'
                        f'- Results: {total_branches} branches simulated over {base_cycles} cycles.\n')
                try:
                    with open(changelog, 'a') as f:
                        f.write(note)
                    with open(readme, 'a') as f:
                        f.write(f'\n### Latest hardware analysis\n\n'
                                f'Branches: {total_branches}, Cycles: {base_cycles}, Mispred penalty: {args.mispred_penalty} cycles\n')
                    print('\nUpdated CHANGELOG.md and README.md')
                except Exception as e:
                    print(f'Failed to write docs: {e}')
    else:
        run_experiment(trials=args.trials, n_branches=args.branches, seed=args.seed)

