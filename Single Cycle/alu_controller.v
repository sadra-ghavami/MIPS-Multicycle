module alu_controller (alu_op, func, operation);
  input [1:0] alu_op;
  input [5:0] func;
  output [2:0] operation;
  reg [2:0] operation;
  
  always @(alu_op, func)
  begin
    operation = 3'b000;
    if (alu_op == 2'b00)        // lw or sw
      operation = 3'b010;
    else if (alu_op == 2'b01)   // beq
      operation = 3'b110;
    else if(alu_op == 2'b11)
      operation = 3'b111;       // slti
    else
      begin
        case (func)
          6'b100000: operation = 3'b010;  // add
          6'b100011: operation = 3'b110;  // sub
          6'b100100: operation = 3'b000;  // and
          6'b100101: operation = 3'b001;  // or
          6'b101010: operation = 3'b111;  // slt
          default:   operation = 3'b000;
        endcase
      end
        
  end
  
endmodule
