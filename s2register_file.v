module register_file ( 
    input clk , reset,
    input [4:0] rd,rs1,rs2,
    input we,
    input [31:0] write_data,
    output [31:0] data1,data2
);

    reg [31:0] registers [31:0];

    assign data1 = (rs1 == 0) ? 32'b0 : registers[rs1];
    assign data2 = (rs2 == 0) ? 32'b0 : registers[rs2];
    integer i;

    always@(posedge clk or posedge reset) begin
        if(reset) begin
            for(i=0;i<32;i=i+1) begin
                registers[i] <= 32'b0;
            end
        end
        else if(we && rd!=5'b0) begin
            registers[rd]<=write_data;
        end
    end

endmodule