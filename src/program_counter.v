`timescale 1ns/1ps
module program_counter (
    input clk, rst, ld_pc, inc_pc,
    input [4:0] load_val,
    output reg [4:0] pc
);
    always @(posedge clk or posedge rst) begin
        if (rst) pc <= 5'b0;
        else if (ld_pc) pc <= load_val;
        else if (inc_pc) pc <= pc + 1;
    end
endmodule