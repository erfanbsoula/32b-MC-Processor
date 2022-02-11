module FlagController (
    input wire Flag,
    input wire [2:0] OpCode,
    output wire ZWrite, NWrite, VWrite, CWrite
);

    assign ZWrite = Flag;
    assign NWrite = Flag;
    assign VWrite = (
        OpCode == 3'b011 ? 1'b0 :
        OpCode == 3'b100 ? 1'b0 :
        OpCode == 3'b101 ? 1'b0 :
        OpCode == 3'b111 ? 1'b0 :
        Flag
    );

    assign CWrite = (
        OpCode == 3'b011 ? 1'b0 :
        OpCode == 3'b100 ? 1'b0 :
        OpCode == 3'b101 ? 1'b0 :
        OpCode == 3'b111 ? 1'b0 :
        Flag
    );

endmodule