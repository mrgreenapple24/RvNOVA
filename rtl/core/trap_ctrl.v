module trap_ctrl (
    input  wire [31:0] pc,                       //our current pc
    input  wire [31:0] fault_instr,              //instruction
    input  wire [31:0] fault_addr,

    input  wire        illegal_instr,
    input  wire        ecall,
    input  wire        ebreak,
    input  wire        instr_misalign,
    input  wire        load_misalign,
    input  wire        store_misalign,           //all of these are exceptions that can occur

    input  wire        ext_irq,                  //interrupt that can occur (maskable thru MIE). hardcoded to 0 for now since requires new input to top file

    input  wire [31:0] csr_mstatus,
    input  wire [31:0] csr_mtvec,
    input  wire [31:0] csr_mcause,
    input  wire [31:0] csr_mtval,
    input  wire [31:0] csr_mie,
    input  wire [31:0] csr_mip,
    input  wire [31:0] csr_mepc,                 //csr values

    input  wire        csr_mret,                 //decoder SEES mret => control signal becomes 1

    output wire        trap_taken,               //is a trap being executed (handled)
    output wire        mret_taken,               //effectively the same as csr_mret for single-cycle. difference is that this becomes 1 when trap_ctrl accepts and starts executing mret op

    output wire        interrupt_pending,

    output reg  [31:0] trap_target_pc,           //the pc that corresponds to trap_taken

    output reg         csr_trap_we,              //write-enable

    output reg  [31:0] trap_mepc,
    output reg  [31:0] trap_mcause,
    output reg  [31:0] trap_mtval,
    output reg  [31:0] trap_mstatus
);

    assign interrupt_pending = ext_irq && csr_mie[11] && csr_mip[11] && csr_mstatus[3];          //the 4th bit of MSTATUS is master interrupt enable

    assign trap_taken = illegal_instr || ecall || ebreak || instr_misalign || load_misalign || store_misalign || interrupt_pending;
    assign mret_taken = csr_mret;

    wire [1:0]  mtvec_mode;
    wire [31:0] mtvec_base;

    assign mtvec_mode = csr_mtvec[1:0];
    assign mtvec_base = {csr_mtvec[31:2], 2'b00};
    
    always @(*) begin

        csr_trap_we    = 0;
        trap_mepc      = csr_mepc;
        trap_mcause    = csr_mcause;
        trap_mtval     = 32'h0;
        trap_mstatus   = csr_mstatus;
        trap_target_pc = 32'b0;

        if (trap_taken) begin 
            
            csr_trap_we     = 1;
            trap_mepc       = pc;
            trap_mstatus[7] = csr_mstatus[3];
            trap_mstatus[3] = 1'b0;

            if (interrupt_pending && (mtvec_mode == 2'b01))         //mtvec vector mode only exists for interrupts. currently we support only one.
                trap_target_pc = mtvec_base + 32'd44;               //BASE + 4*CAUSE.
            else
                trap_target_pc = mtvec_base;                        //if future interrupts are scaled, trap_target_pc can be assigned inside if else blocks
            
            if (instr_misalign) begin
                trap_mcause     = 32'h0;
                trap_mtval      = pc;
            end
            else if (illegal_instr) begin
                trap_mcause     = 32'h2;
                trap_mtval      = fault_instr;
            end
            else if (ebreak) begin
                trap_mcause     = 32'h3;
                trap_mtval      = 0;
            end
            else if (load_misalign) begin
                trap_mcause     = 32'h4;
                trap_mtval      = fault_addr;
            end
            else if (store_misalign) begin
                trap_mcause     = 32'h6;
                trap_mtval      = fault_addr;
            end
            else if (ecall) begin
                trap_mcause     = 32'hB;
                trap_mtval      = 0;

            end
            else if (interrupt_pending) begin
                trap_mcause     = 32'h8000000B;
                trap_mtval      = 0;
            end
        
        end

        else if (mret_taken) begin
            csr_trap_we     = 1;
            trap_target_pc  = csr_mepc;
            trap_mstatus[3] = csr_mstatus[7];
            trap_mstatus[7] = 1'b1;
        end

    end

endmodule
