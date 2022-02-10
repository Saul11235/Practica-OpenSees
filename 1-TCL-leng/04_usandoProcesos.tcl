puts "------------------------------------------------------"
#los procesos son mas parecidos a las funciones en otros lenguajes, cada uno de estos 
#tienen argumentos de entrada y realizan operaciones, seran el metodo por defecto que
#usaremos para configurar e ingresar datos dentro de openseees

#declarando un proceso
proc sumaDeDosNums {num1  num2} {
  #calculando la respuesta
  set respuesta [expr {$num1+$num2}]
  #creamos un pequen'o letrero
  puts [concat "Se han sumado los numeros" $num1 "+" $num2 "=" $respuesta]  
  #Se devolvera un argumento como respuesta
  return $respuesta 
}

#realizaremos la suma de varios numeros
#NOTA.- Las funciones pueden declarase en una sola linea sin simbolos

sumaDeDosNums 1 2
sumaDeDosNums 44 55 
sumaDeDosNums 55 888

#NOTA recuerde que para usar opensees usaremos funciones propias de este sistema y no de tcl
#estos apuntes son de referencia antes de usar opensees



