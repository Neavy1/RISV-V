module procMonoc(
    input logic clk,
	 input logic clk_vga,
    input logic rst,
    output logic [7:0] vga_red,
    output logic [7:0] vga_green,
    output logic [7:0] vga_blue,
    output logic vga_hsync,
    output logic vga_vsync,
	 output logic clk_out
);

    // Declaración de señales
    wire [31:0] addrPC;
    wire [31:0] addrOutPC;
    wire [31:0] addrOutAdd;
    wire [31:0] inst;
    wire RuWr;
    wire [3:0] ALUOp;
    wire [2:0] IMMSrc;
    wire ALUASrc;
    wire ALUBSrc;
    wire DMWr;
    wire [2:0] DMCtrl;
    wire [4:0] BrOp;
    wire [1:0] RUDataWrSrc;
    wire [31:0] DataRd;
    wire [31:0] RU1;
    wire [31:0] RU2;
    wire [31:0] immExt;
    wire [31:0] dataA;
    wire [31:0] dataB;
    wire [31:0] dataOutAlu;
    wire [31:0] dataWr;
    wire NextPcSrc;
	 
	 // Señales para el módulo VGA
    wire [7:0] CharLine;
    wire [7:0] ScreenChar;
    wire [3:0] CharLineNumber;
    wire [8:0] CharCode;
    wire [6:0] AddressRd;
	 wire [6:0] fila;

    // Instanciación de componentes
    progCount PC(.addressIn(addrPC), .addressOut(addrOutPC), .clk(clk));
    InstMem IM(.addr(addrOutPC), .instruction(inst));
    controlUnit CU(.opCode(inst[6:0]), .funct3(inst[14:12]), .funct7(inst[31:25]), .RUWr(RuWr), .ALUOp(ALUOp), .IMMSrc(IMMSrc), .ALUASrc(ALUASrc), .ALUBSrc(ALUBSrc), .DMWr(DMWr), .DMCtrl(DMCtrl), .BrOp(BrOp), .RUDataWrSrc(RUDataWrSrc));
    addInst adder(.address(addrOutPC), .newAddress(addrOutAdd));
    Mux2t1 MUXNextPC(.data0(addrOutAdd), .data1(dataOutAlu), .select(NextPcSrc), .dataOut(addrPC));
    RegUnit RU(.rdAddr1(inst[19:15]), .rdAddr2(inst[24:20]), .wrAddr(inst[11:7]), .wrData(dataWr), .we(RuWr), .clk(clk), .rdData1(RU1), .rdData2(RU2));
    ALU ALU(.ASrc(dataA), .BSrc(dataB), .aluOp(ALUOp), .alures(dataOutAlu));
    ImmGen IG(.immSrc(IMMSrc), .data(inst[31:7]), .immExt(immExt));
    Mux2t1 MUXA(.data0(RU1), .data1(addrOutPC), .select(ALUASrc), .dataOut(dataA));
    Mux2t1 MUXB(.data0(RU2), .data1(immExt), .select(ALUBSrc), .dataOut(dataB));
    branchUnit BU(.brOp(BrOp), .Ru1(RU1), .Ru2(RU2), .nextPcSrc(NextPcSrc));
    ram DM(.clk(clk), .dmCtrl(DMCtrl), .address(dataOutAlu), .dataRd(DataRd), .dmWr(DMWr), .dataWr(RU2));
    Mux3t1 MUXWB(.data0(dataOutAlu), .data1(DataRd), .data2(addrOutAdd), .select(RUDataWrSrc), .dataOut(dataWr));
		
     // Instancia del nuevo módulo VGA
    VGAUnit vga(
        .clk_108(clk_vga),
        .Hsync(vga_hsync),
        .Vsync(vga_vsync),
        .Red(vga_red),
        .Green(vga_green),
        .Blue(vga_blue),
        .CharLine(CharLine),
        .CharLineNumber(CharLineNumber),
        .CharCode(CharCode),
        .ScreenChar(ScreenChar),
        .AddressRd(AddressRd),
		  .clk_vga(clk_out),
		  .fila(fila)
    );
	 // Instancia de la ROM de caracteres
    CharROM rom(
        .char_code(CharCode),
        .line_number(CharLineNumber),
        .char_line(CharLine)
    );
	 // Instancia de la RAM de pantalla
    ScreenRAM ram(
        .clk(clk_vga),
        .charNumber(AddressRd),
        .charCode(ScreenChar),
		  .pc_addr(addrOutPC),
		  .inst(inst),
		  .fila(fila)
    );

    always @(posedge clk) begin
        $display("PC: %0h(%0d) Inst: %8h", addrOutPC, addrOutPC, inst);

        case(inst[6:0])
            7'b0110011: begin 
                $display("Tipo R");
                $display("RD: x%0d", inst[11:7]);
                $display("RS1: x%0d = %0d", inst[19:15], RU1);
                $display("RS2: x%0d = %0d", inst[24:20], RU2);
                $display("ALUOp: %4b", ALUOp);
                $display("ALUA: %0d --- ALUB: %0d", $signed(dataA), $signed(dataB));
                $display("ALURes: %0d", dataOutAlu);
            end
            7'b0010011: begin 
                $display("Tipo I");
                $display("RD: x%0d", inst[11:7]);
                $display("RS1: x%0d = %0d", inst[19:15], RU1);
                $display("Imm: %0d", $signed(immExt));
                $display("ALUOp: %4b", ALUOp);
                $display("ALUA: %0d --- ALUB: %0d", $signed(dataA), $signed(dataB));
                $display("ALURes: %0d", dataOutAlu);
            end
            7'b0000011: begin 
                $display("Tipo I-Carga");
                $display("RD: x%0d", inst[11:7]);
                $display("RS1: x%0d = %0d", inst[19:15], RU1);
                $display("Imm: %0d", $signed(immExt));
                $display("Address: %0h(%0d) DataRd: %0h", dataOutAlu, dataOutAlu, DataRd);
            end
            7'b0100011: begin 
                $display("Tipo S");
                $display("RS1: x%0d = %0h(%0d)", inst[19:15], RU1, RU1);
                $display("RS2: x%0d = %0h(%0d)", inst[24:20], RU2, RU2);
                $display("Imm: %0d", $signed(immExt));
                $display("Address: %0h(%0d) DataWr: %0h", dataOutAlu, dataOutAlu, RU2);
            end
            7'b1100011: begin 
                $display("Tipo B");
                $display("BrOp: %5b", BrOp);
                $display("RS1: x%0d = %0d", inst[19:15], RU1);
                $display("RS2: x%0d = %0d", inst[24:20], RU2);

                case(BrOp[2:0])
                    3'b000: $display("x%0d == x%0d", inst[19:15],inst[24:20]);
                    3'b001: $display("x%0d != x%0d", inst[19:15],inst[24:20]);
                    3'b100: $display("x%0d < x%0d", inst[19:15],inst[24:20]);
                    3'b101: $display("x%0d >= x%0d", inst[19:15],inst[24:20]);
                    3'b110: $display("x%0d < (U)x%0d", inst[19:15], inst[24:20]);
                    3'b111: $display("x%0d >= (U)x%0d", inst[19:15], inst[24:20]);
                endcase

                if(NextPcSrc == 0) begin
                    $display("No salto");
                end else begin
                    $display("Salto: %0h(%0d)", dataOutAlu, dataOutAlu);
                end
            end
            7'b1101111: begin
                $display("Tipo J");
                $display("Imm: %0d", $signed(immExt));
                $display("RD: x%0d = %0h(%0d)", inst[11:7], addrOutAdd, addrOutAdd);
            end
            7'b1100111: begin
                $display("Tipo I-Salto");
                $display("RS1: x%0d = %0d", inst[19:15], RU1);
                $display("Imm: %0d", $signed(immExt));
                $display("RD: x%0d = %0h(HEX)", inst[11:7], addrOutAdd);
                $display("Salto: %0h", dataOutAlu);
            end
            7'b0110111: begin 
                $display("Tipo U");
                $display("RD: x%0d", inst[11:7]);
                $display("Imm: %0d", $signed(immExt));
            end 
        endcase
        $display("---------------------");
    end

endmodule
  
