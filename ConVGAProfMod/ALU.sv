module ALU(ASrc, BSrc, aluOp, alures);
  input logic [31:0] ASrc;
  input logic [31:0] BSrc;
  input logic [3:0] aluOp;
  output logic [31:0] alures;
/* Bloque always para la lógica de la ALU
   * Evalúa la señal de control aluOp para determinar la operación a realizar
   * entre los operandos ASrc y BSrc.
*/
  always @(*) begin
    case (aluOp)
      4'b0000: alures <= ASrc + BSrc; // Suma
      4'b1000: alures <= ASrc - BSrc; // Resta
      4'b0001: alures <= ASrc << BSrc; // Desplazamiento lógico izquierdo
      4'b0010: alures <= ASrc < BSrc; // Comparación menor que (signed)
      4'b0011: alures <= ASrc < $unsigned(BSrc); // Comparación menor que (unsigned)
      4'b0100: alures <= ASrc ^ BSrc; // Operación XOR
      4'b0101: alures <= ASrc >> BSrc; // Desplazamiento aritmético derecho (sign extend)
      4'b1101: alures <= ASrc >>> BSrc; // Desplazamiento lógico derecho (zero extend)
      4'b0111: alures <= ASrc & BSrc; // Operación AND
      4'b0110: alures <= ASrc | BSrc; // Operación OR
    endcase
  end
endmodule

