module CharROM (
    input logic [8:0] char_code,       // Código del carácter (entrada)
    input logic [3:0] line_number,     // Número de línea del carácter (entrada)
    output logic [7:0] char_line       // Línea de bits del carácter (salida)
);
    // Memoria ROM para almacenar las líneas de caracteres
    logic [7:0] rom [0:4095]; // 4096 líneas de 8 bits (512 caracteres * 8 líneas por carácter)

    // Inicialización de la ROM con los datos de la fuente
    initial begin
        $readmemh("char_rom.hex", rom); // Cargar los datos de la fuente desde un archivo hexadecimal
    end

    // Asignar la línea de bits correspondiente al carácter y número de línea
    assign char_line = rom[{char_code, line_number[2:0]}];
endmodule
