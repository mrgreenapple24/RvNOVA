#!/usr/bin/env python3
"""
branch_predictor_enhanced.py

Simulate branch predictors on synthetic traces and report counts/accuracies.
Generates traces of N branches for types: if, switch, loop, mixed.
Predictors: always-taken, always-not, bimodal (2-bit), gshare, pag, tournament, perceptron, loop-exit.

Usage: python3 branch_predictor_enhanced.py [--trials N] [--branches N] [--seed S]
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


class PAgPredictor:
    """Per-Address history with global Pattern History Table.
    Each PC has its own history register, shared PHT indexed by XOR of PC and history."""
    def __init__(self, hist_bits=8, table_bits=10):
        self.hist_bits = hist_bits
        self.mask = (1 << hist_bits) - 1
        self.size = 1 << table_bits
        self.table = [1] * self.size
        self.history = defaultdict(int)  # Per-PC history

    def _idx(self, pc, hist):
        return ((pc ^ (hist & self.mask)) & (self.size - 1))

    def predict(self, pc):
        hist = self.history[pc]
        idx = self._idx(pc, hist)
        return self.table[idx] >= 2

    def update(self, pc, outcome):
        hist = self.history[pc]
        idx = self._idx(pc, hist)
        if outcome:
            if self.table[idx] < 3:
                self.table[idx] += 1
        else:
            if self.table[idx] > 0:
                self.table[idx] -= 1
        # Update per-PC history
        self.history[pc] = ((hist << 1) | (1 if outcome else 0)) & ((1 << self.hist_bits) - 1)


class TournamentPredictor:
    """Hybrid predictor combining bimodal and gshare with meta-predictor selection.
    Meta-predictor chooses which predictor is more reliable for each PC."""
    def __init__(self, table_bits=10, hist_bits=8):
        self.bimodal = BimodalPredictor(table_bits)
        self.gshare = GSharePredictor(hist_bits, table_bits)
        self.meta_table = [1] * (1 << table_bits)  # 2-bit counters: bias toward bimodal
        self.size = 1 << table_bits

    def _meta_idx(self, pc):
        return pc & (self.size - 1)

    def predict(self, pc):
        bio_pred = self.bimodal.predict(pc)
        gsh_pred = self.gshare.predict(pc)
        
        meta_idx = self._meta_idx(pc)
        use_gshare = self.meta_table[meta_idx] >= 2
        return gsh_pred if use_gshare else bio_pred

    def update(self, pc, outcome):
        bio_pred = self.bimodal.predict(pc)
        gsh_pred = self.gshare.predict(pc)
        
        meta_idx = self._meta_idx(pc)
        use_gshare = self.meta_table[meta_idx] >= 2
        
        # Update meta-predictor: increment if correct predictor agrees, decrement otherwise
        if use_gshare:
            # Currently using gshare; update based on whether gshare was correct
            if (gsh_pred == outcome) and (bio_pred != outcome):
                # Gshare correct, bimodal wrong -> stay with gshare
                if self.meta_table[meta_idx] < 3:
                    self.meta_table[meta_idx] += 1
            elif (gsh_pred != outcome) and (bio_pred == outcome):
                # Gshare wrong, bimodal correct -> switch to bimodal
                if self.meta_table[meta_idx] > 0:
                    self.meta_table[meta_idx] -= 1
        else:
            # Currently using bimodal
            if (bio_pred == outcome) and (gsh_pred != outcome):
                if self.meta_table[meta_idx] > 0:
                    self.meta_table[meta_idx] -= 1
            elif (bio_pred != outcome) and (gsh_pred == outcome):
                if self.meta_table[meta_idx] < 3:
                    self.meta_table[meta_idx] += 1
        
        # Always update both predictors
        self.bimodal.update(pc, outcome)
        self.gshare.update(pc, outcome)


class PerceptronPredictor:
    """Neural-inspired predictor using perceptron learning.
    Weights history bits and PC bits to make predictions."""
    def __init__(self, hist_bits=8, table_bits=10):
        self.hist_bits = hist_bits
        self.history = 0
        self.mask = (1 << hist_bits) - 1
        self.size = 1 << table_bits
        # Weight tables: one per history bit plus bias
        self.weights = [[0] * (hist_bits + 1) for _ in range(self.size)]

    def _idx(self, pc):
        return pc & (self.size - 1)

    def _compute_sum(self, pc):
        """Compute weighted sum of history bits."""
        idx = self._idx(pc)
        weights = self.weights[idx]
        total = weights[0]  # Bias term
        for i in range(self.hist_bits):
            bit = (self.history >> i) & 1
            total += weights[i + 1] * (1 if bit else -1)
        return total

    def predict(self, pc):
        return self._compute_sum(pc) > 0

    def update(self, pc, outcome):
        idx = self._idx(pc)
        prediction = self.predict(pc)
        
        # Perceptron learning rule: update weights if misprediction
        if prediction != outcome:
            weights = self.weights[idx]
            adjustment = 1 if outcome else -1
            weights[0] += adjustment  # Bias
            for i in range(self.hist_bits):
                bit = (self.history >> i) & 1
                if bit:
                    weights[i + 1] += adjustment
                else:
                    weights[i + 1] -= adjustment
        
        # Update global history
        self.history = ((self.history << 1) | (1 if outcome else 0)) & ((1 << self.hist_bits) - 1)


class LoopExitPredictor:
    """Specialized predictor for loop exit detection.
    Tracks loop iteration counts and predicts taken when exiting."""
    def __init__(self, hist_bits=6, table_bits=10):
        self.size = 1 << table_bits
        self.loop_count = [0] * self.size  # Iteration count per PC
        self.loop_max = [0] * self.size    # Expected max iterations per PC
        self.confidence = [0] * self.size  # Confidence in max estimate (2-bit)

    def _idx(self, pc):
        return pc & (self.size - 1)

    def predict(self, pc):
        idx = self._idx(pc)
        # If we've seen this loop many times and iteration >= max, predict taken (exit)
        if self.confidence[idx] >= 2 and self.loop_count[idx] >= self.loop_max[idx] and self.loop_max[idx] > 0:
            return True
        # Default: predict not taken (continue loop)
        return False

    def update(self, pc, outcome):
        idx = self._idx(pc)
        
        if outcome:  # Branch taken (loop exit)
            # Record this iteration count as potential loop max
            if self.loop_count[idx] > self.loop_max[idx]:
                self.loop_max[idx] = self.loop_count[idx]
                self.confidence[idx] = 1
            elif self.loop_count[idx] == self.loop_max[idx]:
                # Consistent: increase confidence
                if self.confidence[idx] < 3:
                    self.confidence[idx] += 1
            else:
                # Inconsistent: decrease confidence
                if self.confidence[idx] > 0:
                    self.confidence[idx] -= 1
            
            # Reset iteration counter on exit
            self.loop_count[idx] = 0
        else:  # Branch not taken (loop continues)
            # Increment iteration counter
            if self.loop_count[idx] < 255:  # Saturate at 255
                self.loop_count[idx] += 1


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
        ('pag-8', lambda: PAgPredictor(hist_bits=8, table_bits=10)),
        ('tournament', lambda: TournamentPredictor(table_bits=10, hist_bits=8)),
        ('perceptron', lambda: PerceptronPredictor(hist_bits=8, table_bits=10)),
        ('loop-exit', lambda: LoopExitPredictor(table_bits=10)),
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
            print(f"  {pname:15s}: avg correct = {avg_correct:.1f}/{avg_total:.0f} ({avg_acc:.2f}%)")

    # Sample single-run counts for one trace per type
    print(f"\nSample single-run counts (one trace of {n_branches} branches):")
    for tname, genfun in types:
        trace = list(genfun())
        print(f"\nType: {tname}")
        for pname, pfactory in predictors_factories:
            pred = pfactory()
            correct, total = evaluate_predictor(pred, iter(trace))
            print(f"  {pname:15s}: {correct}/{total} correct ({100.0*correct/total:.2f}%)")


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--trials', type=int, default=20)
    parser.add_argument('--branches', type=int, default=1000)
    parser.add_argument('--seed', type=int, default=None)
    args = parser.parse_args()

    run_experiment(trials=args.trials, n_branches=args.branches, seed=args.seed)