`timescale 1ns/1ns

module testbench();
	reg rst,clk;
	wire [31:0]inst_adr, inst, data_adr, data_in, data_out;
	wire mem_read, mem_write;
	mips_single_cycle M1(rst, clk, inst_adr, inst, data_adr, data_in, data_out, mem_read, mem_write);
	inst_mem instruction(inst_adr, inst);
	data_mem data(data_adr, data_out, mem_read, mem_write, clk, data_in);
	
	always
  	begin
    		#10 clk = ~clk;
  	
	end

	initial
	begin
	rst=1;
	clk=0;
	#20 rst=0;
	#5000 $stop;

	end
endmodule
