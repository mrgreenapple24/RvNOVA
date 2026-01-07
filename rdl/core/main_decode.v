module main_decode(
    input instr[31:0],
    output reg_write, // result written back to reg file?
    output alu_src, // second operand reg(0) or imm(1)
    output mem_write, // writing into memory
    output mem_read, // reading from memory
    output mem_to_reg, // data written to reg come from mem or alu
    output alu_op[2:0], // tells ALU decoder what type of instr it is
    output branch, // PC changes
    output jump // PC changes
);

always begin

reg_write  = 0;
alu_src    = 0;
mem_write  = 0;
mem_read   = 0;
mem_to_reg = 0;
alu_op     = 3'b000;
branch     = 0;
jump       = 0;

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
        mem_to_reg = 1;
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
    5'b11011: begin // J-type
        jump = 1;
        alu_src = 1;
        alu_op = 3'b000;
        reg_write = 1;
    end
    5'b11001: begin // I-type
        jump = 1;
        alu_src = 1;
        alu_op = 3'b000;
        reg_write = 1;
    end
    5'b01101: begin // U-type
        alu_src = 1;
        reg_write = 1;
        alu_op = 3'b101;
    end
    5'b00101: begin // U-type
        alu_src = 1;
        reg_write = 1;
        alu_op = 3'b101;
    end
    5'b11100: begin // I-type
        // Transfer control to OS
    end
    5'b11100: begin // I-type
        // Transfer control to debugger
    end

    default: $display("Opcode not recognized");

endcase

end

endmodule