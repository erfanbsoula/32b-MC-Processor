module CRegister #(parameter N = 32) (
	input wire Clk, Rst, Write,
	input wire [N-1:0] In,
	output reg [N-1:0] Out
);

    always @(posedge Clk) begin
        if (Rst)
            Out <= 0;
        else if (Write)
            Out <= In;
    end

endmodule