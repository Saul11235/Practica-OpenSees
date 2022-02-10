#modelo sencillo de edificio en tcl para su uso en opensees
puts "-----------------------------------------------------"
puts "> Primera parte . configurando modelo"
#comando de opensees para borrar elementos de sesiones anteriores
wipe 
#
#COMANDO model BasicBuilder asigna dimensiones (2) y
#        grados de libertad del modelo por cada nudo 
#
model BasicBuilder -ndm 2 -ndf 3
#
# NOTA los valores entre signos son datos opcionales <>
#
puts "---------------------------------------------------"
puts "> Segunda parte . creando modelo"
#
#           fix(0,0,0)
#           n22 (10,10)
#                     (*)  ->Fextern=100
# FIX: dX,dY,Rz       / \
#                    /   \
#                   /     \
#                  /       \
#                 /         \
#      fix(1,1,0)/           \
#       n11(0,0)/             \
#             (*)-------------(*)  n33(20,0)
#              A               O    fix(0,0,0)
#             ===             ====
#
#COMANDO node $cod (ndm $coord) <-mass (ndf $valoresDeMasa)>
#        node $codigo $coordx $coordy
#
node 11  0    0 
node 22  10  10 
node 33  20   0 
#
#COMANDO fix $codNodo $coord 
#        para nfd 3 los GDL son:  despX despY rotacionZ
#
fix 11 1 1 0
fix 33 0 1 0
#
#COMANDO mass $codNodo $coord
#        asigna masa a cada nodo en cada GDL
#        se recomienda poner valores no nulos para que la
#        solucion sea convergente 
#
mass 11  0.1   0.1   0.1
mass 22  0.1   0.1   0.1
mass 33  0.1   0.1   0.1





