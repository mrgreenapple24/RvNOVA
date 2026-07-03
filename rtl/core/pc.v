module pc (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] pc_next,
    input  wire        sleeping,
    input  wire        stall,
    output reg  [31:0] pc
);

    always @(posedge clk or negedge rst) begin
        if (!rst)
            pc <= 32'b0;
        else if (sleeping || stall)
            pc <= pc;
        else
            pc <= pc_next;
    end

endmodule
