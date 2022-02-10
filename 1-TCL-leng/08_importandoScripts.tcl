#habran veces en que sea necesario importar contenido de otros
#archivos-scripts tcl-
#ya sea para 
#no sobrecargar nuestro archivo - ser organizados etc
#esto es muy sencillo solo usaremos el comando source

#Para este ejemplo importaremos los ejemplos 1 y 2
#
puts "\nimportaremos los ejemplos uno y dos\n"

puts "========================================================"
puts "\nEjemplo 1 >> "
  #Uso de source
  source "01_HolaMundo.tcl"
puts "========================================================"
puts "\nEjemplo 2 >> "
  #uso de source
  source "02_variablesbasicas.tcl"
puts "======================================================="

