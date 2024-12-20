module ScreenRAM (
   input logic clk,                   // Reloj (entrada)
	input logic [31:0] inst,				// Instrucción
	input logic [6:0] charNumber,			// Caracter (Columna)
	input logic [6:0] fila,					// Fila
	input logic [31:0] pc_addr,				//Pc Actual 	
	output logic [7:0] charCode			// CharCode resultante
);

	//SECCIONES VGA
	logic [7:0] out_fetch;
	
	VGA_FETCH fetch(
		.col(charNumber),
		.pc(pc_addr),
		.inst(inst),
		.char(out_fetch)
	);
	
  
	localparam ESPACIO = 8'h24; // Espacio
	localparam ZERO = 8'h00; // A
	localparam UNO = 8'h01; // B
	localparam DOS = 8'h02; // C
	localparam TRES = 8'h03; // D
	localparam CUATRO = 8'h04; // E
	localparam CINCO = 8'h05; // F
	localparam SEIS = 8'h06; // G
	localparam SIETE = 8'h07; // H
	localparam OCHO = 8'h08; // I
	localparam NUEVE = 8'h09; // J
	localparam A = 8'h0A; // K
	localparam B = 8'h0B; // L
	localparam C = 8'h0C; // M
	localparam D = 8'h0D; // N
	localparam E = 8'h0E; // O
	localparam F = 8'h0F; // P
	localparam G = 8'h10; // Q
	localparam H = 8'h11; // R
	localparam I = 8'h12; // S
	localparam J = 8'h13; // T
	localparam K = 8'h14; // U
	localparam L = 8'h15; // V
	localparam M = 8'h16; // W
	localparam N = 8'h17; // X
	localparam O = 8'h18; // Y
	localparam P = 8'h19; // Z
	localparam Q = 8'h1A; // 0
	localparam R = 8'h1B; // 1
	localparam S = 8'h1C; // 2
	localparam T = 8'h1D; // 3
	localparam U = 8'h1E; // 4
	localparam V = 8'h1F; // 5
	localparam W = 8'h20; // 6
	localparam X = 8'h21; // 7
	localparam Y = 8'h22; // 8
	localparam Z = 8'h23; // 9
	
	

	always_ff @(posedge clk) begin
		if (fila == 3) begin
			charCode = out_fetch;
		end else begin
			charCode = ESPACIO;
		end
	end
	
   
endmodule
