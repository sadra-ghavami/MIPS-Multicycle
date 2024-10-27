module Multicycle_Datapath ( clk, rst, adr, read_data,write_data,opcode,func,
                  reg_dst, mem_to_reg, alu_src_a,alu_src_b, pc_src, alu_func, reg_write,
                  IorD,IR_write,pc_write,pc_write_cond
                 );
	input clk,rst,reg_write,alu_src_a,IorD,IR_write,pc_write,pc_write_cond;
	input [1:0] pc_src,alu_src_b,reg_dst,mem_to_reg;
	input [2:0]alu_func;
	input [31:0]read_data;
	output[31:0]adr,write_data;
	output [5:0] opcode,func;

	wire[31:0]mux1_out,mux3_out,mux4_out,
	  	  mux5_out,mux6_out,IR_out,MDR_out,sign_extend_out,
	  	  shl2_32b_out,read_data1,read_data2,A_out,B_out,
	  	  alu_result,alu_reg_out,pc_out;
	wire[2:0]alu_control_out;
	wire[4:0]mux2_out;
	wire[27:0]shl2_28b_out;
	wire and_out,or_out,zero;

	reg_file FILE(mux3_out,IR_out[25:21],IR_out[20:16], mux2_out, reg_write, rst, clk, read_data1, read_data2);

	mux2to1_32b mux1(pc_out,alu_reg_out,IorD,mux1_out);
	mux4to1_5b  mux2(IR_out[20:16],IR_out[15:11],5'b11111,,reg_dst,mux2_out);
	mux4to1_32b mux3(alu_reg_out,MDR_out,pc_out,,mem_to_reg,mux3_out);
	mux4to1_32b mux4(B_out,32'd4,sign_extend_out,shl2_32b_out,alu_src_b,mux4_out);
	mux2to1_32b mux5(pc_out,A_out,alu_src_a,mux5_out);
	mux4to1_32b mux6(alu_result,{pc_out[31:28],shl2_28b_out},alu_reg_out,,pc_src,mux6_out);

	reg_32b pc(mux6_out,rst,or_out,clk,pc_out);
	reg_32b IR(read_data,rst,IR_write,clk,IR_out);
	reg_32b MDR(read_data,rst,1'b1,clk,MDR_out);
	reg_32b A(read_data1,rst,1'b1,clk,A_out);
	reg_32b B(read_data2,rst,1'b1,clk,B_out);
	reg_32b alu_reg(alu_result,rst,1'b1,clk,alu_reg_out);

	alu ALU1(mux5_out,mux4_out,alu_func,alu_result,zero);

	shl2 SHL2(sign_extend_out,shl2_32b_out);
	shl2_26bit SHL2_28(IR_out[25:0],shl2_28b_out);
	sign_ext SIGN_EXT(IR_out[15:0],sign_extend_out);
	
	and a1(and_out,zero,pc_write_cond);
	or  o1(or_out,and_out,pc_write);

	assign opcode = IR_out[31:26];
	assign func   = IR_out[5:0];
	assign adr  = mux1_out;
	assign write_data = B_out;

endmodule
