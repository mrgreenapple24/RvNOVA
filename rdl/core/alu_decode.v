module alu_decode(
    input alu_op[2:0],
    input funct3[2:0],
    input funct7_b5,

    output alu_ctrl[3:0]
);

localparam ALU_ADD  = 4'b0000;
localparam ALU_SUB  = 4'b0001;
localparam ALU_SLL  = 4'b0010;
localparam ALU_SLT  = 4'b0011;
localparam ALU_SLTU = 4'b0100;
localparam ALU_XOR  = 4'b0101;
localparam ALU_SRL  = 4'b0110;
localparam ALU_SRA  = 4'b0111;
localparam ALU_OR   = 4'b1000;
localparam ALU_AND  = 4'b1001;

always begin

    case(alu_op)

    3'b010: begin // R-type
        case(funct3)
            3'b000: alu_ctrl = funct7_b5 ? ALU_SUB : ALU_ADD;
            3'b001: alu_ctrl = ALU_SLL;
            3'b010: alu_ctrl = ALU_SLT;
            3'b011: alu_ctrl = ALU_SLTU;
            3'b100: alu_ctrl = ALU_XOR;
            3'b101: alu_ctrl = (funct7_b5) ? ALU_SRA : ALU_SRL;
            3'b110: alu_ctrl = ALU_OR;
            3'b111: alu_ctrl = ALU_AND;
    end

    3'b011: begin // I-type
        case(funct3)
            3'b000: alu_ctrl = ALU_ADD;
            3'b001: alu_ctrl = ALU_SLL;
            3'b010: alu_ctrl = ALU_SLT;
            3'b011: alu_ctrl = ALU_SLTU;
            3'b100: alu_ctrl = ALU_XOR;
            3'b101: alu_ctrl = (funct7_b5) ? ALU_SRA : ALU_SRL;
            3'b110: alu_ctrl = ALU_OR;
            3'b111: alu_ctrl = ALU_AND;
    end

    3'b000: alu_ctrl = ALU_ADD;
    3'b001: alu_ctrl = ALU_SUB;

    endcase

end

endmodule