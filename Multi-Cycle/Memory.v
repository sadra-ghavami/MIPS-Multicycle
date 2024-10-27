`timescale 1ns/1ns

module Memory (adr, d_in, mrd, mwr, clk, d_out);
  input [31:0] adr;
  input [31:0] d_in;
  input mrd, mwr, clk;
  output [31:0] d_out;
  
  reg [7:0] mem[0:65535];
  
  initial
  begin
     $readmemb("Inst_mem.mem",mem,32'h00000000,32'h0000003B);    
     $readmemb("Data_mem.mem",mem,32'h000003E8,32'h00000437);
  end
  
  
  // The following initial block is for TEST PURPOSE ONLY 
  initial
  begin
    #10   $display("The content of mem[0] = %b", {mem[3], mem[2], mem[1], mem[0]});
    #10   $display("The content of mem[0] = %b", {mem[15], mem[14], mem[13], mem[12]});
    #14500 $display("The content of mem[1000] = %d", {mem[1003], mem[1002], mem[1001], mem[1000]});
    #50   $display("The content of mem[1076] = %d", {mem[1079], mem[1078], mem[1077], mem[1076]});
    #0    $display("The content of mem[2000] = %d", {mem[2003], mem[2002], mem[2001], mem[2000]});
    #0    $display("The content of mem[2004] = %d", {mem[2007], mem[2006], mem[2005], mem[2004]});
  end
  
  always @(posedge clk)
    if (mwr==1'b1)
      {mem[adr+3], mem[adr+2], mem[adr+1], mem[adr]} = d_in;
  
  assign d_out = (mrd==1'b1) ? {mem[adr+3], mem[adr+2], mem[adr+1], mem[adr]} : 32'd0;
  
endmodule   