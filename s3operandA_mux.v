module operandA_mux (
    input operandA_sel,
    input [31:0] pc, rs1,
    output [31:0] operandA
);
    
assign operandA = (operandA_sel) ? pc : rs1;

endmodule