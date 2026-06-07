module alu (
	input wire [31:0] a,
	input wire [31:0] b,
	input wire [3:0] alu_ctrl, //from alu_decoder
	output reg [31:0] op,
	output wire zero
);

    wire [3:0] ALU_ADD 	 = 4'b0000;
    wire [3:0] ALU_SUB 	 = 4'b0001;
    wire [3:0] ALU_SLL 	 = 4'b0010;
    wire [3:0] ALU_SLT 	 = 4'b0011;
    wire [3:0] ALU_SLTU  = 4'b0100;
    wire [3:0] ALU_XOR   = 4'b0101;
    wire [3:0] ALU_SRL   = 4'b0110;
    wire [3:0] ALU_SRA   = 4'b0111;
    wire [3:0] ALU_OR 	 = 4'b1000;
    wire [3:0] ALU_AND 	 = 4'b1001;
    wire [3:0] ALU_PASSB = 4'b1010;

	always @(*) begin
		case (alu_ctrl)
			ALU_ADD:   op = a + b;										//ADD
			ALU_SUB:   op = a - b;										//SUBTRACT
			ALU_SLL:   op = a << b[4:0];								//SHIFT LEFT LOGICAL
			ALU_SLT:   op = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;	//SET LESS THAN
			ALU_SLTU:  op = (a < b) ? 32'd1 : 32'd0;					//SET LESS THAN (U), ZERO-EXTENDS
			ALU_XOR:   op = a ^ b;										//XOR
			ALU_SRL:   op = a >> b[4:0];								//SHIFT RIGHT LOGICAL
			ALU_SRA:   op = $signed(a) >>> b[4:0];						//SHIFT RIGHT ARITHEMATIC, MSB-EXTENDS
			ALU_OR:    op = a | b;										//OR
			ALU_AND:   op = a & b;										//AND
			ALU_PASSB: op = b;                                         	//PASS B (for LUI)
			default:   op = 32'd0;										//DEFAULT
		endcase
	end

	assign zero = (op == 32'd0);

endmodule
