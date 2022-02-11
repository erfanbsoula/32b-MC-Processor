module ALUController (
    input wire ALUOp,
    input wire [2:0] OpCode,
    output wire RTypeWritePermit,
    output wire [2:0] ALUOperation
);

    assign ALUOperation = (
        ALUOp == 1'b1 ? 3'b000 :
        ALUOp == 1'b0 ? (
            OpCode == 3'b000 ? 3'b000 :
            OpCode == 3'b001 ? 3'b001 :
            OpCode == 3'b010 ? 3'b001 :
            OpCode == 3'b011 ? 3'b010 :
            OpCode == 3'b100 ? 3'b011 :
            OpCode == 3'b101 ? 3'b010 :
            OpCode == 3'b110 ? 3'b001 :
            OpCode == 3'b111 ? 3'b100 :
            3'bx
        ) :
        3'bx
    );

    assign RTypeWritePermit = (
        ALUOp == 1'b1 ? 1'b0 : (
            OpCode == 3'b101 ? 1'b0 :
            OpCode == 3'b110 ? 1'b0 :
            1'b1
        ) 
    );

endmodule
