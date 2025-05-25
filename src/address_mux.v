`timescale 1ns/1ps
module address_mux #(
    parameter WIDTH = 5
) (
    input sel,
    input [WIDTH-1:0] pc_addr, op_addr,
    output [WIDTH-1:0] addr_out
);
    assign addr_out = sel ? pc_addr : op_addr;
endmodule