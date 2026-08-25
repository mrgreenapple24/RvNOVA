`timescale 1ns/1ps
module static_not_taken (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] pc,
    input  wire        resolve_taken,
    input  wire        resolve_valid,
    output wire        predict_taken
);
    assign predict_taken = 1'b0;
endmodule
