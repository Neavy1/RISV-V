module ImmGen(immSrc, data, immExt);

  input logic [2:0] immSrc;
  input logic [24:0] data;
  output logic [31:0] immExt;

  always@(*) begin
    case(immSrc)
        3'b000:
          begin
            if(data[24] ==1)
            	immExt = -$signed(data[24:13]); //Tipo I
            else
              immExt = $signed(data[24:13]);
          end
        3'b001:immExt= $signed({data[24:18], data[4:0]}); //Tipo S
        3'b101:immExt= $signed({data[24], data[0], data[23:18], data[4:1],1'b0}); //Tipo B
        3'b010:immExt= $signed(data[24:5]); //Tipo U
        3'b110:immExt= $signed({data[24],data[12:5],data[13], data[23:14], 1'b0}); //Tipo J
      endcase
  end
endmodule