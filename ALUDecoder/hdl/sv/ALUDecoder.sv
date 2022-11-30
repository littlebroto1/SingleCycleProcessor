module ALUDecoder (
  input  logic        ALUOp,
  input  logic [3:0]  cmd,  // Funct[4:1]
  input  logic        S,    // Funct[0]
  output logic        NoWrite,
  output logic [1:0]  ALUControl,
  output logic [1:0]  FlagW,
  output logic        AddrSrc
);

always_comb begin
  if (ALUOp) begin
    case (cmd)
      4'b0100: begin // ADD
        ALUControl = 2'b00;
        FlagW = S ? 2'b11 : 2'b00;
      end
      4'b0010: begin // SUB
        ALUControl = 2'b01;
        FlagW = S ? 2'b11 : 2'b00;
      end
      4'b1100: begin // ORR
        ALUControl = 2'b11;
        FlagW = S ? 2'b10 : 2'b00;
      end
      4'b0000: begin // AND
        ALUControl = 2'b10;
        FlagW = S ? 2'b10 : 2'b00;
      end
    endcase
  end
  else begin
    ALUControl = 2'b00;
    FlagW = 2'b00;
  end
end

assign NoWrite = (cmd == 4'b1010) & ALUOp;
assign AddrSrc = (cmd == 4'b1101) & ALUOp;

`ifdef  COCOTB_SIM 
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
      FlagW,
      AddrSrc
    );
    #5;
 end
 `endif

endmodule
