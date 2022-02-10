#a veces es necesario limpiar la memoria del sistema 
puts "----------------------------------------------"

#Nota para verificar esto se debe de analizar la salida en la terminal

#ejecutar cuando se llama a una variable aun no declarada

#declarando variable para trabajar
set var 3
puts "SE DECLARA LA VARIABLE $var\n" 

puts "se ha borrado la memoria con el comando unset\n"
#es recomendable usar esta variable al inicio
unset var

puts "se volvera a llamar a la VARIABLE "
puts "el programa se quejara y finalizara con una advertencia"
puts "----------------------------------------------"
puts $var


#En Opensees tenemos un comando similar llamado wipe
#pero solo se encargara de destruir los objetos de opeen sees
#y sus salidas o recorders
#es recomendable cada vez que se ejecuta un analisis
