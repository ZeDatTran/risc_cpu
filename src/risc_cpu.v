`timescale 1ns/1ps
module risc_cpu (
    input clk, rst
);
    wire [4:0] pc_out;
    wire [4:0] addr_mux_out;
    wire [7:0] mem_data;
    wire [7:0] ir_out;
    wire [7:0] ac_out;
    wire [7:0] alu_out;
    wire is_zero;
    wire [2:0] opcode;
    wire [4:0] operand;
    wire sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e;

    reg [7:0] mem_data_reg;
    always @(posedge clk) begin
        if (rst) mem_data_reg <= 8'b0;
        else if (ctrl.state == 5 && ctrl.rd) 
            mem_data_reg <= mem_data;
    end

    reg [2:0] opcode_reg;
    always @(posedge clk) begin
        if (rst) opcode_reg <= 3'b0;
        else opcode_reg <= ir_out[7:5];
    end

    // Kết nối các mô-đun
    program_counter pc (.clk(clk), .rst(rst), .ld_pc(ld_pc), .inc_pc(inc_pc), .load_val(operand), .pc(pc_out));
    address_mux addr_mux (.sel(sel), .pc_addr(pc_out), .op_addr(operand), .addr_out(addr_mux_out));
    memory mem (.clk(clk), .rd(rd), .wr(wr), .addr(addr_mux_out), .data(mem_data));
    register ir (.clk(clk), .rst(rst), .load(ld_ir), .in(mem_data), .out(ir_out));
    
    alu alu_inst (.opcode(opcode), .inA(ac_out), .inB(mem_data_reg), .out(alu_out), .is_zero(is_zero));
    register ac (.clk(clk), .rst(rst), .load(ld_ac), .in(alu_out), .out(ac_out));
    
    controller ctrl (.clk(clk), .rst(rst), .opcode(opcode), .zero(is_zero),
                     .sel(sel), .rd(rd), .ld_ir(ld_ir), .halt(halt), .inc_pc(inc_pc),
                     .ld_ac(ld_ac), .ld_pc(ld_pc), .wr(wr), .data_e(data_e));

    assign opcode = opcode_reg;
    assign operand = ir_out[4:0];
    
    assign mem_data = (data_e && wr && !rd) ? ac_out : 8'bz;

    always @(posedge clk) begin
        $display("CPU: PC = %h, AC = %h, IR = %h, opcode = %b, alu_out = %h, ld_ac = %b, is_zero = %b, mem_data = %h, mem_data_reg = %h",
                 pc_out, ac_out, ir_out, opcode, alu_out, ld_ac, is_zero, mem_data, mem_data_reg);
    end
endmodule