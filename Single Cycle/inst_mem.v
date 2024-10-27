`timescale 1ns/1ns

module inst_mem (adr, d_out);
  input [31:0] adr;
  output [31:0] d_out;
  
  reg [7:0] mem[0:65535];
  
  initial
  begin
//		lw R2,1000(R0)  : 100011 00000 00010 0000001111101000 
//		add R3,R0,R0    : 000000 00000 00000 00011 00000 100000
//		add R1,R0,R0    : 000000 00000 00000 00001 00000 100000
//Loop:	 	slti R4,R1,80   : 001010 00001 00100 0000000001010000 
//		beq R4,R0,7     : 000100 00000 00100 0000000000000111
//		lw R6,1000(R1)  : 100011 00001 00110 0000001111101000
//		slt R5,R6,R2    : 000000 00110 00010 00101 00000 101010
//		beq R5,R0,2     : 000100 00101 00000 0000000000000010
//		add R2,R6,R0    : 000000 00110 00000 00010 00000 100000
//		add R3,R1,R0    : 000000 00001 00000 00011 00000 100000
//EndIf: 	addi R1,R1,4    : 001001 00001 00001 0000000000000100 
//		j Loop		: 000010 00000000000000000000000011
//Endloop : 	sw R2,2000(R0)  : 101011 00000 00010 0000011111010000
//		sw R3,2004(R0)  : 101011 00000 00011 0000011111010100

               	 
    $readmemb("Inst_mem.mem",mem);
  end
  
  assign d_out = {mem[adr[15:0]+3], mem[adr[15:0]+2], mem[adr[15:0]+1], mem[adr[15:0]]};

 // The following initial block is for TEST PURPOSE ONLY 
  initial
  begin
    #500 $display("The content of inst[0] = %b", {mem[3], mem[2], mem[1], mem[0]});
    #5   $display("The content of inst[1] = %b", {mem[7], mem[6], mem[5], mem[4]});
  end
  
endmodule
