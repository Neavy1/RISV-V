module progCount(addressIn, addressOut, clk);
  input logic clk;
  input logic [31:0] addressIn;
  output logic [31:0] addressOut = 0;
  
  always @(posedge clk) begin
    addressOut <= addressIn;
  end
endmodule

//
module program_counter (
    input logic clk,            // Clock
    input logic rst,            // Reset
    input logic enable,         // Enable signal to control whether PC should be updated
    input logic [31:0] jump_addr, // New address for jumps or branches
    output logic [31:0] pc_addr   // Current Program Counter Address
);

    // Register to hold the program counter value
    logic [31:0] pc_reg;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) 
            pc_reg <= 32'b0; // Reset to the start address (usually 0)
        else if (enable) 
            pc_reg <= jump_addr; // Update to the new address if enabled
        else 
            pc_reg <= pc_reg + 4; // Sequentially increment by 4 (word addressable)
    end
    
    // Output the current PC value
    assign pc_addr = pc_reg;

endmodule