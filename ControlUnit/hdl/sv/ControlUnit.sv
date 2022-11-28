module ControlUnit (
  input   logic         clk, reset,
  input   logic [3:0]   Cond,   // Instr[31:28]
  input   logic [3:0]   ALUFlags,
  input   logic [1:0]   Op,     // Instr[27:26]
  input   logic [5:0]   Funct,  // Instr[25:20]
  input   logic [3:0]   Rd,     // Instr[15:12]
  output  logic         PCSrc,
  output  logic         RegWrite,
  output  logic         MemWrite,
  output  logic         MemtoReg,
  output  logic         ALUSrc,
  output  logic [1:0]   ImmSrc,
  output  logic [1:0]   RegSrc,
  output  logic [1:0]   ALUControl
);

logic [1:0] FlagW;
logic PCS;
logic RegW;
logic MemW;
logic NoWrite;

ConditionLogic condition(
  clk, reset,
  PCS,
  RegW,
  NoWrite,
  MemW,
  FlagW,
  Cond,
  ALUFlags,
  PCSrc,
  RegWrite,
  MemWrite
);

Decoder decode(
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


/* `ifdef  COCOTB_SIM 
initial
 begin
    $dumpfile("wave_sv.vcd");
    $dumpvars(
      0,
      ALUOp,
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
