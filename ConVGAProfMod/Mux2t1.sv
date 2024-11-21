module Mux2t1(data0, data1, select, dataOut);

  input logic select;
  input logic [31:0] data0;
  input logic [31:0] data1;
  output logic [31:0] dataOut=0;
  
  always @(*) begin
    if (select == 1) dataOut <= data1;
    else dataOut <= data0;
  end
endmodule