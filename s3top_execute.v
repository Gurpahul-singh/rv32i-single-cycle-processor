module execute_top (
    input [31:0] pc,rs1,rs2,immediate,
    input [3:0] ALUControl,
    input ALUSrc,operandA_sel,
    output [31:0] result,
    output zero_flag
);
    
wire [31:0] operandA,operandB;

operandA_mux u_operandA_mux (
    .operandA_sel(operandA_sel),
    .pc(pc),
    .rs1(rs1),
    .operandA(operandA)
);

alusrc_mux u_alusrc_mux (
    .ALUSrc(ALUSrc),
    .reg_data(rs2),
    .immediate(immediate),
    .operandB(operandB)
);

alu u_alu (
    .operandA(operandA),
    .operandB(operandB),
    .ALUControl(ALUControl),
    .result(result),
    .zero_flag(zero_flag)
);

endmodule