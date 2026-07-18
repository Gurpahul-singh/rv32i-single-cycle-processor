module data_memory (
    input clk,MemoryRead,MemoryWrite,
    input [31:0] address,write_data,
    output reg [31:0] read_data
);
    
reg [31:0] memory [0:255]; // 256 words of 32-bit memory

always @(posedge clk) begin
    if (MemoryWrite) begin
        memory[address[31:2]] <= write_data; // Write data to memory
    end
end

always @(*) begin
    if (MemoryRead) begin
        read_data = memory[address[31:2]]; // Read data from memory
    end else begin
        read_data = 32'b0; // Default value when not reading
    end
end

endmodule