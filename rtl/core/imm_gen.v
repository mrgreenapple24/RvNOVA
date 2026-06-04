//immediate generator

module imm_gen (
    input wire [31:0] instr,            //full instruction
    output reg [31:0] imm               //immediate
);

    wire [6:0] opcode = instr[6:0];     //I,S,B,etc.

    always @(*) begin

        case (opcode) 

            //note: first variable inside imm represents the sign extension. the next variable is the msb and so on.
    
            7'b0010011,
            7'b0000011,
            7'b1100111:
                imm = {{20{instr[31]}}, instr[31:20]};                                              //I-type: immediate operations + loading

            7'b0100011: 
                imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};                                 //S-type: storing

            7'b1100011:
                imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};      //B-type: branching. imm signifies (PC + imm; offset: 16 -> 4 since addresses are hexa. we skip 4 instructions in the PC)

            7'b0110111,
            7'b0010111:
                imm = {instr[31:12], 12'b0};                                                        //U-type: for loading 32 bit numbers into registers since imm are only 12 bits for I-type. U-type instructions split the number into two halves and then bring them into the register together again

            7'b1101111:
                imm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};    //J-type: jumping. similar to branching but no conditionals
            
            default:
                imm = 32'b0;
        
        endcase

    end

endmodule