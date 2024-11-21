//-------------------
module RegisterFile (
    input logic clk,            
    input logic rst,            
    input logic we,             
    input logic [4:0] wrAddr,   
    input logic [4:0] rdAddr1,  
    input logic [4:0] rdAddr2,  
    input logic [31:0] wrData,  
    output logic [31:0] rdData1,
    output logic [31:0] rdData2 
);

// Declare 32 registers in which to store the data, each one will have a size of 32 bits.
logic [31:0] regFile [31:0];

// Write Operation
// An "always_ff" cycle is used since operations are expected to be updated only with the clock or reset signal.
always_ff @(posedge clk or posedge rst) begin
    if (rst) // If the reset signal is activated all registers go to 0
        regFile <= '{default:0};
    else if (we && wrAddr != 5'b0) // If write enable is active and address is not 0 then write data to the register file
        regFile[wrAddr] <= wrData;
end

// Read Operation
// If the read address is 0, then it saves a 0. Otherwise it saves whatever is in the register file at the given index.
assign rdData1 = (rdAddr1 == 5'b0) ? 32'b0 : regFile[rdAddr1]; 
assign rdData2 = (rdAddr2 == 5'b0) ? 32'b0 : regFile[rdAddr2]; 

endmodule

//REVISADO