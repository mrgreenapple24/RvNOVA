//mux
//choosing pc_next; taking jumps, branches

module pc_mux (

    input wire [31:0] pc,
    input wire [31:0] imm,
    input wire [31:0] rs1_data,     //for jalr

    input wire cmpr,                //comparision to get branch result
    input wire branch,
    input wire jump,
    input wire jalr,                //jalr select

    output reg [31:0] pc_next

);

    wire [31:0] pc_4;
    wire [31:0] branch_targ;
    wire [31:0] jump_targ;

    assign pc_4 = pc + 32'd4;
    assign branch_targ =  pc + imm;
    assign jump_targ = jalr ? ((rs1_data + imm) & ~32'b1) : (pc + imm);

    always @(*) begin
    
        if (jump)
            pc_next = jump_targ;
    
        else if (branch && cmpr)
            pc_next = branch_targ;
    
        else
            pc_next = pc_4;
    
    end

endmodule