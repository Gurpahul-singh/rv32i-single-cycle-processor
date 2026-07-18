module branch_jump_unit (
    input [31:0] pc,
    input [31:0] immediate,
    input [31:0] rs1_data,
    input [31:0] rs2_data,
    input [6:0] opcode,
    input [2:0] funct3,
    input zero_flag,
    input Branch,
    input Jump,
    output reg pc_sel,
    output reg [31:0] next_pc
);
    // for r type  instructions, the next pc is pc + 4 which will be covered ind default case
    // similarly for i type instructions, the next pc is pc + 4 which will be covered in default case
    // except for jalr instruction, the next pc is rs1_data + immediate

wire signed_less = $signed(rs1_data) < $signed(rs2_data);
wire unsigned_less = rs1_data < rs2_data;
wire take_branch = (funct3 == 3'b000) ? zero_flag : // beq
                    (funct3 == 3'b001) ? ~zero_flag : // bne
                    (funct3 == 3'b100) ? signed_less : // blt
                    (funct3 == 3'b101) ? ~signed_less : // bge
                    (funct3 == 3'b110) ? unsigned_less : // bltu
                    (funct3 == 3'b111) ? ~unsigned_less : // bgeu
                    1'b0; // default case for unsupported funct3

always @(*) begin

pc_sel = 1'b0;
next_pc = pc + 32'd4;

if (Jump) begin
    pc_sel = 1'b1;
    case(opcode) 
        7'b1101111: next_pc = pc + immediate; // jal
        7'b1100111: next_pc = (rs1_data + immediate) & 32'hFFFFFFFE; // jalr
        default: next_pc = pc + 32'd4; // Default case for unsupported jump
    endcase
end
else if (Branch) begin
    if (take_branch) begin
        pc_sel  = 1'b1;
        next_pc = pc + immediate;
    end
end
end
endmodule

// ImmSel	Immediate Type
// 3'b000	I-Type
// 3'b001	S-Type
// 3'b010	B-Type
// 3'b011	U-Type
// 3'b100	J-Type
// 3'b101	Reserved
// 3'b110	Reserved
// 3'b111	Reserved


// Instruction	funct3	Condition
// beq	        000	    rs1 == rs2
// bne	        001	    rs1 != rs2
// blt	        100	    signed(rs1) < signed(rs2)
// bge	        101	    signed(rs1) >= signed(rs2)
// bltu	        110	    unsigned(rs1) < unsigned(rs2)
// bgeu	        111	    unsigned(rs1) >= unsigned(rs2)