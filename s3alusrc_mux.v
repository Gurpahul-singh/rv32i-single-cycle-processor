module alusrc_mux (
    input ALUSrc,
    input [31:0] reg_data,
    input [31:0] immediate,
    output [31:0] operandB
);
    
assign operandB = (ALUSrc) ? immediate : reg_data;

endmodule