module datapath ( clk, rst, inst_adr, inst,
                  data_adr, data_out, data_in, 
                  reg_dst, mem_to_reg, alu_src, pc_src, alu_ctrl, reg_write,
                  zero,jalctrl,jrctrl,jctrl
                 );
  input  clk, rst;
  output [31:0] inst_adr;
  input  [31:0] inst;
  output [31:0] data_adr;
  output [31:0] data_out;
  input  [31:0] data_in;
  input  reg_dst, mem_to_reg, alu_src, pc_src, reg_write,jalctrl,jrctrl,jctrl;
  input  [2:0] alu_ctrl;
  output zero;

  wire [31:0] pc_out;
  wire [31:0] adder1_out;
  wire [31:0] read_data1, read_data2;
  wire [31:0] sgn_ext_out;
  wire [31:0] mux2_out;
  wire [31:0] alu_out;
  wire [31:0] adder2_out;
  wire [31:0] shl2_out;
  wire [31:0] mux3_out;
  wire [31:0] mux4_out;
  wire [31:0] mux6_out;
  wire [31:0] mux7_out;
  wire [31:0] mux8_out;

  wire [4:0]  mux1_out;
  wire [4:0]  mux5_out;

  wire [27:0] shl2_28bit_out;

  reg_32b PC(mux8_out, rst, 1'b1, clk, pc_out);

  adder_32b ADDER_1 (pc_out , 32'd4, 1'b0, , adder1_out);

  mux2to1_5b MUX_1(inst[20:16], inst[15:11], reg_dst, mux1_out);

  mux2to1_5b MUX_5(mux1_out,5'b11111,jalctrl,mux5_out);


  reg_file  RF(mux6_out, inst[25:21], inst[20:16], mux5_out, reg_write, rst, clk, read_data1, read_data2);

  sign_ext SGN_EXT(inst[15:0], sgn_ext_out);

  mux2to1_32b MUX_2(read_data2, sgn_ext_out, alu_src, mux2_out);

  alu ALU(read_data1, mux2_out, alu_ctrl, alu_out, zero);

  shl2 SHL2(sgn_ext_out, shl2_out);

  shl2_26bit SH2(inst[25:0],shl2_28bit_out);

  adder_32b ADDER_2(adder1_out, shl2_out, 1'b0, , adder2_out);

  mux2to1_32b MUX_3(adder1_out, adder2_out, pc_src, mux3_out);

  mux2to1_32b MUX_4(alu_out, data_in, mem_to_reg, mux4_out);

  mux2to1_32b MUX_6(mux4_out, adder1_out , jalctrl, mux6_out);

  mux2to1_32b MUX_7(mux3_out, read_data1 , jrctrl, mux7_out);

  mux2to1_32b MUX_8(mux7_out, {pc_out[31:28],shl2_28bit_out} , jctrl, mux8_out);



  assign inst_adr = pc_out;
  assign data_adr = alu_out;
  assign data_out = read_data2;
  
endmodule
