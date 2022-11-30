module Decoder (
  input   logic [3:0]   Rd,
  input   logic [1:0]   Op,
  input   logic [5:0]   Funct,
  output  logic         PCS,
  output  logic         RegW,
  output  logic         MemW,
  output  logic         MemtoReg,
  output  logic         ALUSrc,
  output  logic [1:0]   ImmSrc,
  output  logic [1:0]   RegSrc,
  output  logic         NoWrite,
  output  logic [1:0]   ALUControl,
  output  logic [1:0]   FlagW,
  output  logic         DataSrc
);

logic ALUOp;
logic Branch;

PCLogic pclogic(
  Rd,
  Branch,
  RegW, // Might have issues here because of RegW being an output
  PCS
);

MainDecoder main(
  Op,
  Funct[5], // I
  Funct[0], // S
  Branch,
  MemtoReg,
  MemW,
  ALUSrc,
  ImmSrc,
  RegW,
  RegSrc,
  ALUOp
);

ALUDecoder alu_decoder(
  ALUOp,
  Funct[4:1], // cmd
  Funct[0],   // S
  NoWrite,
  ALUControl,
  FlagW,
  DataSrc
);

`ifdef  COCOTB_SIM 
initial
 begin
    $dumpfile("wave_sv.vcd");
    $dumpvars(
      0,
      Rd,
      Op,
      Funct,
      PCS,
      RegW,
      MemW,
      MemtoReg,
      ALUSrc,
      ImmSrc,
      RegSrc,
      NoWrite,
      ALUControl,
      FlagW
    );
    #5;
 end
 `endif

endmodule
