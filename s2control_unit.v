module control_unit (
    input [31:0] instruction,
    output reg RegWrite,ALUSrc,MemoryRead,MemoryWrite,Branch,Jump,operandA_sel,
    output reg [2:0] ImmSel,ALUOp,
    output reg [1:0] WriteBackSel
);

    wire [6:0] opcode;
    assign opcode = instruction[6:0];

    always @(*) begin
        operandA_sel = 0; 
        case (opcode)
            7'b0110011: begin // R-type
                RegWrite = 1; ALUSrc = 0; MemoryRead = 0; MemoryWrite = 0; Branch = 0; Jump = 0;
                ImmSel = 3'b111; ALUOp = 3'b010; WriteBackSel = 2'b00;
            end
            7'b0010011: begin // I-type
                RegWrite = 1; ALUSrc = 1; MemoryRead = 0; MemoryWrite = 0; Branch = 0; Jump = 0;
                ImmSel = 3'b000; ALUOp = 3'b011; WriteBackSel = 2'b00;
            end
            7'b0000011: begin // Load
                RegWrite = 1; ALUSrc = 1; MemoryRead = 1; MemoryWrite = 0; Branch = 0; Jump = 0;
                ImmSel = 3'b000; ALUOp = 3'b000; WriteBackSel = 2'b01;
            end
            7'b0100011: begin // Store
                RegWrite = 0; ALUSrc = 1; MemoryRead = 0; MemoryWrite = 1; Branch = 0; Jump = 0;
                ImmSel = 3'b001; ALUOp = 3'b000; WriteBackSel = 2'b11;
            end
            7'b1100011: begin // Branch
                RegWrite = 0; ALUSrc = 0; MemoryRead = 0; MemoryWrite = 0; Branch = 1; Jump = 0;
                ImmSel = 3'b010; ALUOp = 3'b001; WriteBackSel = 2'b11;
            end
            7'b1101111: begin // JAL
                RegWrite = 1; ALUSrc = 0; MemoryRead = 0; MemoryWrite = 0; Branch = 0; Jump = 1;
                ImmSel = 3'b100; ALUOp = 3'b111; WriteBackSel = 2'b10;
            end
            7'b1100111: begin // JALR
                RegWrite = 1; ALUSrc = 1; MemoryRead = 0; MemoryWrite = 0; Branch = 0; Jump = 1;
                ImmSel = 3'b000; ALUOp = 3'b000; WriteBackSel = 2'b10;
            end
            7'b0110111: begin // LUI
                RegWrite = 1; ALUSrc = 1; MemoryRead = 0; MemoryWrite = 0; Branch = 0; Jump = 0;
                ImmSel = 3'b011; ALUOp = 3'b100; WriteBackSel = 2'b00;
            end
            7'b0010111: begin // AUIPC
                RegWrite = 1; ALUSrc = 1; MemoryRead = 0; MemoryWrite = 0; Branch = 0; Jump = 0;
                ImmSel = 3'b011; ALUOp = 3'b101; WriteBackSel = 2'b00; operandA_sel = 1;
            end
            default: begin // Unsupported instructions
                RegWrite = 0; ALUSrc = 0; MemoryRead = 0; MemoryWrite = 0; Branch = 0; Jump = 0;
                ImmSel = 3'b000; ALUOp = 3'b111; WriteBackSel = 2'b00;
            end
        endcase
    end
endmodule

// WriteBackSel	Source
// 2'b00	ALU Result
// 2'b01	Memory Data
// 2'b10	PC + 4
// 2'b11	nothing



// ImmSel	Immediate Type
// 3'b000	I-Type
// 3'b001	S-Type
// 3'b010	B-Type
// 3'b011	U-Type
// 3'b100	J-Type
// 3'b101	Reserved
// 3'b110	Reserved
// 3'b111	Reserved


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