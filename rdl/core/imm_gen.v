//immediate generator

module imm_gen (
    input wire [31:0] instr,    //full instruction
    input wire [2:0] type,      //I,S,B,etc.
    output reg [31:0] imm       //immediate
);

    always @(*) begin

        case (type) 
            //note: first variable inside imm represents the sign extension. the next variable is the msb and so on.
    
            3'b000: imm = {{20{instr[31]}}, instr[31:20]};                                              //I-type: immediate operations + loading
            3'b001: imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};                                 //S-type: storing
            3'b010: imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};      //B-type: branching
            3'b011: imm = {instr[31:12], 12'b0};                                                        //U-type: for loading 32 bit numbers into registers since imm are only 12 bits for I-type. U-type instructions split the number into two halves and then bring them into the register together again.
            3'b100: imm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};    //J-type: jumping
            
            default: imm = 32'b0;
        
        endcase

    end

endmodule