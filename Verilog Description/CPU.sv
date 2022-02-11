module CPU (
    input wire Clk, Rst,
    input wire [31:0] MemReadData,
    output wire [31:0] MemAddress, MemWriteData,
    output wire MemRead, MemWrite
);

    wire pcWrite, irWrite, regWrite;
    wire iOrD, regSel, regDst, pcSrc, aluSrcA;
    wire zWrite, nWrite, vWrite, cWrite;
    wire [1:0] memToReg, aluSrcB;
    wire [2:0] aluOperation;
    wire z, n, v, c;
    wire [31:20] cInstruction;

    DataPath dataPath (
        .Clk(Clk), .Rst(Rst),
        .PCWrite(pcWrite), .IRWrite(irWrite), .RegWrite(regWrite),
        .IorD(iOrD), .RegSel(regSel), .RegDst(regDst),
        .PCSrc(pcSrc), .ALUSrcA(aluSrcA), .ALUSrcB(aluSrcB),
        .ZWrite(zWrite), .NWrite(nWrite), .VWrite(vWrite),
        .CWrite(cWrite), .MemToReg(memToReg), .ALUOperation(aluOperation),
        .MemReadData(MemReadData), .CInstruction(cInstruction),
        .Z(z), .N(n), .V(v), .C(c),
        .MemAddress(MemAddress), .MemWriteData(MemWriteData)
    );

    Controller controller (
        .Clk(Clk), .Rst(Rst),
        .Instruction(cInstruction), .Z(z), .N(n), .V(v), .C(c),
        .PCWrite(pcWrite), .IRWrite(irWrite), .IorD(iOrD),
        .RegSel(regSel), .RegDst(regDst), .RegWrite(regWrite),
        .PCSrc(pcSrc), .ALUSrcA(aluSrcA), .ALUSrcB(aluSrcB),
        .MemToReg(memToReg), .ALUOperation(aluOperation),
        .ZWrite(zWrite), .NWrite(nWrite), .VWrite(vWrite), .CWrite(cWrite),
        .MemRead(MemRead), .MemWrite(MemWrite)
    );

endmodule