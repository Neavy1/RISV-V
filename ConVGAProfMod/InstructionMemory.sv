module InstMem #(parameter DEPTH = 256, string FILENAME = "instructions.bin") (
    input logic [31:0] addr, // Address to read from
    output logic [31:0] instruction // Instruction read from memory
);

    logic [31:0] mem [0:DEPTH-1]; // Memory array
    // 2 bits right shift
    assign instruction = mem[addr >> 2]; // byte-address to word-address

    initial begin
        $readmemb("veri_output.txt", mem);
		  for(int i=0; i<$size(im); i=i+4) begin
			$display("%d -->    %b", i);
		 end
    end
endmodule

//REVISADO