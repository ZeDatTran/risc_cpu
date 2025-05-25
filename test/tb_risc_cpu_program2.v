`timescale 1ns/1ps
module tb_risc_cpu_program2;
    reg clk, rst;
    risc_cpu uut (.clk(clk), .rst(rst));
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end
    initial begin
        $recordfile("waves_program2");
        $recordvars("depth=0", tb_risc_cpu_program2);
    end
    initial begin
        $dumpfile("../sim/risc_cpu_program2.vcd");
        $dumpvars(0, tb_risc_cpu_program2);

        $display("Testing Program 2 (Expected halt at 0x0C)...");
        rst = 1;
        #20 rst = 0;
        #20000; // Tăng thời gian chờ vì chương trình Fibonacci lặp nhiều lần
        if (uut.halt && uut.pc_out == 5'h0C)
            $display("Program 2 PASSED: Halted at %h", uut.pc_out);
        else
            $display("Program 2 FAILED: PC = %h, Halt = %b, AC = %h", uut.pc_out, uut.halt, uut.ac_out);
        $finish;
    end
endmodule