`timescale 1ns/1ps
module controller (
    input clk, rst,
    input [2:0] opcode,
    input zero,
    output reg sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e
);
    parameter INST_ADDR  = 3'd0,
              INST_FETCH = 3'd1,
              INST_LOAD  = 3'd2,
              IDLE       = 3'd3,
              OP_ADDR    = 3'd4,
              OP_FETCH   = 3'd5,
              ALU_OP     = 3'd6,
              STORE      = 3'd7;
    
    reg [2:0] state, next_state;
    reg skip_next;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= INST_ADDR;
            skip_next <= 1'b0;
        end
        else if (!halt) begin
            state <= next_state;
            if (state == ALU_OP && opcode == 3'b001 && zero)
                skip_next <= 1'b1;
            else if (state == STORE)
                skip_next <= 1'b0;
        end
    end

    always @(*) begin
        case (state)
            INST_ADDR:  next_state = INST_FETCH;
            INST_FETCH: next_state = INST_LOAD;
            INST_LOAD:  next_state = IDLE;
            IDLE:       next_state = OP_ADDR;
            OP_ADDR:    next_state = OP_FETCH;
            OP_FETCH:   next_state = ALU_OP;
            ALU_OP:     next_state = STORE;
            STORE:      next_state = INST_ADDR;
            default:    next_state = INST_ADDR;
        endcase
    end

    always @(*) begin
        sel = 1'b0;
        rd = 1'b0;
        ld_ir = 1'b0;
        halt = 1'b0;
        inc_pc = 1'b0;
        ld_ac = 1'b0;
        ld_pc = 1'b0;
        wr = 1'b0;
        data_e = 1'b0;
        
        case (state)
            INST_ADDR: sel = 1'b1;
            INST_FETCH: begin
                sel = 1'b1;
                rd = 1'b1;
            end
            INST_LOAD: begin
                sel = 1'b1;
                rd = 1'b1;
                ld_ir = 1'b1;
            end
            IDLE: sel = 1'b1;
            OP_ADDR: begin
                if (opcode == 3'b010 || opcode == 3'b011 || opcode == 3'b100 || opcode == 3'b101 || opcode == 3'b110)
                    sel = 1'b0;
            end
            OP_FETCH: begin
                if (opcode == 3'b010 || opcode == 3'b011 || opcode == 3'b100 || opcode == 3'b101 || opcode == 3'b110)
                    rd = 1'b1;
            end
            ALU_OP: begin
                if (opcode == 3'b010 || opcode == 3'b011 || opcode == 3'b100 || opcode == 3'b101)
                    ld_ac = 1'b1;
                if (opcode == 3'b001 && zero)
                    inc_pc = 1'b1;
            end
            STORE: begin
                case (opcode)
                    3'b110: begin
                        wr = 1'b1;
                        data_e = 1'b1;
			inc_pc = 1'b1;
                    end
                    3'b000: halt = 1'b1;
                    3'b111: ld_pc = 1'b1;
                    default: begin
                        inc_pc = 1'b1;
                        if (skip_next && opcode == 3'b001)
                            inc_pc = 1'b1;
                    end
                endcase
            end
        endcase
    end

    always @(posedge clk) begin
        $display("Controller: state = %d, opcode = %b, zero = %b, sel = %b, rd = %b, ld_ir = %b, halt = %b, inc_pc = %b, ld_ac = %b, ld_pc = %b, wr = %b, data_e = %b, skip_next = %b",
                 state, opcode, zero, sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e, skip_next);
        if (state == ALU_OP && opcode == 3'b001)
            $display("SKZ: zero = %b, skip_next = %b, inc_pc = %b", zero, skip_next, inc_pc);
        if (state == STORE && skip_next)
            $display("SKZ STORE: skip_next = %b, inc_pc = %b", skip_next, inc_pc);
    end
endmodule