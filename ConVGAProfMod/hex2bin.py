def hexadecimal_a_binario(hexadecimal):
    # Convierte el número hexadecimal a un número decimal
    decimal = int(hexadecimal, 16)
    # Convierte el número decimal a binario y quita el prefijo '0b'
    binario = bin(decimal)[2:]
    # Asegura que el número binario tenga 8 bits
    binario_8_bits = binario.zfill(8)
    return binario_8_bits

def leer_y_convertir_archivo(archivo_entrada, archivo_salida):
    with open(archivo_entrada, 'r') as file_in, open(archivo_salida, 'w') as file_out:
        for linea in file_in:
            # Elimina los posibles espacios en blanco y saltos de línea
            hexadecimal = linea.strip()
            binario_8_bits = hexadecimal_a_binario(hexadecimal)
            file_out.write(binario_8_bits + '\n')

# Especifica los nombres de los archivos de entrada y salida
archivo_entrada = 'char_Rom.hex'
archivo_salida = 'archivo_binario.txt'

leer_y_convertir_archivo(archivo_entrada, archivo_salida)
