`timescale 1ns/1ps
module counter_2bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] pc,
    input  wire        resolve_taken,
    input  wire        resolve_valid,
    output wire        predict_taken
);
    // 256‑entry 2‑bit saturating counters
    localparam ENTRY_BITS = 8;
    localparam COUNTER_MAX = 2'b11;
    reg [1:0] table [0:(1<<ENTRY_BITS)-1];
    wire [ENTRY_BITS-1:0] idx = pc[ENTRY_BITS+1:2]; // ignore lower 2 bits

    // Prediction is the MSB of the counter (1 = taken)
    assign predict_taken = table[idx][1];

    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < (1<<ENTRY_BITS); i = i + 1) begin
                table[i] <= 2'b01; // weakly not taken initial state
            end
        end else if (resolve_valid) begin
            case (table[idx])
                2'b00: table[idx] <= resolve_taken ? 2'b01 : 2'b00;
                2'b01: table[idx] <= resolve_taken ? 2'b10 : 2'b00;
                2'b10: table[idx] <= resolve_taken ? 2'b11 : 2'b01;
                2'b11: table[idx] <= resolve_taken ? 2'b11 : 2'b10;
            endcase
        end
    end
endmodule
