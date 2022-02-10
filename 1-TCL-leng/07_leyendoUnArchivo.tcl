 #abriendo un archivo desde tcl
#NOTA
#   cuando estemos en open sees a veces sera necesario que 
#   ingresemos datos, opensees ya cuenta con modulos para este
#   pero sera necesario ver algunos tipos de ejemplos
#
# NOTA no es necesario que aprenda todos los comandos de tcl
#    este ejemplo es solo instructivo
#
#    identificando nombre de archivo a abrir
set nombreArchivo "datosexternos.txt"

puts "--------------------------------------------------------"
puts "ejemplo de lectura de un archivo externo"
puts [concat "El archivo para abrir es >>> " $nombreArchivo ]
puts ""

set abrirArchivo [open $nombreArchivo]
set contenidoArchivo [read $abrirArchivo]
set lineasTexto [split $contenidoArchivo "\n"]

  foreach linea $lineasTexto {
    #ciclo para cada una de las lineas de texto
    puts [concat " en texto >>>" $linea]
  }

puts "-------------------------------------------------------"
