module writeback_mux (
    input [1:0] write_back_sel,
    input [31:0] alu_result,
    input [31:0] read_data,
    input [31:0] pc_plus_4,
    output [31:0] write_back_data
);
    assign write_back_data = (write_back_sel == 2'b00) ? alu_result :
                             (write_back_sel == 2'b01) ? read_data :
                             (write_back_sel == 2'b10) ? pc_plus_4 : 32'b0;
                             
endmodule

// 00 -> ALU result
// 01 -> Memory read data
// 10 -> PC + 4
