module regfile (
    input wire clk, // clock
    input wire reset, // active low reset
    input wire we, // write enable
    input wire [4:0] rs1_addr, // reg 1 address
    input wire [4:0] rs2_addr, // reg 2 address
    input wire [4:0] rd_addr, // dest reg address
    input wire [31:0] w_data, // write data

    output wire [31:0] rs1_data, // read reg 1 data
    output wire [31:0] rs2_data // read reg 2 data
);

reg [31:0] reg_array[31:0];

integer i;

always @(posedge clk) begin
    if (!reset) begin
        for (int i = 0; i < 32; i++) begin
            reg_array[i] <= 0;
        end
    end else if (we && (rd_addr != 5'b00000)) begin
        reg_array[rd_addr] <= w_data;
    end
end

assign rs1_data = (rs1_addr == 5'b0) ? {32{1'b0}} : reg_array[rs1_addr];
assign rs2_data = (rs2_addr == 5'b0) ? {32{1'b0}} : reg_array[rs2_addr];

endmodule