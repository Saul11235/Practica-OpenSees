#ejemplo de como se resuelven problemas con tcl

puts "----------------------------------------------"
puts "primero declararemos algunas variables para operar" 

#NOTA podemos separar varias ordenes con ;
set var1 10; set var2 22; 
#colocando en pantalla las variables
#NOTA en caso sea necesario se pueden combinar los elementos 
# con doble $$ por ejemplo
puts [concat " var1=" $var1 ] 
puts [concat " var2=" $var2 ]
puts "-----------------------------------------------"

#para poder operar podremos utilizar la funcion expr
#para este ejemplo guardaremos una expresion
set suma  { $var1 + $var2 }   
#resolveremos los procesos con expr
puts [concat "var1 + var2 =" [expr  $suma ] ]

#o podremos declarar resolver directamente el proceso var
puts [concat "var1 - var2 =" [ expr {$var1-$var2} ]]

#multiplicaciones y divisiones
puts [concat "var1 * var2 =" [expr {$var1*$var2}]]
puts [concat "var1 / var2 =" [expr {$var1/$var2}]]
 
puts "------------------------------------------------"
