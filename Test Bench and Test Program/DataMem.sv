`timescale 1ns/1ns

module DataMem (
    input wire Clk, MemRead, MemWrite,
    input wire [31:0] Address, WriteData,
    output wire [31:0] ReadData
);

    wire [8:0] adr;
    assign adr = Address[8:0];

    reg [31:0] regMem [0:511];
    assign ReadData = MemRead ? regMem[adr] : 32'b0;

    always @(posedge Clk) begin
        if (MemWrite)
            regMem[adr] <= WriteData;
    end

    initial begin
        $readmemb("program.txt", regMem);
        $readmemb("data.txt", regMem);
        #1200
        // displaying the results of the test program
        $display("\nmemory[510] = %b", regMem[510]);
        $display("memory[511] = %b\n", regMem[511]);
    end

endmodule