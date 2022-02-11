module Controller (
    input wire Clk, Rst,
    input wire [31:20] Instruction,
    input wire Z, N, V, C,
    output reg PCWrite, IRWrite,
    output reg IorD, RegSel, RegDst, PCSrc, ALUSrcA,
    output reg [1:0] MemToReg, ALUSrcB,
    output wire RegWrite,
    output wire ZWrite, NWrite, VWrite, CWrite,
    output wire [2:0] ALUOperation,
    output reg MemRead, MemWrite
);

    reg [3:0] PS, NS;
    reg registerWrite, regWriteRType, link;
    reg aluOp, flag;
    wire execute, rTypeWritePermit;

    Condition exCondition (
        .Cnd(Instruction[31:30]),
        .Z(Z), .N(N), .V(V), .Ex(execute)
    );

    assign RegWrite = (
        registerWrite ||
        (rTypeWritePermit && regWriteRType) ||
        (Instruction[26] && link)
    );

    ALUController aluController (
        .ALUOp(aluOp), .OpCode(Instruction[22:20]),
        .RTypeWritePermit(rTypeWritePermit),
        .ALUOperation(ALUOperation)
    );

    FlagController flagController (
        .Flag(flag), .OpCode(Instruction[22:20]),
        .ZWrite(ZWrite), .NWrite(NWrite),
        .VWrite(VWrite), .CWrite(CWrite)
    );

    always @(posedge Clk, Instruction) begin
        if (Rst)
            PS <= 0;
        else
            PS <= NS;
    end

    // behavioral modeling of the combinational logic
    // to determine the next state of the machine
    always @(PS or Instruction) begin
        case (PS)
            4'd0 : NS = 4'd1;
            4'd1 : begin
                if(execute == 1'b1) begin
                    if(Instruction[29:27] == 3'b101)
                        NS = 4'd2;
                    else if(Instruction[29:21] == 9'b010000000)
                        NS = (Instruction[20] == 1'b1) ? 4'd6 : 4'd3;
                    else if(Instruction[29:24] == 6'b000000)
                        NS = 4'd8;
                end
                else
                    NS = 4'd0;
            end
            4'd2 : NS = 4'd0;
            4'd3 : NS = 4'd4;
            4'd4 : NS = 4'd5;
            4'd5 : NS = 4'd0;
            4'd6 : NS = 4'd7;
            4'd7 : NS = 4'd0;
            4'd8 : NS = 4'd9;
            4'd9 : NS = 4'd0;
            default: NS = 0;
        endcase
    end

    // behavioral modeling of the combinational logic
    // to determine the appropriate controlling signals
    always @(PS or Instruction) begin

        {PCWrite, IRWrite, IorD, RegSel, RegDst,
        PCSrc, ALUSrcA, MemToReg, ALUSrcB, link,
        registerWrite, regWriteRType, aluOp,
        flag, MemRead, MemWrite} = 0;

        case (PS)
            4'd0 : begin
                IorD = 1'b0; MemRead = 1'b1;
                IRWrite = 1'b1; aluOp = 1'b1;
                ALUSrcA = 1'b0; ALUSrcB = 2'b11;
                PCSrc = 1'b0; PCWrite = 1'b1;
            end

            4'd1 : begin
                RegSel = 1'b0; aluOp = 1'b1;
                ALUSrcA = 1'b0; ALUSrcB = 2'b01;
            end

            4'd2 : begin
                PCSrc = 1'b1; PCWrite = 1'b1;
                RegDst = 1'b1; MemToReg = 2'b01;
                link = 1'b1;
            end

            4'd3 : begin
                ALUSrcA = 1'b1; ALUSrcB = 2'b10;
                aluOp = 1'b1;
            end

            4'd4 : begin
                IorD = 1'b1; MemRead = 1'b1;
            end

            4'd5 : begin
                RegDst = 1'b0; MemToReg = 2'b00;
                registerWrite = 1'b1;
            end

            4'd6 : begin
                RegSel = 1'b1; ALUSrcA = 1'b1;
                ALUSrcB = 2'b10; aluOp = 1'b1;
            end

            4'd7 : begin
                IorD = 1'b1; MemWrite = 1'b1;
            end

            4'd8 : begin
                flag = 1'b1; ALUSrcA = 1'b1;
                if (Instruction[23] == 1'b0)
                    ALUSrcB = 2'b00;
                else
                    ALUSrcB = 2'b10;
            end

            4'd9 : begin
                RegDst = 1'b0; MemToReg = 2'b10;
                regWriteRType = 1'b1;
            end
        endcase
    end

endmodule