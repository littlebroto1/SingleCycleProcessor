module MainDecoder (
  input  logic [1:0]  Op,
  input  logic        I,  // Funct[5]
  input  logic        S,  // Funct[0]
  output logic        Branch,
  output logic        MemtoReg,
  output logic        MemW,
  output logic        ALUSrc,
  output logic [1:0]  ImmSrc,
  output logic        RegW,
  output logic [1:0]  RegSrc,
  output logic        ALUOp
);

always_comb begin
  case (Op)
    2'b00: begin
          Branch = 1'b0;
          MemtoReg = 1'b0;
          MemW = 1'b0;
          ALUSrc = I;
          ImmSrc = 2'b00;
          RegW = 1'b1;
          RegSrc = 2'b00;
          ALUOp = 1'b1;
    end
    2'b01: begin
          Branch = 1'b0;
          MemtoReg = S; // Don't care in case of S = 0
          MemW = ~S;
          ALUSrc = 1'b1;
          ImmSrc = Op; // 2'b01
          RegW = S;
          RegSrc = {~S, 1'b0}; // Get back to this!!!!!!! Look up bit swindling
          ALUOp = 1'b0;
    end
    2'b10: begin
          Branch = 1'b1;
          MemtoReg = 1'b0;
          MemW = 1'b0;
          ALUSrc = 1'b1;
          ImmSrc = Op; // 2'b10
          RegW = 1'b0;
          RegSrc = 2'b01;
          ALUOp = 1'b0;
    end
    //default:
  endcase
end

/* `ifdef  COCOTB_SIM 
initial
 begin
    $dumpfile("wave_sv.vcd");
    $dumpvars(
      0,
      ALUOP,
      cmd,
      S,
      NoWrite,
      ALUControl,
      FlagW
    );
    #5;
 end
 `endif */

endmodule
