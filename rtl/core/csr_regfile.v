module csr_regfile (
    
    input wire        clk,
    input wire        rst_n,

    input wire        csr_we,           //write enable
    input wire [11:0] csr_waddr,        //write and read address defined separately for trap-handling.
    input wire [11:0] csr_raddr,        //no difference between the two in this module
    input wire [31:0] csr_wdata,

    output reg [31:0] csr_rdata
);

    reg [31:0] mstatus;
    reg [31:0] mtvec;
    reg [31:0] mepc;
    reg [31:0] mcause;
    reg [31:0] mtval;

    always @(*) begin
        case (csr_raddr)

            12'h300: csr_rdata = mstatus;
            12'h305: csr_rdata = mtvec;
            12'h341: csr_rdata = mepc;
            12'h342: csr_rdata = mcause;
            12'h343: csr_rdata = mtval;

            default: csr_rdata = 32'b0;
        
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        
        if (!rst_n) begin
            mstatus <= 32'b0;
            mepc    <= 32'b0;
            mcause  <= 32'b0;
            mtvec   <= 32'b0;
            mtval   <= 32'b0;
        end

        else if (csr_we) begin
           
            case (csr_waddr)

                12'h300: mstatus <= csr_wdata;
                12'h305: mtvec   <= csr_wdata;
                12'h341: mepc    <= csr_wdata;
                12'h342: mcause  <= csr_wdata;
                12'h343: mtval   <= csr_wdata;

                default:                     ;
                
            endcase
        
        end
    
    end

endmodule