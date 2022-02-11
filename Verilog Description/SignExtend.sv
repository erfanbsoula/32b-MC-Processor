module SignExtend #(parameter NI = 16, NO = 32) (
    input wire [NI-1:0] In,
    output wire [NO-1:0] Out
);

    assign Out = { {(NO-NI) {In[NI-1]}}, In };

endmodule