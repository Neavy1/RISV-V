//tb_top
module tb_procMonoc;
  logic clk = 1;
  
  procMonoc dut(
    .clk(clk)
  );
  always #1 clk = ~clk;
  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars(2);
    #500;
    $finish();
   end
  
endmodule