module immediate_generator (
    input [31:0] instruction,
    input [2:0] ImmSel,
    output reg [31:0] immediate 
);

    always @(*) begin
        case (ImmSel)
            3'b000: immediate = {{20{instruction[31]}}, instruction[31:20]}; // I-type immediate
            3'b001: immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // S-type immediate
            3'b010: immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8],1'b0}; // B-type immediate
            3'b011: immediate = {instruction[31:12], 12'b0}; // U-type immediate
            3'b100: immediate = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21],1'b0}; // J-type immediate
            default: immediate = 32'b0; // Default case for unsupported opcodes
        endcase
    end

endmodule
