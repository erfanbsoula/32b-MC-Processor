module Condition (
    input wire [1:0] Cnd,
    input wire Z, N, V,
    output wire Ex
);

    assign Ex = (
        Cnd == 2'b00 ? (Z == 1'b1) :
        Cnd == 2'b01 ? (
            Z == 1'b0 &&
            (
                (N == 1'b1 && V == 1'b1) ||
                (N == 1'b0 && V == 1'b0)
            )
        ) :
        Cnd == 2'b10 ? (
            (N == 1'b1 && V == 1'b0) ||
            (N == 1'b0 && V == 1'b1)
        ) :
        Cnd == 2'b11 ? 1'b1 :
        1'bx
    );

endmodule