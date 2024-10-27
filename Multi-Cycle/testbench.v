`timescale 1ns/1ns

module testbench();
	reg rst,clk;
	wire [31:0]adr,write_data,read_data ;
	wire mem_read, mem_write;
	
	Multicycle_Mips CPU(clk,rst,adr,write_data,read_data,mem_read,mem_write);
	Memory M(adr, write_data , mem_read, mem_write, clk, read_data);	

	always
  	begin
    		#10 clk = ~clk;
  	
	end

	initial
	begin
	rst=1;
	clk=0;
	#20 rst=0;
	#15000 $stop;

	end
endmodule
