module ram(clk,dmCtrl, address, dataRd, dmWr, dataWr);

  input logic clk;
  input logic [2:0] dmCtrl;
  input logic [31:0] address;
  input logic dmWr;
  input logic [31:0] dataWr;
  output logic [31:0] dataRd;

  reg [31:0] dataAux;
  logic [7:0] mem[7:0];
  
  initial begin
    $readmemh("data.hex", mem);
  end
  
  always @(*)
    if(dmWr == 0) begin  //Lectura
      case(dmCtrl)
        3'b000: dataRd = {24'h0, mem[address]};
        3'b001: dataRd = {16'h0, mem[address+1], mem[address]};
        3'b010: dataRd = {mem[address+3],mem[address+2],mem[address+1], mem[address]};
        3'b100: dataRd = $unsigned({24'h0, mem[address]});
        3'b101: dataRd = $unsigned({16'h0, mem[address+1], mem[address]});
        default:dataRd <= 32'h0;
      endcase
    end
  
  always @(posedge clk)
    if (dmWr == 1) begin
      case(dmCtrl)  //Escritura
        3'b000: begin
          mem[address] = dataWr[7:0];
          mem[address+1] = 8'b0;
          mem[address+2] = 8'b0;
          mem[address+3] = 8'b0;
        end
        3'b001: begin
          mem[address] = dataWr[7:0];
          mem[address+1] = dataWr[15:8];
          mem[address+2] = 8'b0;
          mem[address+3] = 8'b0;
        end
        3'b010: begin
          mem[address] = dataWr[7:0];
          mem[address+1] = dataWr[15:8];
          mem[address+2] = dataWr[23:16];
          mem[address+3] = dataWr[31:24];
        end
        3'b100: begin
          dataAux = $unsigned(dataWr);
          mem[address] = dataAux[7:0];
          mem[address+1] = 8'b0;
          mem[address+2] = 8'b0;
          mem[address+3] = 8'b0;
        end
        3'b101: begin
          dataAux = $unsigned(dataWr);
          mem[address] = dataAux[7:0];
          mem[address+1] = dataAux[15:8];
          mem[address+2] = 8'b0;
          mem[address+3] = 8'b0;
        end
      endcase
    end
endmodule

//----------

module data_memory #(
    parameter ADDR_WIDTH = 10 // Address width, adjust as necessary
) (
    input logic clk,                      // Clock
    input logic rst,                      // Reset
    input logic wr_en,                    // Write enable
    input logic [ADDR_WIDTH-1:0] address, // Address
    input logic [31:0] wr_data,           // Write Data
    output logic [31:0] rd_data           // Read Data
);

    // Declare the memory as a two-dimensional packed array
    logic [31:0] memory [(1 << ADDR_WIDTH) - 1:0];

    integer i; // Index variable for the loop
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Initialize all memory locations to zero during reset
            for (i = 0; i < (1 << ADDR_WIDTH); i = i + 1) begin
                memory[i] <= 32'b0;
            end
        end else if (wr_en) begin
            // Write operation
            memory[address] <= wr_data;
        end
    end
    
    // Read operation (Non-blocking)
    assign rd_data = memory[address];

endmodule