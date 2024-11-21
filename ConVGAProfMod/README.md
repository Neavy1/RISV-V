# Procesador Monociclo Risc V 32i

## Modulos 
**ALU (Unidad Lógico-Aritmética)**
  -  Este módulo realiza operaciones aritméticas y lógicas según la señal de control aluOp.
  - Soporta múltiples operaciones básicas sobre los operandos ASrc y BSrc.

- **Parámetros:**
  - `clk`: Señal de reloj.
  - `rst`: Señal de reinicio.
  - `we`: Señal de escritura habilitada.
  - `wrAddr`: Dirección de escritura.
  - `rdAddr1`: Dirección de lectura 1.
  - `rdAddr2`: Dirección de lectura 2.
  - `wrData`: Datos a escribir.

- **Salidas**
  - `rdData1`: Datos leídos desde la dirección 1.
  - `rdData2`: Datos leídos desde la dirección 2

- **Funcionamiento**
- *Operación de Escritura (`Write Operation`)*:
  - Utiliza un ciclo `always_ff` sincronizado con el flanco positivo del reloj o el flanco positivo del reinicio (`rst`).
  - Si la señal de reinicio está activada (`rst`), todos los registros se establecen en cero.
  - Si la señal de escritura está habilitada (`we`) y la dirección de escritura no es cero (`wrAddr != 0`), se escribe el dato proporcionado en la dirección especificada del archivo de registros.

- *Operación de Lectura (`Read Operation`)*:
  - Lee los datos desde las direcciones especificadas (`rdAddr1` y `rdAddr2`) del archivo de registros.
  - Si la dirección de lectura es cero, devuelve cero, de lo contrario, retorna el valor almacenado en el registro correspondiente.

- **Operación de Escritura (`Write Operation`)**:
  - Utiliza un ciclo `always_ff` sincronizado con el flanco positivo del reloj o el flanco positivo del reinicio (`rst`).
  - Si la señal de reinicio está activada (`rst`), todos los registros se establecen en cero.
  - Si la señal de escritura está habilitada (`we`) y la dirección de escritura no es cero (`wrAddr != 0`), se escribe el dato proporcionado en la dirección especificada del archivo de registros.

- **Operación de Lectura (`Read Operation`)**:
  - Lee los datos desde las direcciones especificadas (`rdAddr1` y `rdAddr2`) del archivo de registros.
  - Si la dirección de lectura es cero, devuelve cero, de lo contrario, retorna el valor almacenado en el registro correspondiente.


- **USO:**
    - Este módulo puede ser utilizado como parte de un diseño más grande, proporcionando una funcionalidad de almacenamiento de datos con operaciones de lectura y escritura en un archivo de registros
- **Notas Adicionales**
- Asegúrate de proporcionar las señales de control y las direcciones apropiadas para el funcionamiento correcto de cada módulo correspondiente.

 ## Authors
Juan Esteban Salazar Narvaez - <> - <> - <><br />
Cindy Marcela Jimenez Saldarriaga - <> - <> - <><br />

## Contributors
Julian Esteban Collazos
