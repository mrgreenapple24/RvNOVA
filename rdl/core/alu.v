module alu (
	input wire [31:0] a,
	input wire [31:0] b,
	input wire [3:0] alu_ctrl, //from alu_decoder
	output reg [31:0] op,
	output wire zero
);

    wire [3:0] add = 4'b0000;
    wire [3:0] sub = 4'b0001;
    wire [3:0] sll = 4'b0010;
    wire [3:0] slt = 4'b0011;
    wire [3:0] sltu = 4'b0100;
    wire [3:0] _xor = 4'b0101;
    wire [3:0] srl = 4'b0110;
    wire [3:0] sra = 4'b0111;
    wire [3:0] _or = 4'b1000;
    wire [3:0] _and = 4'b1001;

	always @(*) begin
		case (alu_ctrl)
			add: op = a + b;										//ADD
			sub: op = a - b;										//SUBTRACT
			sll: op = a << b[4:0];									//SHIFT LEFT LOGICAL
			slt: op = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;	//SET LESS THAN
			sltu: op = (a < b) ? 32'd1 : 32'd0;						//SET LESS THAN (U), ZERO-EXTENDS
			_xor: op = a ^ b;										//XOR
			srl: op = a >> b[4:0];									//SHIFT RIGHT LOGICAL
			sra: op = $signed(a) >>> b[4:0];						//SHIFT RIGHT ARITHEMATIC, MSB-EXTENDS
			_or: op = a | b;										//OR
			_and: op = a & b;										//AND
			default: op = 32'd0;										//DEFAULT
		endcase
	end

	assign zero = (op == 32'd0);

endmodule
