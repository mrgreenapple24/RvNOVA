`timescale 1ns/1ps
module predictor_wrapper (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] pc,
    input  wire        resolve_taken,
    input  wire        resolve_valid,
    output wire        predict_taken
);
    `include "../config/predictor_cfg.vh"

    // Default to static not taken if undefined
    // Instantiate based on selected predictor type
    generate
        if (PREDICTOR_TYPE == PRED_STATIC_NOT_TAKEN) begin : gen_static_not_taken
            static_not_taken u_pred (
                .clk(clk),
                .reset(reset),
                .pc(pc),
                .resolve_taken(resolve_taken),
                .resolve_valid(resolve_valid),
                .predict_taken(predict_taken)
            );
        end else if (PREDICTOR_TYPE == PRED_STATIC_TAKEN) begin : gen_static_taken
            static_taken u_pred (
                .clk(clk),
                .reset(reset),
                .pc(pc),
                .resolve_taken(resolve_taken),
                .resolve_valid(resolve_valid),
                .predict_taken(predict_taken)
            );
        end else if (PREDICTOR_TYPE == PRED_1BIT) begin : gen_1bit
            counter_1bit u_pred (
                .clk(clk),
                .reset(reset),
                .pc(pc),
                .resolve_taken(resolve_taken),
                .resolve_valid(resolve_valid),
                .predict_taken(predict_taken)
            );
        end else if (PREDICTOR_TYPE == PRED_2BIT) begin : gen_2bit
            counter_2bit u_pred (
                .clk(clk),
                .reset(reset),
                .pc(pc),
                .resolve_taken(resolve_taken),
                .resolve_valid(resolve_valid),
                .predict_taken(predict_taken)
            );
        end else if (PREDICTOR_TYPE == PRED_GSHARE) begin : gen_gshare
            gshare u_pred (
                .clk(clk),
                .reset(reset),
                .pc(pc),
                .resolve_taken(resolve_taken),
                .resolve_valid(resolve_valid),
                .predict_taken(predict_taken)
            );
        end else if (PREDICTOR_TYPE == PRED_TOURNAMENT) begin : gen_tournament
            tournament u_pred (
                .clk(clk),
                .reset(reset),
                .pc(pc),
                .resolve_taken(resolve_taken),
                .resolve_valid(resolve_valid),
                .predict_taken(predict_taken)
            );
        end else begin : gen_default
            // Fallback to static not taken
            static_not_taken u_pred (
                .clk(clk),
                .reset(reset),
                .pc(pc),
                .resolve_taken(resolve_taken),
                .resolve_valid(resolve_valid),
                .predict_taken(predict_taken)
            );
        end
    endgenerate
endmodule
