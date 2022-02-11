#Ejemplo de modelamiento de portico 2d
# EJEMPLO 1
# UNIDADES T, m, seg
# INICIO
#===========================================================
wipe; # borra de la memoria modelos anteriores
model BasicBuilder -ndm 2 -ndf 3; # defino el modelo 2d y 3gdl por nudo
set dataDir Datos1; # asigno el nombre Datos1 al directorio datadir
file mkdir $dataDir; # defino mi archivo de salida Datos1
puts "MODELO DEFINIDO!"
# COORDENADAS, RESTRICCIONES Y MASAS NODALES:
#===========================================================
node 1 0 0;
# nudo x, y
node 2 4 0
node 3 0 3
node 4 4 3
# RESTRICCIONES
fix 1 1 1 1;
# nudo DX DY RZ
fix 2 1 1 1
# MASAS NODALES:
mass 3 0.6 0. 0.;
# nudo#, Mx My Mz, Masa=Peso/g
mass 4 0.6 0. 0.;
puts "NUDOS CREADOS, RESTRINGIDOS Y MASAS ASIGNADAS!"
# DEFINO CARACTERÍSTICAS DE ELEMENTOS
#===========================================================
set LCol 3;
# longitud columna
set Lviga 4;
# longitud viga
set Wv 2.6;
# carga distribuido sobre la viga
set Peso 2.6*$Lviga;
# peso estructura
set xdamp 0.05;
# factor de amortiguamiento
set HCol 0.3;
# altura columna
set BCol 0.3;
# ancho columna
set Hviga 0.3;
# altura viga
set Bviga 0.25;
# base viga
set g 9.81;
# aceleración gravedad
set E 1800000;
# módulo de elasticidad del concreto
# CÁLCULO DE PARÁMETROS
set ACol [expr $BCol*$HCol];
# sección transversal para columna
set Aviga [expr $Bviga*$Hviga]; # sección transversal para viga
set IzCol [expr 1./12.*$BCol*pow($HCol,3)]; # Mom inercia de columna
set Izviga [expr 1./12.*$Bviga*pow($Hviga,3)]; # momento de inercia de viga
#TRANSFORMACIÓN GEOMÉTRICA
geomTransf Linear 1;
# asigno etiqueta de transformación geométrica
# CREO LOS ELEMENTOS
#===========================================================
#
#$eleTag $iNode $jNode $A $E $Iz $transfTag
element elasticBeamColumn 1 1 3 $ACol $E $IzCol 1
# elemento 1
element elasticBeamColumn 2 2 4 $ACol $E $IzCol 1
# elemento 2
element elasticBeamColumn 3 3 4 $Aviga $E $Izviga 1
# elemento 3
puts "ELEMENTOS CREADOS!"
# DEFINO RECORDERS
#===========================================================
recorder Node -file $dataDir/Dlibres.out -time -node 3 -dof 1 2 3 disp; #define
#en donde se almacenarán desplazamientos de nudo 3.
recorder Node -file $dataDir/RBase.out -time -node 1 2 -dof 1 2 3 reaction;
#define reacciones en soportes
recorder Drift -file $dataDir/Deriv.out -time -iNode 1 2 -jNode 3 4 -dof 1 - perpDirn 2 ; 
# deriva lateral
recorder Element -file $dataDir/FCol.out -time -ele 1 2 globalForce; 
# fuerzas en columnas
recorder Element -file $dataDir/FViga.out -time -ele 3 globalForce;
# fuerzas en vigas
puts "RECORDERS CREADOS!"
# DEFINO ANÁLISIS GRAVITATORIO
#===========================================================
pattern Plain 1 Linear {
eleLoad -ele 3 -type -beamUniform -$Wv ; # carga distribuida sobre la viga
}
constraints Plain; # forma en que se manejan las restricciones de nudo
numberer Plain;
# reenumera los dof para minimizar el ancho de banda
system BandGeneral; # como se resuelven las ecuaciones en el análisis
test NormDispIncr 1.0e-8 6 ; # determina si la convergencia ha sido alcanzada
algorithm Newton;
# usa el algoritmo de newton para la solución
integrator LoadControl 0.1; # aplico 10% de carga gravitatorio en cada paso
analysis Static;
# defino el tipo de análisis (estático)
analyze 10;
# Indico a OpenSEES realice 10 pasos de análisis
loadConst -time 0.0; # Congela aplicación de cargas gravit y reinicia el tiempo
puts "ANALISIS GRAVITATORIO REALIZADO!"
# ANÁLISIS DINÁMICO (SISMO)
#===========================================================
# creamos patrón de carga
set accelSeries "Series -dt 0.02 -filePath centro.txt -factor 1"; # defino
#acelerograma
pattern UniformExcitation 2 1 -accel $accelSeries;
# defino como y cuando
#aplico aceleración
rayleigh 0. 0. 0. [expr 2*$xdamp/pow([eigen 1],0.5)]; # asigno amortiguamiento
#basado en el primer modo
# CREAMOS EL ANÁLISIS
#===========================================================
wipeAnalysis; # borra los parámetros de análisis antes definidos
constraints Plain; # como son consideradas las condiciones de borde
numberer Plain;
# reenumera los dor para minimizar ancho de banda
system BandGeneral; # como se resuelven las ecuaciones en el análisis
test NormDispIncr 1.0e-8 10; # determina si la convergencia ha sido alcanzada
algorithm Newton;
# usa el algoritmo de newton para la solución
integrator Newmark 0.5 0.25 ;# método de Newmark
analysis Transient;
# defino el tipo de análisis:dependiente del tiempo
analyze 4000 0.01; # aplico 4000 0.01-sec intervalos de tiempo en el análisis
puts "ANALISIS DINAMICO REALIZADO TIEMPO: [getTime]!"





