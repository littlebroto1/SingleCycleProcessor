module PCLogic (
  input logic [3:0] Rd,
  input logic       Branch,
  input logic       RegW,
  output            PCS
);

assign PCS = ((Rd == 4'b1111) & RegW) | Branch;


`ifdef  COCOTB_SIM 
initial
 begin
    $dumpfile("wave_sv.vcd");
    $dumpvars(
      0,
      Rd,
      Branch,
      RegW,
      PCS
    );
    #5;
 end
 `endif

endmodule
