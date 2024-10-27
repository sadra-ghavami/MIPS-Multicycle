`timescale 1ns/1ns

`define   S0      4'b0000
`define   S1      4'b0001
`define   S2      4'b0010
`define   S3      4'b0011
`define   S4      4'b0100
`define   S5      4'b0101
`define   S6      4'b0110
`define   S7      4'b0111
`define   S8      4'b1000
`define   S9      4'b1001
`define   S10     4'b1010
`define   S11     4'b1011
`define   S12     4'b1100
`define   S13     4'b1101
`define   S14     4'b1110
`define   S15     4'b1111

module Multicycle_controller(clk, rst,opcode,
                  reg_dst, mem_to_reg, alu_src_a,alu_src_b, pc_src, alu_op, reg_write,
                  IorD,IR_write,pc_write,pc_write_cond,mem_write,mem_read);

	input clk,rst;
	input[5:0]opcode;
	output reg alu_src_a,reg_write,IorD,IR_write,pc_write,pc_write_cond,mem_write,mem_read;	
	output reg[1:0]reg_dst,mem_to_reg,alu_src_b,pc_src,alu_op;

	reg [4:0] ps, ns;

	 // Sequential part 
 	always @(posedge clk)
		if (rst)
      			ps <= 5'b00000;
    		else
      			ps <= ns;
	
	always @(ps or opcode)begin
		
		case(ps)
			`S0 : ns = `S1;
			`S1 : begin
				if(opcode == 6'b000010)//jump instruction
				   ns = `S2;
				else if(opcode == 6'b000011)//jal instruction
				   ns = `S3;
				else if(opcode == 6'b000110)//jr instruction
				   ns = `S4;
				else if(opcode == 6'b001010)//slti instruction
				   ns = `S5;
				else if(opcode == 6'b001001)//addi instruction
				   ns = `S7;
				else if(opcode == 6'b100011)//lw  instruction
				   ns = `S9;
				else if(opcode === 6'b101011)//sw instruction
				   ns = `S9;
				else if(opcode == 6'b000000)//R-type instruction
				   ns = `S13;
				else if(opcode == 6'b000100)//beq instruction
				   ns = `S15;
				else ns = `S0;
			      end
			`S2 : ns = `S0;
			`S3 : ns = `S0;
			`S4 : ns = `S0;
			`S5 : ns = `S6;
			`S6 : ns = `S0;
			`S7 : ns = `S8;
			`S8 : ns = `S0;
			`S9 : if(opcode == 6'b100011)//lw instruction
				ns = `S10;
			      else
				ns = `S12;
			`S10 : ns = `S11;
			`S11 : ns = `S0;
			`S12 : ns = `S0;
			`S13 : ns = `S14;
			`S14 : ns = `S0;
			`S15 : ns = `S0;
			default: ns = `S0;
		endcase

	end	

	always @(ps) begin
		
		{alu_src_a,reg_write,IorD,IR_write,pc_write,pc_write_cond,mem_write,mem_read}=8'd0;
		{reg_dst,mem_to_reg,alu_src_b,pc_src,alu_op} = 10'd0;
		case(ps)
			`S0 : {mem_read,alu_src_b,pc_write,IR_write} = 5'b10111;
			`S1 : alu_src_b = 2'b11;
			`S2 : {pc_write,pc_src} = 3'b101;
			`S3 : {pc_write,pc_src,reg_dst,mem_to_reg,reg_write} = 8'b10110101;
			`S4 : {alu_src_a,pc_write} = 2'b11;
			`S5 : {alu_src_a,alu_src_b,alu_op} = 5'b11011;
			`S6 : reg_write = 1'b1;
			`S7 : {alu_src_a,alu_src_b} = 3'b110;
			`S8 : reg_write = 1'b1;
			`S9 : {alu_src_a,alu_src_b,alu_op} = 5'b11000;
			`S10: {mem_read,IorD}=2'b11;
			`S11: {reg_write,mem_to_reg}=3'b101;
			`S12: {mem_write,IorD} = 2'b11;
			`S13: {alu_src_a,alu_op} = 3'b110;
			`S14: {reg_dst,reg_write} = 3'b011;
			`S15: {alu_src_a,alu_op,pc_write_cond,pc_src} = 6'b101110;
		endcase
	end

endmodule
