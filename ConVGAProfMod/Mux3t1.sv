module Mux3t1(data0, data1, data2, select, dataOut);

  input logic [2:0] select;
  input logic [31:0] data0;
  input logic [31:0] data1;
  input logic [31:0] data2;
  output logic [31:0] dataOut;
  
  always @(*) begin
    case(select)
      3'b0: dataOut <= data0;
      3'b1: dataOut <= data1;
      3'b10: dataOut <= data2;
    endcase
  end
endmodule