`timescale 1ns/1ns

module TestBench ();

    reg clk, rst;

    wire [31:0] memReadData, memAddress, memWriteData;
    wire memRead, memWrite;

    DataMem dataMemory (
        .Clk(clk), .MemRead(memRead), .MemWrite(memWrite),
        .Address(memAddress), .WriteData(memWriteData),
        .ReadData(memReadData)
    );

    CPU cpu (
        .Clk(clk), .Rst(rst),
        .MemReadData(memReadData), .MemAddress(memAddress),
        .MemWriteData(memWriteData), .MemRead(memRead),
        .MemWrite(memWrite)
    );

    // modeling computer clock
    always #1 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        #2
        rst = 0;
        #1200
        $stop;
    end

endmodule