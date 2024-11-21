module branchUnit(brOp, Ru1, Ru2, nextPcSrc);

  input logic [4:0] brOp;
  input logic [31:0] Ru1;
  input logic [31:0] Ru2;
  output logic nextPcSrc;
  
  always @(*)begin
    
    if (brOp[4] == 1)
      nextPcSrc = 1;
    if (brOp[4:3] == 00)
      nextPcSrc = 0;
    else if (brOp[4:3] == 01) begin
      nextPcSrc = 0;
      case(brOp)
        5'b01000:
          if (Ru1 == Ru2)
            nextPcSrc = 1;
        5'b01001:
          if (Ru1 != Ru2)
            nextPcSrc = 1;
        5'b01100:
          if (Ru1 < Ru2)
            nextPcSrc = 1;
        5'b01101:
          if (Ru1 >= Ru2)
            nextPcSrc = 1;
        5'b01110:
          if (Ru1 < $unsigned(Ru2))
            nextPcSrc = 1;
        5'b01111:
          if (Ru1 >= $unsigned(Ru2))
            nextPcSrc = 1;
      endcase
    end
  end
    
endmodule
