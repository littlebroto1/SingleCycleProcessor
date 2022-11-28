module EnabledFF #(parameter size=32) (
  input   logic            clk,
  input   logic            reset,
  input   logic            en,
  input   logic [size-1:0] d,
  output  logic [size-1:0] q
);

  // asynchronous reset
  always_ff @(posedge clk, posedge reset)
    if (reset) q <= 1'b0;
    else if (en) q <= d;

`ifdef  COCOTB_SIM 
initial
 begin
    $dumpfile("wave_sv.vcd");
    $dumpvars(
      0,
      clk,
      reset,
      en,
      d,
      q
    );
    #5;
 end
 `endif

endmodule