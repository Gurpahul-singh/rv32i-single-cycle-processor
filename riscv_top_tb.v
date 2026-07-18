`timescale 1ns/1ps

module riscv_top_tb;

    reg clk;
    reg reset;

    wire [31:0] pc;

    // DUT
    riscv_top dut (
        .clk(clk),
        .reset(reset),
        .pc(pc)
    );

    // Clock generation (10 ns period)
    initial begin 
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset generation
    initial begin
        reset = 1;
        #20;
        reset = 0;
    end
    initial begin
    $dumpfile("top.vcd");
    $dumpvars(0, riscv_top_tb);

    #500;
    $finish;
end

initial begin
#400;
$display("\n===== FINAL MEMORY CONTENT =====");
$display("MEM[8]  = %0d", dut.memory_unit.memory[2]);
$display("MEM[12] = %0d", dut.memory_unit.memory[3]);

$finish;
end
    

    // Monitoring
initial begin
$display("Time\tReset\tPC");
$monitor(
"t=%0t Reset=%b PC=%h Instr=%h x2=%d x3=%d x4=%d x5=%d x6=%d",
$time,
dut.reset,
dut.pc,
dut.instruction,
dut.decode_unit.u_register_file.registers[2],
dut.decode_unit.u_register_file.registers[3],
dut.decode_unit.u_register_file.registers[4],
dut.decode_unit.u_register_file.registers[5],
dut.decode_unit.u_register_file.registers[6]
);
end

endmodule