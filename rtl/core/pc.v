module pc (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] pc_next,
    input  wire        sleeping,
    output reg  [31:0] pc
);

    always @(posedge clk or negedge rst) begin
        if (!rst)
            pc <= 32'b0;
        else if (sleeping)          //current sleeping behaviour. WFI instr cycle, sleeping is still 0, pc = pc+4.
            pc <= pc;               //next cycle sleeping becomes 1 and it pauses at pc+4. exactly what we want as when interrupt happens then instr goes on from pc+4.
        else                        //thus there is no wfi-interrupt loop halting the processor forever.
            pc <= pc_next;
    end

endmodule
