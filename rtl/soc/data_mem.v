module data_mem (
    input         clk,
    input  [31:0] addr,
    input  [31:0] wdata,
    input  [3:0]  byte_en,
    input         read_en,
    output [31:0] rdata
);

    reg [31:0] mem [0:16383];

    assign rdata = read_en ? mem[addr[15:2]] : 32'b0;
        
    always @(posedge clk) begin
        if (byte_en[0]) mem[addr[15:2]][7:0]   = wdata[7:0];
        if (byte_en[1]) mem[addr[15:2]][15:8]  = wdata[15:8];
        if (byte_en[2]) mem[addr[15:2]][23:16] = wdata[23:16];
        if (byte_en[3]) mem[addr[15:2]][31:24] = wdata[31:24];
    end
    
endmodule
