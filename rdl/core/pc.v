//pc register logic.
//note: instr: 32 bits = 4 bytes. each instr takes 4 bytes while memory is 1 byte.
//therefore a second instruction will be pc+4 (unless branch or jump)

module pc (
    input wire clk,
    input wire rst,
    input wire [31:0] pc_next,
    output reg [31:0] pc
);

    always @(posedge clk | negedge rst) begin       //negedge since registers are active low

        if(!rst)
            pc <= 32'b0;
        else
            pc <= pc_next;
            
    end

endmodule