module load_store_unit (
    input  wire        clk,
    input  wire [31:0] addr,
    input  wire [31:0] store_data,
    input  wire [2:0]  funct3,
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire [31:0] mem_rdata,

    output wire [31:0] data_addr,
    output wire [31:0] data_wdata,
    output wire [3:0]  data_be,
    output reg  [31:0] load_data,
    output wire        misaligned_exc
);

    assign data_addr = addr;

    // Byte Enable Generation
    reg [3:0] be;
    always @(*) begin
        if (mem_write) begin
            case (funct3[1:0])
                2'b00: begin // SB
                    case (addr[1:0])
                        2'b00: be = 4'b0001;
                        2'b01: be = 4'b0010;
                        2'b10: be = 4'b0100;
                        2'b11: be = 4'b1000;
                    endcase
                end
                2'b01: begin // SH
                    case (addr[1])
                        1'b0: be = 4'b0011;
                        1'b1: be = 4'b1100;
                    endcase
                end
                2'b10: be = 4'b1111; // SW
                default: be = 4'b0000;
            endcase
        end else begin
            be = 4'b0000;
        end
    end
    assign data_be = be;

    // Store Data Alignment
    reg [31:0] wdata;
    always @(*) begin
        case (funct3[1:0])
            2'b00: begin // SB
                case (addr[1:0])
                    2'b00: wdata = {24'b0, store_data[7:0]};
                    2'b01: wdata = {16'b0, store_data[7:0], 8'b0};
                    2'b10: wdata = {8'b0, store_data[7:0], 16'b0};
                    2'b11: wdata = {store_data[7:0], 24'b0};
                endcase
            end
            2'b01: begin // SH
                case (addr[1])
                    1'b0: wdata = {16'b0, store_data[15:0]};
                    1'b1: wdata = {store_data[15:0], 16'b0};
                endcase
            end
            2'b10: wdata = store_data; // SW
            default: wdata = store_data;
        endcase
    end
    assign data_wdata = wdata;

    // Load Data Alignment and Extension
    always @(*) begin
        case (funct3)
            3'b000: begin // LB
                case (addr[1:0])
                    2'b00: load_data = {{24{mem_rdata[7]}},  mem_rdata[7:0]};
                    2'b01: load_data = {{24{mem_rdata[15]}}, mem_rdata[15:8]};
                    2'b10: load_data = {{24{mem_rdata[23]}}, mem_rdata[23:16]};
                    2'b11: load_data = {{24{mem_rdata[31]}}, mem_rdata[31:24]};
                endcase
            end
            3'b001: begin // LH
                case (addr[1])
                    1'b0: load_data = {{16{mem_rdata[15]}}, mem_rdata[15:0]};
                    1'b1: load_data = {{16{mem_rdata[31]}}, mem_rdata[31:16]};
                endcase
            end
            3'b010: load_data = mem_rdata; // LW
            3'b100: begin // LBU
                case (addr[1:0])
                    2'b00: load_data = {24'b0, mem_rdata[7:0]};
                    2'b01: load_data = {24'b0, mem_rdata[15:8]};
                    2'b10: load_data = {24'b0, mem_rdata[23:16]};
                    2'b11: load_data = {24'b0, mem_rdata[31:24]};
                endcase
            end
            3'b101: begin // LHU
                case (addr[1])
                    1'b0: load_data = {16'b0, mem_rdata[15:0]};
                    1'b1: load_data = {16'b0, mem_rdata[31:16]};
                endcase
            end
            default: load_data = mem_rdata;
        endcase
    end

    // Misaligned Access Exception Logic
    assign misaligned_exc = (mem_read || mem_write) && (
        (funct3[1:0] == 2'b10 && addr[1:0] != 2'b00) || // Word access
        (funct3[1:0] == 2'b01 && addr[0]   != 1'b0)    // Half-word access
    );

    // Assertions for Simulation
    // These use immediate assertions compatible with Icarus Verilog's -g2012 mode
    always @(posedge clk) begin
        if (mem_read && mem_write) begin
            $display("ASSERTION FAILED: [%m] Simultaneous mem_read and mem_write");
            $fatal;
        end
        
        if (misaligned_exc) begin
            $display("ASSERTION FAILED: [%m] Misaligned access at addr 0x%h (funct3=0x%h)", addr, funct3);
            // We don't $fatal here because it might be an expected exception later, 
            // but for Phase 1.1 we want to know it happened.
        end
    end

endmodule
