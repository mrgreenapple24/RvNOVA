module csr_regfile (
    input  wire        clk,
    input  wire        rst_n,

    input  wire        instr_retired,
    input  wire        ext_irq,
    input  wire        csr_access,       //to check if CSR is being accessed at ALL otherwise every non-CSR instr will generate an exception

    input  wire        csr_we,           //write enable
    input  wire [11:0] csr_waddr,        //write and read address defined separately for trap-handling.
    input  wire [11:0] csr_raddr,        //no difference between the two in this module
    input  wire [31:0] csr_wdata,

    input  wire        trap_we,          //trap write-enable (higher priority than normal csrr instr)
    input  wire [31:0] trap_mepc,
    input  wire [31:0] trap_mstatus,
    input  wire [31:0] trap_mtval,
    input  wire [31:0] trap_mcause,

    output reg  [31:0] csr_rdata,        //for normal csrr instr

    output wire [31:0] csr_mstatus,
    output wire [31:0] csr_mepc,
    output wire [31:0] csr_mcause,
    output wire [31:0] csr_mtvec,
    output wire [31:0] csr_misa,
    output wire [31:0] csr_mscratch,
    output wire [31:0] csr_mcycle,
    output wire [31:0] csr_minstret,
    output wire [31:0] csr_mie,
    output wire [31:0] csr_mip,
    output wire [31:0] csr_mtval,        //for trap executions

    output wire        csr_ilgl_instr
);

    wire       csr_read_check;             //for illegal read/write access check
    wire       csr_write_check;            //read-only CSRs
    
    reg [31:0] mstatus;
    reg [31:0] mtvec;
    reg [31:0] mepc;
    reg [31:0] mcause;
    reg [31:0] mtval;
    reg [31:0] misa;
    reg [31:0] mscratch;
    reg [31:0] mcycle;
    reg [31:0] minstret;
    reg [31:0] mie;
    reg [31:0] mip;

    assign csr_read_check =
       (csr_raddr == 12'h300)
    || (csr_raddr == 12'h301)
    || (csr_raddr == 12'h304)
    || (csr_raddr == 12'h305)
    || (csr_raddr == 12'h340)
    || (csr_raddr == 12'h341)
    || (csr_raddr == 12'h342)
    || (csr_raddr == 12'h343)
    || (csr_raddr == 12'h344)
    || (csr_raddr == 12'hB00)
    || (csr_raddr == 12'hB02);

    assign csr_write_check = (csr_waddr == 12'h301) || (csr_waddr == 12'h344);  // misa mip

    always @(*) begin

        case (csr_raddr)

            12'h300: csr_rdata = mstatus;
            12'h301: csr_rdata = misa;
            12'h304: csr_rdata = mie;
            12'h305: csr_rdata = mtvec;
            12'h340: csr_rdata = mscratch;
            12'h341: csr_rdata = mepc;
            12'h342: csr_rdata = mcause;
            12'h343: csr_rdata = mtval;
            12'h344: csr_rdata = mip;
            12'hB00: csr_rdata = mcycle;
            12'hB02: csr_rdata = minstret;

            default: begin
                csr_rdata = 32'b0;
            end
        
        endcase

    end

    always @(posedge clk or negedge rst_n) begin
        
        if (!rst_n) begin
            mstatus  <= 32'b0;
            mepc     <= 32'b0;
            mcause   <= 32'b0;
            mtvec    <= 32'b0;
            mtval    <= 32'b0;
            misa     <= 32'h40000100;
            mscratch <= 32'b0;
            mie      <= 32'b0;
            mip      <= 32'b0;
            mcycle   <= 32'b0;
            minstret <= 32'b0;
        end
        
        else begin
        
            mcycle  <= mcycle + 1;

            mip[11] <= ext_irq;

            if (instr_retired) begin
            minstret <= minstret + 1;
            end

            if (trap_we) begin                             //higher priority than normal csr instr cuz exceptions and interrupts should be handled before an instruction is completed
                mstatus <= trap_mstatus;
                mepc    <= trap_mepc;
                mcause  <= trap_mcause;
                mtval   <= trap_mtval;
            end

            else if (csr_we) begin
            
                case (csr_waddr)                           //misa and mip dont have write permissions, first is a constant, second is hard-coded to ext_irq

                    12'h300: mstatus  <= csr_wdata;
                    12'h304: mie      <= csr_wdata;
                    12'h305: mtvec    <= csr_wdata;
                    12'h340: mscratch <= csr_wdata;
                    12'h341: mepc     <= csr_wdata;
                    12'h342: mcause   <= csr_wdata;
                    12'h343: mtval    <= csr_wdata;
                    12'hB00: mcycle   <= csr_wdata;
                    12'hB02: minstret <= csr_wdata;

                    default:                     ;
                    
                endcase
            
            end
    
        end

    end

    assign csr_mstatus  = mstatus;
    assign csr_mtvec    = mtvec;
    assign csr_mepc     = mepc;
    assign csr_mcause   = mcause;
    assign csr_mtval    = mtval;
    assign csr_misa     = misa;
    assign csr_mscratch = mscratch;
    assign csr_mcycle   = mcycle;
    assign csr_minstret = minstret;
    assign csr_mie      = mie;
    assign csr_mip      = mip;

    assign csr_ilgl_instr = (csr_access && !csr_read_check) || (csr_we && csr_write_check);

endmodule

/* Trade-off here: Technically we could have used the default case to generate the csr_illegal_instruction signal.

Chose otherwise since 
i) We'll have to update the read csr data block to have a check for csr access or not.
ii) Write block has to be sequential. While trap handling is combinational. Since the csr_illegal_instruction signal must generate
before the clock cycle is over, it has to generate in the combination always block. SO we have to add a write to csr check in the
combination block as well (keeping the sequential block obviously) which I felt was bad design.

On a similar length, csr illegal access and decoder illegal instruction have different signals even though the exception generated
is the same. Why the extra logic? Because it is easier to decode and the reason for the exception is coming from two different modules
so having two different signals seems cleaner. 

ALSO, NOTE: RISC-V does not support reading to one CSR and writing to another, but if it did then our csr_read_check logic falls apart.
Currently out read and write address are the same so not a problem.*/
