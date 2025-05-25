`timescale 1ns/1ps
module alu (
    input [2:0] opcode,
    input [7:0] inA, inB,
    output reg [7:0] out,
    output reg is_zero
);
    always @(*) begin
        case (opcode)
            3'b000: out = 8'b0;            // HLT
            3'b001: out = inA;             // SKZ 
            3'b010: out = inA + inB;       // ADD
            3'b011: out = inA & inB;       // AND
            3'b100: out = inA ^ inB;       // XOR
            3'b101: out = inB;             // LDA
            3'b110: out = inA;             // STO
            3'b111: out = 8'b0;            // JMP
            default: out = 8'b0;          
        endcase
        is_zero = (out == 8'b0) ? 1'b1 : 1'b0; 
    end

    // Debug
    always @(*) begin
        $display("ALU: opcode = %b, inA = %h, inB = %h, out = %h, is_zero = %b", opcode, inA, inB, out, is_zero);
    end
endmodule