module riscv_top (
    input clk,
    input reset,
    output [31:0] pc
);

    // =========================
    // Internal Signals
    // =========================

    wire [31:0] instruction;

    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [31:0] write_back_data;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [31:0] immediate;

    wire [3:0] ALUControl;

    wire ALUSrc;
    wire MemoryRead;
    wire MemoryWrite;
    wire Branch;
    wire Jump;
    wire operandA_sel;
    wire pc_sel;

    wire [1:0] WriteBackSel;

    wire [31:0] alu_result;
    wire zero_flag;

    wire [31:0] read_data;

    wire [31:0] next_pc;

    // =========================
    // Fetch Stage
    // =========================

    fetch_top fetch_unit (
        .branched_address(next_pc),
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instruction(instruction),
        .pc_sel(pc_sel)
    );

    // =========================
    // Decode Stage
    // =========================

    top_decode decode_unit (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .write_data(write_back_data),

        .data1(rs1_data),
        .data2(rs2_data),
        .immediate(immediate),

        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .MemoryRead(MemoryRead),
        .MemoryWrite(MemoryWrite),
        .Branch(Branch),
        .Jump(Jump),
        .operandA_sel(operandA_sel),
        .WriteBackSel(WriteBackSel)
    );

    // =========================
    // Execute Stage
    // =========================

    execute_top execute_unit (
        .pc(pc),
        .rs1(rs1_data),
        .rs2(rs2_data),
        .immediate(immediate),

        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .operandA_sel(operandA_sel),

        .result(alu_result),
        .zero_flag(zero_flag)
    );

    // =========================
    // Memory Stage
    // =========================

    data_memory memory_unit (
        .clk(clk),
        .MemoryRead(MemoryRead),
        .MemoryWrite(MemoryWrite),
        .funct3(funct3),
        .address(alu_result),
        .write_data(rs2_data),
        .read_data(read_data)
    );

    // =========================
    // Writeback Stage
    // =========================

    wire [31:0] pc_plus_4 = pc + 32'd4;
    
    writeback_mux wb_unit (
        .write_back_sel(WriteBackSel),
        .alu_result(alu_result),
        .read_data(read_data),
        .pc_plus_4(pc_plus_4),
        .write_back_data(write_back_data)
    );

    branch_jump_unit u1_branch_jump_unit(
        .pc(pc),
        .immediate(immediate),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .opcode(opcode),
        .funct3(funct3),
        .zero_flag(zero_flag),
        .Branch(Branch),
        .Jump(Jump),
        .pc_sel(pc_sel),
        .next_pc(next_pc)
    );
endmodule