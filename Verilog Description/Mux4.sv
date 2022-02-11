module Mux4 #(parameter N = 32) (
    input wire [N-1:0] In0, In1, In2, In3,
    input wire [1:0] Sel,
    output wire [N-1:0] OutP
);

    assign OutP = (
        Sel == 2'b00 ? In0 :
        Sel == 2'b01 ? In1 :
        Sel == 2'b10 ? In2 :
        Sel == 2'b11 ? In3 :
        32'bx
    );

endmodule