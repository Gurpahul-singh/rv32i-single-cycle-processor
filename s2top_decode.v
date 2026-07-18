module top_decode (
    input clk,reset,
    input [31:0] instruction,
    input [31:0] write_data,
    output [31:0] data1,data2,immediate,
    output [3:0] ALUControl,
    output ALUSrc,MemoryRead,MemoryWrite,Branch,Jump,operandA_sel,
    output [1:0] WriteBackSel
);

wire [6:0] opcode,funct7;
wire [4:0] rs1,rs2,rd;
wire [2:0] funct3,ImmSel,ALUOp;
wire write_enable;

instruction_decoder u_instruction_decoder (
    .instruction(instruction),//ip
    .opcode(opcode),//op
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .funct3(funct3),
    .funct7(funct7)
);

register_file u_register_file (
    .clk(clk),
    .reset(reset),
    .rd(rd),
    .rs1(rs1),
    .rs2(rs2),
    .we(write_enable),
    .write_data(write_data),
    .data1(data1),
    .data2(data2)
);



control_unit u_control_unit (
    .instruction(instruction),
    .RegWrite(write_enable),
    .ALUSrc(ALUSrc),
    .MemoryRead(MemoryRead),
    .MemoryWrite(MemoryWrite),
    .Branch(Branch),
    .Jump(Jump),
    .operandA_sel(operandA_sel),
    .ImmSel(ImmSel),
    .ALUOp(ALUOp),
    .WriteBackSel(WriteBackSel)
);

immediate_generator u_immediate_generator (
    .instruction(instruction),
    .ImmSel(ImmSel),
    .immediate(immediate)
);

alu_control u_alu_control (
    .instruction(instruction),
    .ALUOp(ALUOp),
    .ALUControl(ALUControl)
);

endmodule