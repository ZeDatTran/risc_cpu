`timescale 1ns/1ps
module tb_risc_cpu_program1;
    reg clk, rst;
    risc_cpu uut (.clk(clk), .rst(rst));

    // Tạo xung nhịp
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // Ghi lại sóng
    initial begin
        $recordfile("waves_program1");
        $recordvars("depth=0", tb_risc_cpu_program1);
    end

    // Mô phỏng và kiểm tra
    initial begin
        $dumpfile("../sim/risc_cpu_program1.vcd");
        $dumpvars(0, tb_risc_cpu_program1);

        $display("Testing Program 1 (Expected halt at 0x17)...");
        rst = 1;
        #20 rst = 0;
        #10000; // Tăng thời gian chờ
        if (uut.halt && uut.pc_out == 5'h17)
            $display("Program 1 PASSED: Halted at %h", uut.pc_out);
        else
            $display("Program 1 FAILED: PC = %h, Halt = %b, AC = %h", uut.pc_out, uut.halt, uut.ac_out);
        $finish;
    end
endmodule