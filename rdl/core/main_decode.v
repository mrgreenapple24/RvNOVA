module main_decode(
    input instr[31:0],
    output reg_write, // result written back to reg file?
    output alu_src, // second operand reg(0) or imm(1)
    output mem_write, // writing into memory
    output mem_read, // reading from memory
    output mem_to_reg[1:0], // 00: ALU, 01: memory, 10: PC+4
    output alu_op[2:0], // tells ALU decoder what type of instr it is
    output branch, // PC changes
    output jump // PC changes
    output op1_src // rs1 or PC used
);

always @(*) begin

reg_write  = 0;
alu_src    = 0;
mem_write  = 0;
mem_read   = 0;
mem_to_reg = 2'b00;
alu_op     = 3'b000;
branch     = 0;
jump       = 0;
op1_src = 0;

case (instr[6:2]) // Opcode

    5'b01100: begin // R-type
        reg_write = 1;
        alu_op = 3'b010;
    end
    5'b00100: begin // I-type
        alu_src = 1;
        reg_write = 1;
        alu_op = 3'b011;
    end
    5'b00000: begin // I-type
        alu_src = 1;
        reg_write = 1;
        mem_read = 1;
        mem_to_reg = 2'b01;
        alu_op = 3'b000;
    end
    5'b01000: begin // S-type
        alu_src = 1;
        mem_write = 1;
        alu_op = 3'b000;
    end
    5'b11000: begin // B-type
        branch = 1;
        alu_src = 1;
        alu_op = 3'b001;
    end
    5'b11011: begin // JAL
        jump = 1;
        reg_write = 1;
        alu_src = 1;
        op1_src = 1;
        mem_to_reg = 2'b10;
        alu_op = 3'b000;
    end
    5'b11001: begin // JALR
        jump = 1;
        alu_src = 1;
        mem_to_reg = 2'b10;
        reg_write = 1;
        alu_op = 3'b000;
    end
    5'b01101: begin // U-type
        alu_src = 1;
        reg_write = 1;
        alu_op = 3'b101;
    end
    5'b00101: begin // U-type
        alu_src = 1;
        reg_write = 1;
        op1_src = 1;
        alu_op = 3'b000;
    end
    5'b11100: begin // ecall/ebreak
        if (instr[14:12] == 3'b000) begin
            if (instr[20] == 0) begin
                is_ecall  = 1;
            end else begin
                is_ebreak = 1;
            end
            end 
            else begin
                csr_write = 1; 
                reg_write = 1;
            end
    end

    default: $display("Opcode not recognized");

endcase

end

endmodule