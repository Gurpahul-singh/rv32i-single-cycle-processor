module instruction_memory(
    input [31:0] address,
    output reg [31:0] instruction
);

always @(*) begin
    case(address)

        // x2 = 45
        32'h00000000: instruction = 32'h02D00113; // addi x2,x0,45

        // x3 = 80
        32'h00000004: instruction = 32'h05000193; // addi x3,x0,80

        // x4 = x2 + x3
        32'h00000008: instruction = 32'h00310233; // add x4,x2,x3

        // MEM[8] = x4
        32'h0000000C: instruction = 32'h00402423; // sw x4,8(x0)

        // x5 = 100
        32'h00000010: instruction = 32'h06400293; // addi x5,x0,100

        // if (100 < sum) goto GREATER
        32'h00000014: instruction = 32'h0042C863; // blt x5,x4,GREATER

        // LESS:
        // x6 = 100 - sum
        32'h00000018: instruction = 32'h40428333; // sub x6,x5,x4

        // MEM[12] = x6
        32'h0000001C: instruction = 32'h00602623; // sw x6,12(x0)

        // Jump to END
        32'h00000020: instruction = 32'h00C0006F; // jal x0,END

        // GREATER:
        // x6 = sum - 100
        32'h00000024: instruction = 32'h40520333; // sub x6,x4,x5

        // MEM[12] = x6
        32'h00000028: instruction = 32'h00602623; // sw x6,12(x0)

        // END
        32'h0000002C: instruction = 32'h00000013; // nop

        default: instruction = 32'h00000013; // nop

    endcase
end

endmodule