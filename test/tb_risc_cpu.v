`timescale 1ns/1ps
module tb_risc_cpu;
    reg clk, rst;
    risc_cpu uut (.clk(clk), .rst(rst));

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        $recordfile("waves");
        $recordvars("depth=0", tb_risc_cpu);
    end

    initial begin
        $dumpfile("../sim/risc_cpu.vcd");
        $dumpvars(0, tb_risc_cpu);

        $display("Testing Program 3 (LDA, AND, XOR, ADD, SKZ, STO, JMP)...");
        rst = 1;
        #20 rst = 0;
        #5000;
        if (uut.halt && uut.pc_out == 5'h10)
            $display("Program 3 PASSED: Halted at %h", uut.pc_out);
        else
            $display("Program 3 FAILED: PC = %h, Halt = %b", uut.pc_out, uut.halt);
        $finish;
    end
endmodule