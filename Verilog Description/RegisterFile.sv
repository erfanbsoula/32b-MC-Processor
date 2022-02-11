module RegisterFile (
    input wire Clk, Rst, RegWrite,
    input wire [3:0] ReadRegister1, ReadRegister2, WriteRegister,
    input wire [31:0] WriteData,
    output wire [31:0] DataRead1, DataRead2
);
    integer n;

    reg [31:0] registerArray [1:15];
    assign DataRead1 = (ReadRegister1 == 4'd0) ? 32'd0 : registerArray[ReadRegister1];
    assign DataRead2 = (ReadRegister2 == 4'd0) ? 32'd0 : registerArray[ReadRegister2];

    always @(posedge Clk) begin
        if(Rst) begin
            for (n = 1; n < 16; n = n + 1) begin
                registerArray[n] <= 32'd0;
            end
        end
        else if (RegWrite && (WriteRegister != 4'd0) )
            registerArray[WriteRegister] <= WriteData;
    end

endmodule