module Mux2 #(parameter N = 32) (
    input wire [N-1:0] In0, In1,
    input wire Sel,
    output wire [N-1:0] OutP
);

    assign OutP = (
        Sel == 1'b0 ? In0 :
        Sel == 1'b1 ? In1 :
        32'bx
    );

endmodule