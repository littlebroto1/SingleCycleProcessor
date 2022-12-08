module ARM(
  input   logic         clk, reset,
  output  logic [31:0]  PC,
  input   logic [31:0]  Instr,
  output  logic         MemWrite,
  output  logic [31:0]  MemAddr, WriteData,
  input   logic [31:0]  ReadData
);

  logic [3:0] ALUFlags;
  logic RegWrite, ALUSrc, MemtoReg, PCSrc, AddrSrc;
  logic [1:0] RegSrc, ImmSrc, ALUControl;

  ControlUnit c(
              clk, reset,
              Instr[31:28], // Cond
              ALUFlags,
              Instr[27:26], // Op
              Instr[25:20], // Funct
              Instr[15:12], // Rd
              PCSrc,
              RegWrite,
              MemWrite,
              MemtoReg,
              ALUSrc,
              ImmSrc,
              RegSrc,
              ALUControl,
              AddrSrc
  );

  DataPath dp(
              clk, reset,
              RegSrc,
              RegWrite,
              ImmSrc,
              ALUSrc,
              ALUControl,
              MemtoReg,
              PCSrc,
              ALUFlags,
              PC,
              Instr,
              MemAddr,
              WriteData,
              ReadData,
              AddrSrc
  );
endmodule

module DataPath (
  input   logic         clk, reset,
  input   logic [1:0]   RegSrc,
  input   logic         RegWrite,
  input   logic [1:0]   ImmSrc,
  input   logic         ALUSrc,
  input   logic [1:0]   ALUControl,
  input   logic         MemtoReg,
  input   logic         PCSrc,
  output  logic [3:0]   ALUFlags,
  output  logic [31:0]  PC,
  input   logic [31:0]  Instr,
  output  logic [31:0]  MemAddr, WriteData,
  input   logic [31:0]  ReadData,
  input   logic         AddrSrc
);

  logic [31:0] PCNext, PCPlus4, PCPlus8;
  logic [31:0] ExtImm, SrcA, SrcB, Result;
  logic [3:0]  RA1, RA2;
  logic [31:0] Shifted, ALUResult;

  // next PC logic
  mux2 #(32)      pcmux(PCPlus4, Result, PCSrc, PCNext);
  EnabledFF #(32) pcreg(clk, reset, 1'b1, PCNext, PC);
  assign PCPlus4 = PC + 32'b100;
  assign PCPlus8 = PCPlus4 + 32'b100;

  // register file logic
  mux2 #(4)     ra1mux(Instr[19:16], 4'b1111, RegSrc[0], RA1);
  mux2 #(4)     ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2);

  registerfile  rf(clk, RegWrite, RA1, RA2,
                  Instr[15:12],
                  Result,
                  PCPlus8, SrcA, WriteData);

  shift sh(WriteData, Instr[11:7], Instr[6:5], Shifted); // Perform the shift;

  mux2 #(32)    resmux(MemAddr, ReadData, MemtoReg, Result);
  extender      ext(Instr[23:0], ImmSrc, ExtImm);

  // ALU logic
  mux2 #(32)  srcbmux(Shifted, ExtImm, ALUSrc, SrcB);
  ALU         alu(SrcA, SrcB, ALUControl, ALUResult, ALUFlags);

  mux2 #(32)  MemAddrMux(ALUResult,SrcB,AddrSrc,MemAddr);

  

   `ifdef  COCOTB_SIM 
  initial
  begin
      $dumpfile("wave_sv.vcd");
      $dumpvars(
        0,
        clk, reset,
        SrcA,SrcB,
        RegSrc,
        RegWrite,
        ImmSrc,
        ALUSrc,
        ALUControl,
        MemtoReg,
        PCSrc,
        ALUFlags,
        PC,
        Instr,
        MemAddr, WriteData,
        ReadData,
        Result,
        PCNext, PCPlus4, PCPlus8,
        ExtImm,
        RA1, RA2,
        Shifted, ALUResult
      );
      #5;
  end
  `endif 
  
endmodule
