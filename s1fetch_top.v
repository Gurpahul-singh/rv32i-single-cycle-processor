module fetch_top (
    input clk,reset,pc_sel,
    input [31:0] branched_address,
    output [31:0] pc,instruction
);
    instruction_memory u1_instruction_memory (
        .address(pc),
        .instruction(instruction)
    );
    pc_top u1_pc_top (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .pc_sel(pc_sel),
        .branched_address(branched_address)
    );
endmodule