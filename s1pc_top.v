module pc_top (
    input clk,reset,pc_sel,
    input [31:0] branched_address,
    output [31:0] pc
);

    wire [31:0] next_address;

    pc u1_pc (
        .clk(clk),
        .reset(reset),
        .next_address(next_address),
        .pc(pc)
    );

    pc_mux u1_pc_mux (
        .pc(pc),
        .branched_address(branched_address),
        .sel(pc_sel),
        .next_address(next_address)
    );

endmodule