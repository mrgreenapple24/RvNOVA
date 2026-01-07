module alu (
	input wire [31:0] a,
	input wire [31:0] b,
	input wire [3:0] alu_ctrl, //from alu_decoder
	output reg [31:0] op,
	output wire zero
);

	always @(*) begin
		case (alu_ctrl)
			4'b0000: op = a + b;										//ADD
			4'b0001: op = a - b;										//SUBTRACT
			4'b0010: op = a << b[4:0];									//SHIFT LEFT LOGICAL
			4'b0011: op = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;	//SET LESS THAN
			4'b0100: op = (a < b) ? 32'd1 : 32'd0;						//SET LESS THAN (U), ZERO-EXTENDS
			4'b0101: op = a ^ b;										//XOR
			4'b0110: op = a >> b[4:0];									//SHIFT RIGHT LOGICAL
			4'b0111: op = $signed(a) >>> b[4:0];						//SHIFT RIGHT ARITHEMATIC, MSB-EXTENDS
			4'b1000: op = a | b;										//OR
			4'b1001: op = a & b;										//AND
			default: op = 32'd0;										//DEFAULT
		endcase
	end

	assign zero = (op == 32'd0);

endmodule