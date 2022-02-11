module Adder (
    input wire [31:0] InA, InB,
    output wire [31:0] Res
);

    assign Res = InA + InB;

endmodule