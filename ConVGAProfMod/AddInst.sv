module addInst(address, newAddress);
  input logic [31:0] address;
  output logic [31:0] newAddress;
  
  always @(*)
    newAddress <= address + 32'h4;
  
endmodule