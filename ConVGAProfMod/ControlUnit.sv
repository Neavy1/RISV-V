module controlUnit(opCode, funct3, funct7, RUWr, ALUOp, IMMSrc,	ALUASrc, ALUBSrc, DMWr, DMCtrl, BrOp,RUDataWrSrc);

  input logic [6:0] opCode;
  input logic [2:0] funct3;
  input logic [6:0] funct7;
  output logic RUWr;
  output logic [3:0] ALUOp;
  output logic [2:0] IMMSrc;
  output logic ALUASrc;
  output logic ALUBSrc;
  output logic DMWr;
  output logic [2:0] DMCtrl;
  output logic [4:0] BrOp;
  output logic [1:0] RUDataWrSrc;
  
  always @(*)
    case(opCode)
        7'b110011: begin  //tipo R
          RUWr= 1;
          ALUOp= {funct7[5],funct3};
  		  ALUASrc= 0;
  		  ALUBSrc= 0;
  		  DMWr= 0;
          BrOp= {2'b00,funct3};
  		  RUDataWrSrc = 2'b00;
        end
        7'b10011: begin  // Tipo I
          RUWr= 1;
          ALUOp= {funct7[5],funct3};
  		  IMMSrc= 3'b000;
  		  ALUASrc= 0;
  		  ALUBSrc= 1;
  		  DMWr= 0;
          BrOp= {2'b00, funct3};
          RUDataWrSrc= 2'b00;
        end
        7'b11: begin  // Tipo I-Lec
          RUWr= 1;
          ALUOp= 4'b0;
  		  IMMSrc= 3'b000;
  		  ALUASrc= 0;
  		  ALUBSrc= 1;
  		  DMWr= 0;
          DMCtrl= funct3;
          BrOp= {2'b00, funct3};
          RUDataWrSrc= 2'b01;
        end
        7'b100011:begin  // Tipo S
          RUWr= 0;
          ALUOp= 3'b000;
  		  IMMSrc= 3'b001;
  		  ALUASrc= 0;
  		  ALUBSrc= 1;
  		  DMWr= 1;
          DMCtrl= funct3;
          BrOp= {2'b00, funct3};
        end
        7'b1100011: begin  // Tipo B
          RUWr= 0;
          ALUOp= 3'b000;
  		  IMMSrc= 3'b101;
  		  ALUASrc= 1;
  		  ALUBSrc= 1;
  		  DMWr= 0;
          BrOp= {2'b01, funct3};
        end
        7'b1101111: begin // Tipo J
          RUWr= 1;
          ALUOp= 3'b000;
  		  IMMSrc= 3'b110;
  		  ALUASrc= 1;
  		  ALUBSrc= 1;
  		  DMWr= 0;
          BrOp= 5'b1xxxx;
          RUDataWrSrc= 2'b10;
        end
      7'b1100111: begin // Tipo I-Salto
          RUWr= 1;
          ALUOp= 3'b000;
  		  IMMSrc= 3'b000;
  		  ALUASrc= 0;
  		  ALUBSrc= 1;
  		  DMWr= 0;
          BrOp= 5'b1xxxx;
          RUDataWrSrc= 2'b10;
        end
      7'b110111: begin  // Tipo U
          RUWr= 0;
          ALUOp= 4'b0111;
  		  IMMSrc= 3'b010;
  		  ALUBSrc= 1;
  		  DMWr= 0;
          BrOp= {2'b00, funct3};
          RUDataWrSrc= 2'b00;
        end
      endcase
endmodule