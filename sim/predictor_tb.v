`timescale 1ns/1ps

module branch_predictor_tb (
    input clk,
    input rst_n,
    input [31:0] pc,
    input [31:0] instr
);

// Parameters
localparam BHT_BITS = 10; // 1024 entries
localparam BHT_SIZE = (1<<BHT_BITS);
localparam GH_BITS = 8;    // global history bits
localparam PERC_HISTORY = GH_BITS;
localparam PERC_WIDTH = 6; // weight bit width (signed)
localparam PERC_THRESHOLD = 10; // threshold for perceptron prediction

// Tables
reg [1:0] bimodal [0:BHT_SIZE-1];
reg [1:0] gshare  [0:BHT_SIZE-1];
reg [1:0] chooser [0:BHT_SIZE-1]; // for tournament: >=2 choose gshare, else bimodal

// Perceptron table: flattened array to be compatible with Verilog-2001
// each perceptron has PERC_HISTORY weights + bias
reg signed [PERC_WIDTH-1:0] perceptron_flat [0:(BHT_SIZE*PERC_HISTORY)-1];
reg signed [PERC_WIDTH-1:0] perc_bias [0:BHT_SIZE-1];

// helper macro to index perceptron weight: perceptron_flat[idx*PERC_HISTORY + k]
function integer perc_offset;
    input integer idx;
    input integer k;
    begin
        perc_offset = idx * PERC_HISTORY + k;
    end
endfunction

// Global history
reg [GH_BITS-1:0] gh;

// Stats
integer total_branches;
integer mis_bimodal;
integer mis_gshare;
integer mis_tournament;
integer mis_perceptron;
integer cycles;

// Previous sampled instruction and PC to compare next PC
reg [31:0] prev_pc;
reg [31:0] prev_instr;
reg has_prev;

integer i,j;

initial begin
    // init tables
    for (i = 0; i < BHT_SIZE; i = i + 1) begin
        bimodal[i] = 2; // weakly taken
        gshare[i]  = 2;
        chooser[i] = 1; // weakly prefer bimodal
        for (j = 0; j < PERC_HISTORY; j = j + 1) begin
            perceptron_flat[perc_offset(i,j)] = 0;
        end
        perc_bias[i] = 0;
    end
    gh = 0;
    total_branches = 0;
    mis_bimodal = 0;
    mis_gshare = 0;
    mis_tournament = 0;
    mis_perceptron = 0;
    cycles = 0;
    has_prev = 0;
end

function is_branch;
    input [31:0] insn;
    begin
        // opcode in [6:0]
        is_branch = (insn[6:0] == 7'b1100011);
    end
endfunction

// Saturating counter update helper: 2-bit saturating counter, taken when msb=1
function [1:0] sat_update;
    input [1:0] old;
    input taken;
    begin
        if (taken) begin
            if (old != 2'b11) sat_update = old + 1; else sat_update = old;
        end else begin
            if (old != 2'b00) sat_update = old - 1; else sat_update = old;
        end
    end
endfunction

// Perceptron predict: dot product of weights and history (+ bias)
function signed [15:0] perceptron_dot;
    input integer idx;
    integer k;
    reg signed [15:0] acc;
    reg hbit;
    begin
        acc = perc_bias[idx];
        for (k = 0; k < PERC_HISTORY; k = k + 1) begin
            hbit = gh[k]; // history LSB is most recent
            if (hbit) acc = acc + perceptron_flat[perc_offset(idx,k)]; else acc = acc - perceptron_flat[perc_offset(idx,k)];
        end
        perceptron_dot = acc;
    end
endfunction

// Perceptron train: adjust weights towards outcome (+1 taken, -1 not taken)
task perceptron_train;
    input integer idx;
    input outcome; // 1 = taken, 0 = not taken
    integer k;
    reg signed [15:0] y;
    reg signed [15:0] t;
    reg hbit;
    begin
        y = perceptron_dot(idx);
        t = outcome ? 1 : -1;
        if ((y * t) <= PERC_THRESHOLD) begin
            // update bias
            if (t > 0) perc_bias[idx] = perc_bias[idx] + 1; else perc_bias[idx] = perc_bias[idx] - 1;
            for (k = 0; k < PERC_HISTORY; k = k + 1) begin
                hbit = gh[k];
                if (hbit) begin
                    if (t > 0) perceptron_flat[perc_offset(idx,k)] = perceptron_flat[perc_offset(idx,k)] + 1; else perceptron_flat[perc_offset(idx,k)] = perceptron_flat[perc_offset(idx,k)] - 1;
                end else begin
                    if (t > 0) perceptron_flat[perc_offset(idx,k)] = perceptron_flat[perc_offset(idx,k)] - 1; else perceptron_flat[perc_offset(idx,k)] = perceptron_flat[perc_offset(idx,k)] + 1;
                end
            end
        end
    end
endtask

always @(posedge clk) begin
    if (!rst_n) begin
        cycles <= 0;
        prev_pc <= 0;
        prev_instr <= 0;
        has_prev <= 0;
    end else begin
        cycles <= cycles + 1;

        // If we have a previous instruction, determine whether it was a branch and whether it was taken
        if (has_prev) begin
            // local declarations for this block (Verilog requires declarations before statements)
            integer idx;
            integer gh_index;
            integer pindex;
            reg actual_taken;
            reg bim_pred;
            reg gsh_pred;
            reg use_gshare;
            reg choice_pred;
            reg signed [15:0] pval;
            reg perc_pred;

            if (is_branch(prev_instr)) begin
                total_branches = total_branches + 1;
                // actual outcome: compare current pc to prev_pc + 4
                actual_taken = (pc != (prev_pc + 4));

                // Index for tables: use lower bits of prev_pc >> 2 (word aligned)
                idx = (prev_pc >> 2) & (BHT_SIZE-1);

                // Bimodal prediction
                bim_pred = bimodal[idx][1];
                if (bim_pred != actual_taken) mis_bimodal = mis_bimodal + 1;
                // update bimodal
                bimodal[idx] = sat_update(bimodal[idx], actual_taken);

                // Gshare prediction
                gh_index = ( (prev_pc >> 2) ^ gh ) & (BHT_SIZE-1);
                gsh_pred = gshare[gh_index][1];
                if (gsh_pred != actual_taken) mis_gshare = mis_gshare + 1;
                // update gshare
                gshare[gh_index] = sat_update(gshare[gh_index], actual_taken);

                // Tournament: chooser: if chooser >=2 use gshare else bimodal
                use_gshare = (chooser[idx] >= 2);
                choice_pred = use_gshare ? gsh_pred : bim_pred;
                if (choice_pred != actual_taken) mis_tournament = mis_tournament + 1;
                // update chooser to favor predictor that was correct
                if (gsh_pred != bim_pred) begin
                    if (gsh_pred == actual_taken) begin
                        chooser[idx] = sat_update(chooser[idx], 1);
                    end else if (bim_pred == actual_taken) begin
                        chooser[idx] = sat_update(chooser[idx], 0);
                    end
                end

                // Perceptron prediction
                pindex = (prev_pc >> 2) & (BHT_SIZE-1);
                pval = perceptron_dot(pindex);
                perc_pred = (pval >= 0);
                if (perc_pred != actual_taken) mis_perceptron = mis_perceptron + 1;
                // train perceptron
                perceptron_train(pindex, actual_taken);

                // update global history (shift left, LSB=most recent)
                gh = {actual_taken, gh[GH_BITS-1:1]};
            end else begin
                // Non-branch: shift history with 0
                gh = {1'b0, gh[GH_BITS-1:1]};
            end
        end

        // sample current as previous for next cycle
        prev_pc <= pc;
        prev_instr <= instr;
        has_prev <= 1'b1;
    end
end

// Final report on simulation end (when testbench $finish is called, $strobe here may still execute)
// Use $at_end callback if available; otherwise rely on post-simulation prints invoked by testbenches.

// Provide a task that can be called from the testbench to print stats
task report();
    begin
        $display("----- Branch Predictor Report -----");
        $display("Cycles simulated: %0d", cycles);
        $display("Total branches: %0d", total_branches);
        $display("Bimodal mispredictions: %0d (accuracy: %0.2f%%)", mis_bimodal, (total_branches ? 100.0*(total_branches-mis_bimodal)/total_branches : 0.0));
        $display("Gshare mispredictions: %0d (accuracy: %0.2f%%)", mis_gshare, (total_branches ? 100.0*(total_branches-mis_gshare)/total_branches : 0.0));
        $display("Tournament mispredictions: %0d (accuracy: %0.2f%%)", mis_tournament, (total_branches ? 100.0*(total_branches-mis_tournament)/total_branches : 0.0));
        $display("Perceptron mispredictions: %0d (accuracy: %0.2f%%)", mis_perceptron, (total_branches ? 100.0*(total_branches-mis_perceptron)/total_branches : 0.0));
        $display("-----------------------------------");
    end
endtask

endmodule
