module pc_mux (
    input [31:0] pc,
    input [31:0] branched_address,
    input sel,
    output [31:0] next_address
);
    assign next_address = sel ? branched_address : (pc+32'd4);
endmodule
