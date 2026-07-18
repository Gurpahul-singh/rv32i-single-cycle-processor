module alu (
    input [31:0] operandA,operandB,
    input [3:0] ALUControl,
    output reg [31:0] result,
    output reg zero_flag
);


parameter [3:0] ADD = 4'b0000,
                SUB = 4'b0001,
                AND = 4'b0010,
                OR = 4'b0011,
                XOR = 4'b0100,
                SLL = 4'b0101,
                SRL = 4'b0110,
                SRA= 4'b0111,
                SLT = 4'b1000,
                SLTU = 4'b1001,
                LUI = 4'b1010,
                AUIPC= 4'b1011;

always @(*) begin
    case(ALUControl)
        ADD: result = operandA + operandB; // ADD
        SUB: result = operandA - operandB; // SUB
        AND: result = operandA & operandB; // AND
        OR: result = operandA | operandB; // OR
        XOR: result = operandA ^ operandB; // XOR
        SLL: result = operandA << operandB[4:0]; // SLL
        SRL: result = operandA >> operandB[4:0]; // SRL
        SRA: result = $signed(operandA) >>> operandB[4:0]; // SRA
        SLT: result = ($signed(operandA) < $signed(operandB)) ? 32'd1 : 32'd0; // SLT
        SLTU: result = (operandA < operandB) ? 32'd1 : 32'd0; // SLTU
        LUI: result = operandB; // LUI
        AUIPC: result = operandA + operandB; // AUIPC
        default: result = 32'd0; // Default case for unsupported ALU operations
    endcase
end

always @(*) begin
    zero_flag = (result == 32'd0) ? 1'b1 : 1'b0; // Set zero_flag if result is zero
end

endmodule

// 0000	ADD
// 0001	SUB
// 0010	AND
// 0011	OR
// 0100	XOR
// 0101	SLL
// 0110	SRL
// 0111	SRA
// 1000	SLT
// 1001	SLTU
// 1010	LUI
// 1011	AUIPC