#en este ejemplo veremos como podremos escribir sencillamente un archivo
#NOTA ,.
#   En OpenSees hay objetos llamados RECORDERS que recolectan
#   la informacion de nuestros calculos, y se almacenan en 
#   archivos externos de texto plano que pueden ser interpretados
#   por otros programas

# para este ejemplo solo repetiremos una linea de texto 3 veces
#
#=============================================================
#
# vamos a eliminar el archivo datosExternos.txt 
# lpara no acumular lineas
#
file delete "datosExternos.txt" 
puts "---------------------------------------------------"

set lineaDeTexto "Hola soy una linea de texto\n"
set nombreArchivo "datosExternos.txt"
#modulo de abrir documento para escritura
set abrirDoc [ open $nombreArchivo "w"] 
#escribir TRES lineas de texto
puts -nonewline $abrirDoc $lineaDeTexto 
puts -nonewline $abrirDoc $lineaDeTexto 
puts -nonewline $abrirDoc $lineaDeTexto 

#se ha creado el archivo correctamente
puts "se ha creado el archivo $nombreArchivo con exito"
puts "-----------------------------------------------------"

