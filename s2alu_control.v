module alu_control (
    input [31:0] instruction,
    input [2:0] ALUOp,
    output reg [3:0] ALUControl
);

    // ALU operation categories
    parameter [2:0] LOAD_STORE_ADRESS_CALC= 3'b000,
                    BRANCH= 3'b001,
                    R_TYPE= 3'b010,
                    I_TYPE_ALU= 3'b011,
                    LUI_OP= 3'b100,
                    AUIPC_OP= 3'b101,
                    RESERVED= 3'b110;

    // ALU Operations
    parameter [3:0] ALU_ADD = 4'b0000,
                    ALU_SUB = 4'b0001,
                    ALU_AND = 4'b0010,
                    ALU_OR = 4'b0011,
                    ALU_XOR = 4'b0100,
                    ALU_SLL = 4'b0101,
                    ALU_SRL = 4'b0110,
                    ALU_SRA= 4'b0111,
                    ALU_SLT = 4'b1000,
                    ALU_SLTU = 4'b1001,
                    ALU_LUI = 4'b1010,
                    ALU_AUIPC= 4'b1011,
                    ALU_RES12 = 4'b1100;


    wire [2:0] funct3;
    assign funct3 = instruction[14:12];

    always @(*) begin
        case (ALUOp)
            LOAD_STORE_ADRESS_CALC: ALUControl = ALU_ADD; // Load/Store (ADD)
            BRANCH : ALUControl = ALU_SUB; // Branch (SUB)
            R_TYPE: begin // R-type
                case (funct3) // funct3
                    3'b000: ALUControl = (instruction[30]) ? ALU_SUB :ALU_ADD ; // ADD/SUB
                    3'b001: ALUControl = ALU_SLL; // SLL
                    3'b010: ALUControl = ALU_SLT; // SLT
                    3'b011: ALUControl = ALU_SLTU; // SLTU
                    3'b100: ALUControl = ALU_XOR; // XOR
                    3'b101: ALUControl = (instruction[30]) ? ALU_SRA : ALU_SRL; // SRA/SRL
                    3'b110: ALUControl = ALU_OR; // OR
                    3'b111: ALUControl = ALU_AND; // AND
                    default: ALUControl = 4'b1111; // Unsupported funct3
                endcase
            end
            I_TYPE_ALU: begin // I-type ALU
                case (funct3) // funct3
                    3'b000: ALUControl = ALU_ADD; // ADDI
                    3'b001: ALUControl = ALU_SLL; // SLLI
                    3'b010: ALUControl = ALU_SLT; // SLTI
                    3'b011: ALUControl = ALU_SLTU; // SLTIU
                    3'b100: ALUControl = ALU_XOR; // XORI
                    3'b101: ALUControl = (instruction[30]) ? ALU_SRA : ALU_SRL; // SRAI/SRLI
                    3'b110: ALUControl = ALU_OR; // ORI
                    3'b111: ALUControl = ALU_AND; // ANDI
                    default: ALUControl = 4'b1111; // Unsupported funct3
                endcase
            end
            LUI_OP: ALUControl = ALU_LUI; // LUI
            AUIPC_OP: ALUControl = ALU_AUIPC; // AUIPC

            default: ALUControl = 4'b1111; // Unsupported ALUOp
        endcase
    end
endmodule
// ALUControl	Operation
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
// 1100	Reserved
// 1101	Reserved
// 1110	Reserved
// 1111	Reserved

// ALUOp (3 bits)
// ALUOp	Meaning
// 3'b000	Load/Store Address Calculation
// 3'b001	Branch Comparison
// 3'b010	R-Type
// 3'b011	I-Type ALU
// 3'b100	LUI
// 3'b101	AUIPC
// 3'b110	Reserved
// 3'b111	Reserved
