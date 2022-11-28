module ConditionCheck (
  input   logic [3:0]   cond,
  input   logic         N,
  input   logic         Z,
  input   logic         C,
  input   logic         V,
  output  logic         condEx
);

always_comb
  case(cond)
    4'b0000: condEx = Z;               // EQ
    4'b0001: condEx = ~Z;              // NE
    4'b0010: condEx = C;               // CS/HS
    4'b0011: condEx = !C;              // CC/LO
    4'b0100: condEx = N;               // MI
    4'b0101: condEx = !N;              // PL
    4'b0110: condEx = V;               // VS
    4'b0111: condEx = ~V;              // VC
    4'b1000: condEx = ~Z & C;          // HI
    4'b1001: condEx = Z | ~C;          // LS
    4'b1010: condEx = N ~^ V;          // GE
    4'b1011: condEx = N ^ V;           // LT
    4'b1100: condEx = ~Z & (N ~^ V);   // GT
    4'b1101: condEx = Z | (N ^ V);     // LE
    4'b1110: condEx = 1'b1;            // AL
  endcase



  

`ifdef  COCOTB_SIM 
initial
 begin
    $dumpfile("wave_sv.vcd");
    $dumpvars(
      0,
      cond,
      N,
      Z,
      C,
      V,
      condEx
    );
    #5;
 end
 `endif

endmodule
