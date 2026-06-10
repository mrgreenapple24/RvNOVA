module main_decode(
    input wire  [6:0]  opcode,
    input wire  [2:0]  funct3,
    input wire  [11:0] funct12,
    input wire  [4:0]  csr_src,

    output reg         reg_write,   // writeback to regfile
    output reg         alu_src,      // 0 = rs2, 1 = imm
    output reg         mem_write,
    output reg         mem_read,
    output reg  [1:0]  reg_mux,   // 00=ALU, 01=MEM, 10=PC+4, 11=SYS
    output reg  [2:0]  alu_op,
    output reg         branch,
    output reg         jump,
    output reg         op1_src,      // 0 = rs1, 1 = PC
    output reg         is_ecall,
    output reg         is_ebreak,
    output reg         csr_write,
    output reg         jalr,
    output wire [2:0]  csr_op
);

assign csr_op = funct3;

always @(*) begin
    // defaults
    reg_write  = 0;
    alu_src    = 0;
    mem_write  = 0;
    mem_read   = 0;
    reg_mux    = 2'b00;
    alu_op     = 3'b000;
    branch     = 0;
    jump       = 0;
    op1_src    = 0;
    is_ecall   = 0;
    is_ebreak  = 0;
    csr_write  = 0;
    jalr       = 0;

    case (opcode[6:2])

        5'b01100: begin // R-type
            reg_write = 1;
            alu_op    = 3'b010;
        end

        5'b00100: begin // I-type ALU
            alu_src   = 1;
            reg_write = 1;
            alu_op    = 3'b011;
        end

        5'b00000: begin // LOAD
            alu_src    = 1;
            reg_write  = 1;
            mem_read   = 1;
            reg_mux    = 2'b01;
            alu_op     = 3'b000;
        end

        5'b01000: begin // STORE
            alu_src   = 1;
            mem_write = 1;
            alu_op    = 3'b000;
        end

        5'b11000: begin // BRANCH
            branch = 1;
            alu_src = 0;
            alu_op  = 3'b001;
        end

        5'b11011: begin // JAL
            jump       = 1;
            reg_write  = 1;
            alu_src    = 1;
            op1_src    = 1;
            reg_mux    = 2'b10;
            alu_op     = 3'b000;
        end

        5'b11001: begin // JALR
            jump       = 1;
            alu_src    = 1;
            reg_mux    = 2'b10;
            reg_write  = 1;
            alu_op     = 3'b000;
            jalr       = 1;
        end

        5'b01101: begin // LUI
            alu_src   = 1;
            reg_write = 1;
            alu_op    = 3'b101;
        end

        5'b00101: begin // AUIPC
            alu_src   = 1;
            reg_write = 1;
            op1_src   = 1;
            alu_op    = 3'b000;
        end

        5'b11100: begin // SYSTEM (ecall/ebreak/csr)
            if (funct3 == 3'b000) begin
                if (funct12 == 12'h000)
                    is_ecall = 1;
                else if (funct12 == 12'h001)
                    is_ebreak = 1;
            end
            else begin
                
                reg_mux    = 2'b11;
                reg_write  = 1;

                case (funct3)
                    3'b001:  csr_write = 1;                 // CSRRW
                    3'b010:  csr_write = (csr_src != 5'd0); // CSRRS
                    3'b011:  csr_write = (csr_src != 5'd0); // CSRRC
                    3'b101:  csr_write = 1;                 // CSRRWI
                    3'b110:  csr_write = (csr_src != 5'd0); // CSRRSI
                    3'b111:  csr_write = (csr_src != 5'd0); // CSRRCI
                    
                    default: csr_write = 0;
                endcase

            end
        end

        default: begin
            // do nothing
        end

    endcase
end

endmodule
