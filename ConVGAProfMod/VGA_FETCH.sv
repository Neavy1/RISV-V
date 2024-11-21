module VGA_FETCH(
	input logic [6:0] col,
	input logic [31:0] pc,
	input logic [31:0] inst,
	output logic [7:0] char
);
	
	logic [7:0] FETCH [0:11];
	initial begin
		FETCH = '{F, E, T, C, H, ESPACIO, P, C, I, N, S, T};
	end
	// Memoria RAM para almacenar los caracteres de la pantalla
	logic [7:0] ram [0:255]; // 256 posiciones de 8 bits (4 letras por instrucción)
	
	logic [5:0] instCode = 0;
	logic [7:0] pc_chars [0:7];
	
	logic [1:0] charNumber;
	
	assign charNumber = (col - 47) & 2'b11;
	always_comb begin
		pc_chars[0] = pc [31:28];
		pc_chars[1] = pc [27:24];
		pc_chars[2] = pc [23:20];
		pc_chars[3] = pc [19:16];
		pc_chars[4] = pc [15:12];
		pc_chars[5] = pc [11:8];
		pc_chars[6] = pc [7:4];
		pc_chars[7] = pc [3:0];
	end
	
	always_comb begin
		if (col >= 0 && col < 8) begin //Palabras FETCH PC
			char = FETCH[col];
		end else if (col > 8 && col <= 40) begin //Valor PC
			char = pc_chars[col-9];
		end else if (col > 41 && col <= 45) begin // Palabra INST
			char = FETCH[col - 34];
		end else if(col > 46 && col <= 50) begin // Valor INST
			char = ram[{instCode, charNumber}];
		end else begin
			char = ESPACIO;
		end
	end
	
	always @(*) begin
		
		//opCode = inst[6:0]
		//func3 = inst[14:12]
		//func7 = inst[31:25]
		
		if (inst[6:0] == 7'b0110111) begin //Lui
			instCode = 6'h14;
		end
		if (inst[6:0] == 7'b0110011) begin //Tipo R
			if (inst[14:12] == 3'h0) begin // Add, Sub
				if (inst[31:25] == 3'h0) begin //Add
					instCode = 6'h01;
				end//And
				if (inst[31:25] == 6'h20) begin //Sub
					instCode = 6'h02;
				end//And
			end//Add, sub
			if (inst[14:12] == 3'h7) begin //and
				if (inst[31:25] == 7'h0) begin //and
					instCode = 6'h03;
				end //And
			end//And
			if (inst[14:12] == 3'h6) begin //Or
				if (inst[31:25] == 7'h0) begin //Or
					instCode = 6'h04;
				end //Or
			end //Or
		
			if (inst[14:12] == 3'h4) begin //Xor
				if (inst[31:25] == 7'h0) begin //Xor
					instCode = 6'h05;
				end //Xor
			end //Xor
			
			if (inst[14:12] == 3'h1) begin //Sll
				if (inst[31:25] == 7'h00) begin //Sll
					instCode = 6'h06;
				end //Sll
			end //Sll
			
			if (inst[14:12] == 3'h5) begin //Srl, Sra
				if (inst[31:25] == 7'h0) begin //Srl
					instCode = 6'h07;
				end //Srl
				if (inst[31:25] == 7'h20) begin //Sra
					instCode = 6'h08;
				end
			end //Srl, Sra
			if (inst[14:12] == 3'h2) begin // Slt
				 if (inst[31:25] == 7'h00) begin // Slt
					  instCode = 6'h09;
				 end // Slt
			end // Slt
			if (inst[14:12] == 3'h3) begin // Sltu
				 if (inst[31:25] == 7'h00) begin // Sltu
					  instCode = 6'h0A;
				 end // Sltu
			end // Sltu
		end //Tipo R
		if (inst[6:0] == 7'b0010011) begin // Tipo I
			if (inst[14:12] == 3'h0) begin // Addi
				instCode = 6'h0B;
			end // Addi
			if (inst[14:12] == 3'h7) begin // Andi
				instCode = 6'h0C;
			end // Andi
			if (inst[14:12] == 3'h6) begin // Ori
				instCode = 6'h0D;
			end // Ori
			if (inst[14:12] == 3'h4) begin // Xori
				instCode = 6'h0E;
			end // Xori
			if (inst[14:12] == 3'h1) begin // Slli
				instCode = 6'h0F;
			end // Xlli
			if (inst[14:12] == 3'h4) begin // Srli, Srai
				if (inst[31:25] == 7'h00) begin // Srli
					instCode = 6'h10;
				end // Srli
				if (inst[31:25] == 7'h20) begin // Srai
					instCode = 6'h11;
				end // Srai
			end // Srli, Srai
			if (inst[14:12] == 3'h2) begin // Slti
				instCode = 6'h12;
			end
			if (inst[14:12] == 3'h3) begin // Sltiu
				instCode = 6'h13;
			end
		end //Tipo I
		if (inst[6:0] == 7'b0000011) begin // Load
			if (inst[14:12] == 3'h0) begin // Lb
				instCode = 6'h1E;
			end
			if (inst[14:12] == 3'h1) begin // Lh
				instCode = 6'h1F;
			end
			if (inst[14:12] == 3'h2) begin // Lw
				instCode = 6'h20;
			end
			if (inst[14:12] == 3'h4) begin // Lbu
				instCode = 6'h21;
			end
			if (inst[14:12] == 3'h5) begin // Lhu
				instCode = 6'h22;
			end
		end //Tipo Load xd
		if (inst[6:0] == 7'b1100111) begin // Jalr
			instCode = 6'h17;
		end
		if (inst[6:0] == 7'b0100011) begin // Store
			if (inst[14:12] == 3'h0) begin // Sb
				instCode = 6'h23;
			end
			if (inst[14:12] == 3'h1) begin // Sh
				instCode = 6'h24;
			end
			if (inst[14:12] == 3'h2) begin // Sw
				instCode = 6'h25;
			end
		end
		if (inst[6:0] == 7'b1100011) begin // Branch
			if (inst[14:12] == 3'h0) begin // Beq
				 instCode = 6'h18;
			end
			if (inst[14:12] == 3'h1) begin // Bne
				 instCode = 6'h19;
			end
			if (inst[14:12] == 3'h4) begin // Blt
				 instCode = 6'h1A;
			end
			if (inst[14:12] == 3'h5) begin // Bge
				 instCode = 6'h1B;
			end
			if (inst[14:12] == 3'h6) begin // Bltu
				 instCode = 6'h1C;
			end
			if (inst[14:12] == 3'h7) begin // Bgeu
				 instCode = 6'h1D;
			end
		end
		if (inst[6:0] == 7'b1101111) begin // Jal
			instCode = 6'h16;
		end
		if (inst[6:0] == 7'b0010111) begin // Auipc
			instCode = 6'h15;
		end
	end
	
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
	
	
	// Inicialización de la RAM con códigos ASCII
	initial begin
		integer i;
		for (i = 0; i < 256; i = i + 1) begin
			ram[i] = ESPACIO;
		end
		// 00xx  // _ _ _ _
		ram[8'd00] = ESPACIO;
		ram[8'd01] = ESPACIO;
		ram[8'd02] = ESPACIO;
		ram[8'd03] = ESPACIO;
		
		// 01xx  // A D D _
		ram[8'd04] = A;
		ram[8'd05] = D;
		ram[8'd06] = D;
		ram[8'd07] = ESPACIO;
		
		// 02xx  // S U B _
		ram[8'd08] = S;
		ram[8'd09] = U;
		ram[8'd10] = B;
		ram[8'd11] = ESPACIO;
		
		// 03xx  // A N D _
		ram[8'd12] = A;
		ram[8'd13] = N;
		ram[8'd14] = D;
		ram[8'd15] = ESPACIO;
		
		// 04xx  // O R _ _
		ram[8'd16] = O;
		ram[8'd17] = R;
		ram[8'd18] = ESPACIO;
		ram[8'd19] = ESPACIO;
		
		// 05xx  // X O R _
		ram[8'd20] = X;
		ram[8'd21] = O;
		ram[8'd22] = R;
		ram[8'd23] = ESPACIO;
		
		// 06xx  // S L L _
		ram[8'd24] = S;
		ram[8'd25] = L;
		ram[8'd26] = L;
		ram[8'd27] = ESPACIO;
		
		// 07xx  // S R L _
		ram[8'd28] = S;
		ram[8'd29] = R;
		ram[8'd30] = L;
		ram[8'd31] = ESPACIO;
		
		// 08xx  // S R A _
		ram[8'd32] = S;
		ram[8'd33] = R;
		ram[8'd34] = A;
		ram[8'd35] = ESPACIO;
		
		// 09xx  // S L T _
		ram[8'd36] = S;
		ram[8'd37] = L;
		ram[8'd38] = T;
		ram[8'd39] = ESPACIO;
		
		// 0Axx  // S L T U
		ram[8'd40] = S;
		ram[8'd41] = L;
		ram[8'd42] = T;
		ram[8'd43] = U;
		
		// 0Bxx  // A D D I
		ram[8'd44] = A;
		ram[8'd45] = D;
		ram[8'd46] = D;
		ram[8'd47] = I;
		
		// 0Cxx  // A N D I
		ram[8'd48] = A;
		ram[8'd49] = N;
		ram[8'd50] = D;
		ram[8'd51] = I;
		
		// 0Dxx  // O R I _
		ram[8'd52] = O;
		ram[8'd53] = R;
		ram[8'd54] = I;
		ram[8'd55] = ESPACIO;
		
		// 0Exx  // X O R I
		ram[8'd56] = X;
		ram[8'd57] = O;
		ram[8'd58] = R;
		ram[8'd59] = I;
		
		// 0Fxx  // S L L I
		ram[8'd60] = S;
		ram[8'd61] = L;
		ram[8'd62] = L;
		ram[8'd63] = I;
		
		// 10xx  // S R L I
		ram[8'd64] = S;
		ram[8'd65] = R;
		ram[8'd66] = L;
		ram[8'd67] = I;
		
		// 11xx  // S R A I
		ram[8'd68] = S;
		ram[8'd69] = R;
		ram[8'd70] = A;
		ram[8'd71] = I;
		
		// 12xx  // S L T I
		ram[8'd72] = S;
		ram[8'd73] = L;
		ram[8'd74] = T;
		ram[8'd75] = I;
		
		// 13xx  // S L I U
		ram[8'd76] = S;
		ram[8'd77] = L;
		ram[8'd78] = I;
		ram[8'd79] = U;
		
		// 14xx  // L U I _
		ram[8'd80] = L;
		ram[8'd81] = U;
		ram[8'd82] = I;
		ram[8'd83] = ESPACIO;
		
		// 15xx  // A I P C
		ram[8'd84] = A;
		ram[8'd85] = I;
		ram[8'd86] = P;
		ram[8'd87] = C;
		
		// 16xx  // J A L _
		ram[8'd88] = J;
		ram[8'd89] = A;
		ram[8'd90] = L;
		ram[8'd91] = ESPACIO;
		
		// 17xx  // J A L R
		ram[8'd92] = J;
		ram[8'd93] = A;
		ram[8'd94] = L;
		ram[8'd95] = R;
		
		// 18xx  // B E Q _
		ram[8'd96] = B;
		ram[8'd97] = E;
		ram[8'd98] = Q;
		ram[8'd99] = ESPACIO;
		
		// 19xx  // B N E _
		ram[8'd100] = B;
		ram[8'd101] = N;
		ram[8'd102] = E;
		ram[8'd103] = ESPACIO;
		
		// 1Axx  // B L T _
		ram[8'd104] = B;
		ram[8'd105] = L;
		ram[8'd106] = T;
		ram[8'd107] = ESPACIO;
		
		// 1Bxx  // B G E _
		ram[8'd108] = B;
		ram[8'd109] = G;
		ram[8'd110] = E;
		ram[8'd111] = ESPACIO;
		
		// 1Cxx  // B L T U
		ram[8'd112] = B;
		ram[8'd113] = L;
		ram[8'd114] = T;
		ram[8'd115] = U;
		
		// 1Dxx  // B G E U
		ram[8'd116] = B;
		ram[8'd117] = G;
		ram[8'd118] = E;
		ram[8'd119] = U;
		
		// 1Exx  // L B _ _
		ram[8'd120] = L;
		ram[8'd121] = B;
		ram[8'd122] = ESPACIO;
		ram[8'd123] = ESPACIO;
		
		// 1Fxx  // L H _ _
		ram[8'd124] = L;
		ram[8'd125] = H;
		ram[8'd126] = ESPACIO;
		ram[8'd127] = ESPACIO;
		
		// 20xx  // L W _ _
		ram[8'd128] = L;
		ram[8'd129] = W;
		ram[8'd130] = ESPACIO;
		ram[8'd131] = ESPACIO;
		
		// 21xx  // L B U
		ram[8'd132] = L;
		ram[8'd133] = B;
		ram[8'd134] = U;
		ram[8'd135] = ESPACIO;
		
		// 22xx  // L H U
		ram[8'd136] = L;
		ram[8'd137] = H;
		ram[8'd138] = U;
		ram[8'd139] = ESPACIO;
		
		// 23xx  // S B _ _
		ram[8'd140] = S;
		ram[8'd141] = B;
		ram[8'd142] = ESPACIO;
		ram[8'd143] = ESPACIO;
		
		// 24xx  // S H _ _
		ram[8'd144] = S;
		ram[8'd145] = H;
		ram[8'd146] = ESPACIO;
		ram[8'd147] = ESPACIO;
		
		// 25xx  // S W _ _
		ram[8'd148] = S;
		ram[8'd149] = W;
		ram[8'd150] = ESPACIO;
	end
   
//00xx  // _ _ _ _
//01xx  // A D D _
//02xx  // S U B _
//03xx  // A N D _
//04xx  // O R _ _
//05xx  // X O R _
//06xx  // S L L _
//07xx  // S R L _
//08xx  // S R A _
//09xx  // S L T _
//0Axx  // S L T U
//0Bxx  // A D D I
//0Cxx  // A N D I
//0Dxx  // O R I _
//0Exx  // X O R I
//0Fxx  // S L L I
//10xx  // S R L I
//11xx  // S R A I
//12xx  // S L T I
//13xx  // S L I U
//14xx  // L U I _
//15xx  // A I P C
//16xx  // J A L _
//17xx  // J A L R
//18xx  // B E Q _
//19xx  // B N E _
//1Axx  // B L T _
//1Bxx  // B G E _
//1Cxx  // B L T U
//1Dxx  // B G E U
//1Exx  // L B _ _
//1Fxx  // L H _ _
//20xx  // L W _ _
//21xx  // L B U
//22xx  // L H U
//23xx  // S B _ _
//24xx  // S H _ _
//25xx  // S W _ _

endmodule
