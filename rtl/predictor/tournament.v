`timescale 1ns/1ps
module tournament (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] pc,
    input  wire        resolve_taken,
    input  wire        resolve_valid,
    output wire        predict_taken
);
    // Parameters
    localparam ENTRY_BITS = 8;   // 256 entries for each table
    localparam GHR_BITS   = 8;   // 8‑bit global history

    // ===== Global (Gshare) predictor =====
    reg [GHR_BITS-1:0] ghr;
    reg [1:0] gshare_table [0:(1<<ENTRY_BITS)-1];
    wire [ENTRY_BITS-1:0] pc_idx   = pc[ENTRY_BITS+1:2];
    wire [ENTRY_BITS-1:0] gshare_idx = pc_idx ^ ghr; // XOR indexing

    // ===== Local (Bimodal) predictor =====
    reg [1:0] local_table [0:(1<<ENTRY_BITS)-1];
    wire [ENTRY_BITS-1:0] local_idx = pc_idx;

    // ===== Chooser (2‑bit) =====
    // Chooser decides whether to trust global or local predictor.
    // 0‑1 -> prefer local, 2‑3 -> prefer global (MSB is the selector)
    reg [1:0] chooser_table [0:(1<<ENTRY_BITS)-1];
    wire [ENTRY_BITS-1:0] chooser_idx = pc_idx; // same indexing as local for simplicity

    // Predictions
    wire global_pred = gshare_table[gshare_idx][1];
    wire local_pred  = local_table[local_idx][1];
    assign predict_taken = chooser_table[chooser_idx][1] ? global_pred : local_pred;

    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ghr <= {GHR_BITS{1'b0}};
            for (i = 0; i < (1<<ENTRY_BITS); i = i + 1) begin
                gshare_table[i] <= 2'b01; // weak not taken
                local_table[i]  <= 2'b01;
                chooser_table[i] <= 2'b01; // weakly prefer local
            end
        end else if (resolve_valid) begin
            // ---- Update global (gshare) counter ----
            case (gshare_table[gshare_idx])
                2'b00: gshare_table[gshare_idx] <= resolve_taken ? 2'b01 : 2'b00;
                2'b01: gshare_table[gshare_idx] <= resolve_taken ? 2'b10 : 2'b00;
                2'b10: gshare_table[gshare_idx] <= resolve_taken ? 2'b11 : 2'b01;
                2'b11: gshare_table[gshare_idx] <= resolve_taken ? 2'b11 : 2'b10;
            endcase

            // ---- Update local counter ----
            case (local_table[local_idx])
                2'b00: local_table[local_idx] <= resolve_taken ? 2'b01 : 2'b00;
                2'b01: local_table[local_idx] <= resolve_taken ? 2'b10 : 2'b00;
                2'b10: local_table[local_idx] <= resolve_taken ? 2'b11 : 2'b01;
                2'b11: local_table[local_idx] <= resolve_taken ? 2'b11 : 2'b10;
            endcase

            // ---- Update chooser ----
            // If global prediction was correct and local was wrong, increment chooser towards global.
            // If local prediction was correct and global was wrong, decrement chooser towards local.
            if (global_pred != local_pred) begin
                if (global_pred == resolve_taken) begin
                    // move chooser towards global (increment)
                    case (chooser_table[chooser_idx])
                        2'b00: chooser_table[chooser_idx] <= 2'b01;
                        2'b01: chooser_table[chooser_idx] <= 2'b10;
                        2'b10: chooser_table[chooser_idx] <= 2'b11;
                        2'b11: chooser_table[chooser_idx] <= 2'b11;
                    endcase
                end else if (local_pred == resolve_taken) begin
                    // move chooser towards local (decrement)
                    case (chooser_table[chooser_idx])
                        2'b11: chooser_table[chooser_idx] <= 2'b10;
                        2'b10: chooser_table[chooser_idx] <= 2'b01;
                        2'b01: chooser_table[chooser_idx] <= 2'b00;
                        2'b00: chooser_table[chooser_idx] <= 2'b00;
                    endcase
                end
            end

            // ---- Update GHR ----
            ghr <= {ghr[GHR_BITS-2:0], resolve_taken};
        end
    end
endmodule
