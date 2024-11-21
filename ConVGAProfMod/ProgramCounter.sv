module progCount(addressIn, addressOut, clk);
  input logic clk;
  input logic [31:0] addressIn;
  output logic [31:0] addressOut = 0;
  
  always @(posedge clk) begin
    addressOut <= addressIn;
  end
endmodule

//
