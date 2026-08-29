`timescale 1ns/1ps
module predictor_tb;
    // Parameters
    parameter NUM_ITER = 100000; // number of branch predictions

    // Clock
    reg clk = 0;
    always #5 clk = ~clk; // 100MHz clock

    // Reset
    reg reset = 1'b1;
    initial begin
        #20 reset = 1'b0;
    end

    // Signals to predictor
    reg [31:0] pc;
    reg resolve_taken;
    reg resolve_valid;
    wire predict_taken;

    // Statistics
    integer total = 0;
    integer mispred = 0;
    // CSV file handle
    integer fd;

    // Instantiate predictor wrapper (predictor type selected via compile-time macro)
    predictor_wrapper u_pred (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .resolve_taken(resolve_taken),
        .resolve_valid(resolve_valid),
        .predict_taken(predict_taken)
    );

    // Random stimulus
    integer i;
    initial begin
        // Wait for reset deassertion
        @(negedge reset);
        // Open CSV file for this predictor
        fd = $fopen($sformatf("results_%0d.csv", `PREDICTOR_TYPE), "w");
        $fdisplay(fd, "total,mispred,accuracy");
        for (i = 0; i < NUM_ITER; i = i + 1) begin
            // Generate random PC (aligned to 4 bytes)
            pc = {$random} & 32'hFFFF_FFFC;
            // Random actual outcome
            resolve_taken = $urandom % 2;
            resolve_valid = 1'b1;
            // Wait one clock cycle for prediction to be registered
            @(posedge clk);
            // Compare prediction with actual outcome
            total = total + 1;
            if (predict_taken !== resolve_taken) begin
                mispred = mispred + 1;
            end
            // Give time for predictor to update internal state
            @(posedge clk);
        end
        // Finish simulation
        $display("=== Branch Predictor Statistics ===");
        $display("Total branches   : %0d", total);
        $display("Mispredictions   : %0d", mispred);
        if (total != 0) begin
            $display("Accuracy (%%)    : %0f", 100.0 * (total - mispred) / total);
        end
        // Write results to CSV
        if (fd != 0) begin
            $fdisplay(fd, "%0d,%0d,%0f", total, mispred, (total != 0) ? (100.0 * (total - mispred) / total) : 0.0);
            $fclose(fd);
        end
        $finish;
    end
endmodule
