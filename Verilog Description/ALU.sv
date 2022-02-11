module ALU (
    input wire [31:0] InA, InB,
    input wire [2:0] ALUOperation,
    output reg [31:0] Res,
    output wire Z, N, V,
    output reg C
);

    wire [31:0] op2;
    assign op2 = -InB;

    assign Z = (Res == 0) ? 1'b1 : 1'b0;
    assign N = Res[31];
    assign V = (
        ALUOperation == 3'b000 ? (
            (InA[31] & InB[31] & ~Res[31]) |
            (~InA[31] & ~InB[31] & Res[31])
        ) :
        ALUOperation == 3'b001 ? (
            (InA[31] & op2[31] & ~Res[31]) |
            (~InA[31] & ~op2[31] & Res[31])
        ) :
        1'b0
    );

    always @(InA or InB or ALUOperation) begin
        case (ALUOperation)
            3'b000 : {C, Res} = InA + InB;
            3'b001 : {C, Res} = InA + op2;
            3'b010 : begin Res = InA & InB; C = 0; end
            3'b011 : begin Res = op2; C = 0; end
            3'b100 : begin Res = InB; C = 0; end
            default: begin Res = 0; C = 0; end
        endcase
    end

endmodule