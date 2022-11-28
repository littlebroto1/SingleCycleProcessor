module ConditionLogic (
  input   logic         clk,reset,
  input   logic         PCS,
  input   logic         RegW,
  input   logic         NoWrite,
  input   logic         MemW,
  input   logic [1:0]   FlagW,
  input   logic [3:0]   Cond,
  input   logic [3:0]   ALUFlags,
  output  logic         PCSrc,
  output  logic         RegWrite,
  output  logic         MemWrite
);
logic CondEx;
logic [3:0] Flags;

ConditionCheck check(
  Cond,
  Flags[3],
  Flags[2],
  Flags[1],
  Flags[0],
  CondEx
);

EnabledFF #(2) NZ(
  clk,reset,
  FlagW[1] & CondEx, // Enabled
  ALUFlags[3:2],
  Flags[3:2]
);

EnabledFF #(2) VC(
  clk,reset,
  FlagW[0] & CondEx, // Enabled
  ALUFlags[1:0],
  Flags[1:0]
);

assign PCSrc = CondEx & PCS;
assign RegWrite = RegW & ~NoWrite & CondEx;
assign MemWrite = MemW & CondEx;
  

`ifdef  COCOTB_SIM 
initial
 begin
    $dumpfile("wave_sv.vcd");
    $dumpvars(
      0,
      clk,reset,
      CondEx,
      Flags,
      PCS,RegW,NoWrite,MemW,
      FlagW,
      Cond,ALUFlags,
      PCSrc,RegWrite,MemWrite
    );
    #5;
 end
 `endif

endmodule
