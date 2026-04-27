//mux
//choosing pc_next; taking jumps, branches

module pc_mux (

    input wire [31:0] pc,
    input wire [31:0] imm,
    input wire [31:0] rs1_data,     //for jalr

    input wire [2:0]  funct3,       // To distinguish branch types
    input wire [31:0] alu_result,   // For SLT/SLTU results
    input wire        alu_zero,     // For BEQ/BNE results
    input wire        branch,
    input wire        jump,
    input wire        jalr,         //jalr select

    output reg [31:0] pc_next

);

    wire [31:0] pc_4;
    wire [31:0] branch_targ;
    wire [31:0] jump_targ;
    reg         take_branch;

    assign pc_4 = pc + 32'd4;
    assign branch_targ =  pc + imm;
    assign jump_targ = jalr ? ((rs1_data + imm) & ~32'b1) : (pc + imm);

    always @(*) begin
        case(funct3)
            3'b000: take_branch = alu_zero;           // BEQ
            3'b001: take_branch = !alu_zero;          // BNE
            3'b100: take_branch = alu_result[0];      // BLT
            3'b101: take_branch = !alu_result[0];     // BGE
            3'b110: take_branch = alu_result[0];      // BLTU
            3'b111: take_branch = !alu_result[0];     // BGEU
            default: take_branch = 1'b0;
        endcase
    end

    always @(*) begin
    
        if (jump)
            pc_next = jump_targ;
    
        else if (branch && take_branch)
            pc_next = branch_targ;
    
        else
            pc_next = pc_4;
    
    end

endmodule
