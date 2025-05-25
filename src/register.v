`timescale 1ns/1ps
module register (
    input clk, rst, load,
    input [7:0] in,
    output reg [7:0] out
);
    always @(posedge clk or posedge rst) begin
        if (rst) out <= 8'b0;
        else if (load) out <= in;
    end
endmodule