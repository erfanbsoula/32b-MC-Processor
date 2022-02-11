module DataPath (
    input wire Clk, Rst,
    input wire PCWrite, IRWrite, RegWrite,
    input wire IorD, RegSel, RegDst, PCSrc, ALUSrcA,
    input wire ZWrite, NWrite, VWrite, CWrite,
    input wire [1:0] MemToReg, ALUSrcB,
    input wire [2:0] ALUOperation,
    input wire [31:0] MemReadData,
    output wire Z, N, V, C,
    output wire [31:20] CInstruction,
    output wire [31:0] MemAddress, MemWriteData
);

    wire [31:0] pcIn, pcOut, instruction, memData;
    wire [31:0] regWriteData, branchOffset, immediate;
    wire [31:0] aRegIn, aRegOut, bRegIn, bRegOut;
    wire [31:0] aluInA, aluInB, aluOut, aluRegOut;
    wire [3:0] readRegB, writeReg;
    wire zRegIn, nRegIn, vRegIn, cRegIn;

    assign CInstruction = instruction[31:20];

    CRegister pCReg (
        .Clk(Clk), .Rst(Rst), .Write(PCWrite),
        .In(pcIn), .Out(pcOut)
    );

    Mux2 muxIorD (
        .In0(pcOut), .In1(aluRegOut),
        .Sel(IorD), .OutP(MemAddress)
    );

    CRegister instructionReg (
        .Clk(Clk), .Rst(Rst), .Write(IRWrite),
        .In(MemReadData), .Out(instruction)
    );

    Register memDR (
        .Clk(Clk), .Rst(Rst),
        .In(MemReadData), .Out(memData)
    );

    Mux2 #( .N(4) ) muxRegSel (
        .In0(instruction[3:0]), .In1(instruction[15:12]),
        .Sel(RegSel), .OutP(readRegB)
    );

    Mux2 #( .N(4) ) muxRegDst (
        .In0(instruction[15:12]), .In1(4'd15),
        .Sel(RegDst), .OutP(writeReg)
    );

    Mux4 muxRegWriteData (
        .In0(memData), .In1(pcOut),
        .In2(aluRegOut), .In3(32'd0),
        .Sel(MemToReg), .OutP(regWriteData)
    );

    RegisterFile registerFile (
        .Clk(Clk), .Rst(Rst), .RegWrite(RegWrite),
        .ReadRegister1(instruction[19:16]),
        .ReadRegister2(readRegB),
        .WriteRegister(writeReg),
        .WriteData(regWriteData),
        .DataRead1(aRegIn), .DataRead2(bRegIn)
    );

    Register aReg (
        .Clk(Clk), .Rst(Rst),
        .In(aRegIn), .Out(aRegOut)
    );

    Register bReg (
        .Clk(Clk), .Rst(Rst),
        .In(bRegIn), .Out(bRegOut)
    );

    assign MemWriteData = bRegOut;

    SignExtend #( .NI(26) ) signExtendBrOffset (
        .In(instruction[25:0]), .Out(branchOffset)
    );

    SignExtend #( .NI(12) ) signExImmediate (
        .In(instruction[11:0]), .Out(immediate)
    );

    Mux2 muxALUSrcA (
        .In0(pcOut), .In1(aRegOut),
        .Sel(ALUSrcA), .OutP(aluInA)
    );

    Mux4 muxALUSrcB (
        .In0(bRegOut), .In1(branchOffset),
        .In2(immediate), .In3(32'd1),
        .Sel(ALUSrcB), .OutP(aluInB)
    );

    ALU alu (
        .InA(aluInA), .InB(aluInB), .Res(aluOut),
        .ALUOperation(ALUOperation), .Z(zRegIn),
        .N(nRegIn), .V(vRegIn), .C(cRegIn)
    );

    Register aluReg (
        .Clk(Clk), .Rst(Rst),
        .In(aluOut), .Out(aluRegOut)
    );

    Mux2 muxPCSrc (
        .In0(aluOut), .In1(aluRegOut),
        .Sel(PCSrc), .OutP(pcIn)
    );

    CRegister #( .N(1) ) zReg (
        .Clk(Clk), .Rst(Rst), .Write(ZWrite),
        .In(zRegIn), .Out(Z)
    );

    CRegister #( .N(1) ) nReg (
        .Clk(Clk), .Rst(Rst), .Write(NWrite),
        .In(nRegIn), .Out(N)
    );

    CRegister #( .N(1) ) vReg (
        .Clk(Clk), .Rst(Rst), .Write(VWrite),
        .In(vRegIn), .Out(V)
    );

    CRegister #( .N(1) ) cReg (
        .Clk(Clk), .Rst(Rst), .Write(CWrite),
        .In(cRegIn), .Out(C)
    );

endmodule