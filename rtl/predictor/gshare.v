`timescale 1ns/1ps
module gshare (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] pc,
    input  wire        resolve_taken,
    input  wire        resolve_valid,
    output wire        predict_taken
);
    // 8-bit Global History Register (GHR)
    localparam GHR_BITS = 8;
    localparam ENTRY_BITS = 8; // 256 entries
    reg [GHR_BITS-1:0] ghr;
    reg [1:0] table [0:(1<<ENTRY_BITS)-1];
    wire [ENTRY_BITS-1:0] pc_idx = pc[ENTRY_BITS+1:2]; // ignore lower 2 bits
    wire [ENTRY_BITS-1:0] idx = pc_idx ^ ghr; // XOR for gshare indexing

    // Prediction is MSB of counter
    assign predict_taken = table[idx][1];

    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ghr <= {GHR_BITS{1'b0}};
            for (i = 0; i < (1<<ENTRY_BITS); i = i + 1) begin
                table[i] <= 2'b01; // weak not taken
            end
        end else if (resolve_valid) begin
            // Update counter
            case (table[idx])
                2'b00: table[idx] <= resolve_taken ? 2'b01 : 2'b00;
                2'b01: table[idx] <= resolve_taken ? 2'b10 : 2'b00;
                2'b10: table[idx] <= resolve_taken ? 2'b11 : 2'b01;
                2'b11: table[idx] <= resolve_taken ? 2'b11 : 2'b10;
            endcase
            // Update GHR (shift left, insert outcome)
            ghr <= {ghr[GHR_BITS-2:0], resolve_taken};
        end
    end
endmodule
