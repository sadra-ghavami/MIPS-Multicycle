module controller ( opcode, func, zero, reg_dst, mem_to_reg, reg_write, 
                    alu_src, mem_read, mem_write, pc_src, operation,jalctrl,jrctrl,jctrl
                  );
                    
    input [5:0] opcode;
    input [5:0] func;
    input zero;
    output  reg_dst, mem_to_reg, reg_write, alu_src, 
            mem_read, mem_write, pc_src,jalctrl,jrctrl,jctrl;
    reg     reg_dst, mem_to_reg, reg_write, 
            alu_src, mem_read, mem_write,jalctrl,jrctrl,jctrl; 
    output [2:0] operation;
            
    reg [1:0] alu_op;     
    reg branch;   
    
    alu_controller ALU_CTRL(alu_op, func, operation);
    
    always @(opcode)
    begin
      {reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, alu_op,jalctrl,jrctrl,jctrl} = 11'd0;
      case (opcode)
        // RType instructions
        6'b000000 : {reg_dst, reg_write, alu_op} = 4'b1110;   
        // Load Word (lw) instruction           
        6'b100011 : {alu_src, mem_to_reg, reg_write, mem_read} = 4'b1111; 
        // Store Word (sw) instruction
        6'b101011 : {alu_src, mem_write} = 2'b11;                                 
        // Branch on equal (beq) instruction
        6'b000100 : {branch, alu_op} = 3'b101; 
        // Add immediate (addi) instruction
        6'b001001: {reg_write, alu_src} = 2'b11;
        // jump (j) instruction
        6'b000010: jctrl = 1'b1;
        // jump and link (jal) instruction
        6'b000011: {reg_write,jalctrl,jctrl} = 3'b111;
        // set on less than immediate (slti) instruction
        6'b001010: {reg_write,alu_src,alu_op}= 4'b1111;
        // jr instruction
        6'b000110: jrctrl = 1'b1;

      endcase
    end
    
    assign pc_src = branch & zero;
  
endmodule
