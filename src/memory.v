`timescale 1ns/1ps
module memory (
    input clk, rd, wr,
    input [4:0] addr,
    inout [7:0] data
);
    reg [7:0] mem[31:0];
    reg [7:0] data_out;

    initial $readmemb("../test/program2.mem", mem); // Tên tệp tạm thời, sẽ được ghi đè

    always @(posedge clk) begin
        if (wr && !rd) mem[addr] <= data;
    end

    always @(*) begin
        if (rd && !wr) data_out = mem[addr];
        else data_out = 8'bz;
    end

    assign data = (rd && !wr) ? data_out : 8'bz;

    // Debug
    always @(posedge clk) begin
        if (rd && !wr)
            $display("Memory read: addr = %h, data = %h", addr, data_out);
        if (wr && !rd)
            $display("Memory write: addr = %h, data = %h", addr, data);
    end
endmodule