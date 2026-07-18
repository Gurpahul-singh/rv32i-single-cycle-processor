module pc (
    input clk, reset,
    input [31:0] next_address,
    output reg [31:0] pc
);

always@(posedge clk or posedge reset) begin
    if(reset) pc<=32'b0;
    else pc<=next_address;
end
    
endmodule
