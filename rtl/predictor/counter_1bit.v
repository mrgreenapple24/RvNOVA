`timescale 1ns/1ps
module counter_1bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] pc,
    input  wire        resolve_taken,
    input  wire        resolve_valid,
    output wire        predict_taken
);
    // Simple 256‑entry table indexed by lower bits of PC
    localparam ENTRY_BITS = 8;
    reg table [0:(1<<ENTRY_BITS)-1];
    wire [ENTRY_BITS-1:0] idx = pc[ENTRY_BITS+1:2]; // ignore lower 2 bits (word aligned)

    assign predict_taken = table[idx];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            integer i;
            for (i = 0; i < (1<<ENTRY_BITS); i = i + 1) begin
                table[i] <= 1'b0;
            end
        end else if (resolve_valid) begin
            table[idx] <= resolve_taken; // update with actual outcome
        end
    end
endmodule
