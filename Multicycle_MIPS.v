`timescale 1ns/1ns

module Multicycle_Mips(clk,rst,adr,write_data,read_data,mem_read,mem_write);
	input clk,rst;
	input[31:0]read_data;
	output mem_read,mem_write;
	output[31:0] adr,write_data;

	wire reg_write,alu_src_a,IorD,IR_write,pc_write,pc_write_cond;
	wire[1:0] pc_src,alu_src_b,reg_dst,mem_to_reg,alu_op;
	wire [2:0]alu_func;
	wire [5:0] opcode,func;
	
	Multicycle_Datapath DATAPATH ( clk, rst, adr, read_data,write_data,opcode,func,
                  reg_dst, mem_to_reg, alu_src_a,alu_src_b, pc_src, alu_func, reg_write,
                  IorD,IR_write,pc_write,pc_write_cond
                 );
	Multicycle_controller CONTROLLER(clk, rst,opcode,
                  reg_dst, mem_to_reg, alu_src_a,alu_src_b, pc_src, alu_op, reg_write,
                  IorD,IR_write,pc_write,pc_write_cond,mem_write,mem_read);

	alu_controller ALU_CONTROLLER (alu_op, func, alu_func);

endmodule
