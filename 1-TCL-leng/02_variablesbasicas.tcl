#Ejemplo de variables sencillas

puts "----------------------------------------"  
puts "Ejemplo de uso sencillo de variables" 

#ejemplo de guardado de un entero
set Entero 2  
puts "\nEntero guardado es " 
puts $Entero

#numero racional guardado 
set Racional -3.141
puts "\nRacional guardado es"
puts $Racional

#guardando string
set Texto ">>Hola este es un texto guardado como variable"
puts "\nTexto guardado es"
puts $Texto;

#guardando array
set Lista {1 2 3}
puts "\nLista guardada es"
puts $Lista

#guardando expresion 
set expresion {$variable1 + $variable2}
puts "\nLa expresion guardada es"
puts $expresion

