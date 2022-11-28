module shift(
  input   logic [31:0]  in,
  input   logic [4:0]   shmamt5,
  input   logic [1:0]   sh,
  output  logic [31:0]  result
);

always_comb begin
  case(sh)
    2'b00: result = in  <<   shmamt5;
    2'b01: result = in  >>   shmamt5;
    2'b10: result = in  >>>  shmamt5;
  endcase
end
  
endmodule

