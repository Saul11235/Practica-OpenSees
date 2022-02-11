# MODELO 3D, COLUMNA CON AISLADOR, ELEMENTO ELÁSTICO
# UNIDADES T, m, seg
# INICIO
#===========================================================
wipe;
# borra de la memoria modelos anteriores
model BasicBuilder -ndm 3 -ndf 6; # defino el modelo 3d y 6gdl por nudo
set dataDir DatosColAisl; # asigno el nombre DatosAislad al directorio dataDir
file mkdir $dataDir;
# Defino mi archivo de salida
puts "MODELO DEFINIDO"
# DEFINO LA GEOMETRÍA, SECCIONES Y PROP DE MATERIALES
#===========================================================
# DEFINO PARÁMETROS GEOMÉTRICOS DE LA ESTRUCTURA
set LCol 4;
# altura de columna (paralela eje y)
set Peso 20;
# Peso superestructura
set g 9.81;
# Aceleración de la gravedad
set HCol 0.30;
# altura columna
set BCol 0.30;
# base columna
set Ec 1800000;
# módulo young del concreto
set nu 0.2;
# modulo de Poisson
set Gc [expr $Ec/(2./(1+$nu))]; # modulo rigidez por corte
set J 10000000;
# asigno gran rigidez torsional
set GammaConcreto 2.4; # peso especifico horm armado
# PROPIEDADES DE LA SECCIÓN COLUMNA:
set AgCol [expr $HCol*$BCol];
# área columna
set IzCol [expr 1./12*$BCol*pow($HCol,3)];
# inercia respecto al eje local z
set IyCol [expr 1./12*$HCol*pow($BCol,3)];
# inercia respecto al eje loal y
puts "SECCIONES INGRESADAS Y PROPIEDADES CALCULADAS"
# DEFINO COORDENADAS NODALES
#===========================================================
# determino la localización de la intersección de ejes de vigas y columnas
set X1 0.;
set Y1 0.;
set Y2 [expr $Y1 + $LCol];
set Z1 0.0;
node 111 $X1 $Y1 $Z1;
node 121 $X1 $Y2 $Z1;
# DEFINO NUDOS PARA AISLADORES
node 101 $X1 $Y1 $Z1;
# BOUNDARY CONDITIONS
fix 101 1 1 1 1 1 1;
# para aisladores
fix 111 0 1 1 1 1 1;
# pie de columnas
puts "NUDOS CREADOS Y RESTRINGIDOS"
# DEFINO ETIQUETAS DE SECCIONES:
set ColSecTag 1
set SecTagTorsion 70
# DEFINO TIPO DE SECCIONES ELÁSTICAS
section Elastic $ColSecTag $Ec $AgCol $IzCol $IyCol $Gc $J
#PARA LOS AISLADORES
uniaxialMaterial Elastic 4 20 0.1
uniaxialMaterial Elastic 5 21000000
#Material gran rigidez vertical
puts "SECCIONES ELASTICAS CREADAS"
# DEFINO LOS ELEMENTOS
#===========================================================
# defino transformación geométrica de elemento
set IDColTransf 1;
set ColTransfType Linear ;
geomTransf $ColTransfType $IDColTransf 0 0 1 ;
# CREO ELEMENTOS COLUMNAS
# columna
element elasticBeamColumn 1111 111 121 $AgCol $Ec $Gc $J $IyCol $IzCol $IDColTransf;
# DEFINO LOS AISLADORES
# tag ndI ndJ nsecs secID transfTag
element zeroLength 1101 101 111 -mat 4 5 -dir 1 2
puts "ELEMENTOS CREADOS"
#DEFINO CARGAS GRAVITARIAS, PESO Y MASAS
#===========================================================
#DEFINICIÓN DE LAS CARGAS
set QdlCol [expr $GammaConcreto*$HCol*$BCol]; # peso por longitud columna
set PesoCol [expr $QdlCol*$LCol];
# peso total columna
# ASIGNO MASAS EN LOS NUDOS
set Masa [expr ($PesoCol/$g)];
set Mcero 1.e-6;
mass 121 $Masa $Mcero $Masa $Mcero $Mcero $Mcero;
puts "CARGAS DEFINIDAS Y MASAS ASIGNADAS"
# DEFINO RECORDERS
#===========================================================
recorder Node -file $dataDir/DAisl.out -time -node 111 -dof 1 2 3 disp;
#DESPLA CABEZA AISL
recorder Node -file $dataDir/DLibres.out -time -node 121 -dof 1 disp;
#DESPLA NUDO LIBRE
recorder Node -file $dataDir/RBase.out -time -node 111 101 -dof 1 2 3 reaction;
#REACCIONES EN LOS APOYOS
recorder Drift -file $dataDir/Deriv.out -time -iNode 111 -jNode 121 -dof 1 - perpDirn 2;  
# DERIVA DE PISO
recorder Element -file $dataDir/Fel1.out -time -ele 1111 localForce;
#
#FUERZAS EN ELEMENTOS COORDENAS LOCALES
puts "RECORDERS CREADOS"
# ANÁLISIS GRAVITATORIO
#===========================================================
# cargas gravitatorias aplicadas en elemento
pattern Plain 101 Linear {
# columna
eleLoad -ele 1111 -type -beamUniform 0. 0. -$QdlCol; # Peso Distribuido
load 121 0 -$Peso 0 0 0 0 ;
# Carga axial aplicada en el nudo 121
}
set Tol 1.0e-8;
# Tolerancia para la prueba de convergencia
set constraintsTypeGravity Plain;
# default;
constraints $constraintsTypeGravity; # condiciones de borde
numberer RCM;
# reenumera los dof para minimizar el ancho de banda
system BandGeneral ;# como se resuelven el sistema de ecuaciones
test EnergyIncr $Tol 6 ;
# determina si la convergencia ha sido alcanzada
algorithm Newton;
# usa algortimo de newton para la solución
set NpGrav 10;
# aplico carg gravit en 10 intervalos
set DGrav [expr 1./$NpGrav];
# incrementos para la aplicación de la carga;
integrator LoadControl $DGrav; # determino el paso de tiempo para el análisis
analysis Static;
# defino tipo de análisis (estático)
analyze $NpGrav;
# aplico cargas gravitatorias
loadConst -time 0.0; # mantiene constante las cargas gravit y reinicia el tiempo
set Tol 1.0e-6;
# reduce la tolerancia después de las cargas gravit
puts "ANALISIS GRAVITATORIO REALIZADO"
# ACCIÓN SÍSMICA UNIFORME
#===========================================================
# ASIGNO AMORTIGUAMIENTO RAYLEIGH
wipeAnalysis; # Borra los objetos que definen el tipo de análisis
set xDamp 0.05;
# factor de amortiguamiento
set lambda [eigen 1]; # eigenvalor modo 1
set omega [expr pow($lambda,0.5)];
set betaKcomm [expr 2.*$xDamp/($omega)]; #betaKcomm*KlastCommitt
rayleigh 0.0 0.0 0.0 $betaKcomm;
# Amortiguamiento RAYLEIGH
# COLOCAR PARÁMETROS PARA ANÁLISIS SÍSMICO
set DtAnalysis [expr 0.02]; # paso para análisis sísmico
set TmaxAnalysis [expr 40];
# duración del sismo (max 50seg)
set IDloadTag 400; # etiqueta para patrón de carga
set dt 0.02;
# paso del sismo
set GMdirection 1; # dirección del sismo
set AccelSeries "Series -dt $dt -filePath centro.txt -factor 2"; # defino sismo y
#factor de escala
pattern UniformExcitation $IDloadTag $GMdirection -accel $AccelSeries ; #
#jcreo accion uniforme
# Defino parámetros del análisis
constraints Transformation; # Forma en que se manejan restricciones de nudo
numberer Plain ; # Forma de numerar nudos para minimizar ancho de banda
system SparseGeneral -piv; # Algoritmo de solución de sistema de ecuaciones
set maxNumIter 6 ; # Maximo numero de iteraciones para alcanzar tolerancia
set printFlag 0; ;
# Para que OpenSees notifique sobre falta de convergencia
set TestType EnergyIncr ; # Tipo de test para prueba de convergencia
set Tol 1.e-6 ;
# Tolerancia en la solución
test $TestType $Tol $maxNumIter $printFlag
set algorithmType ModifiedNewton ;
# Algoritmo de solución paso a paso
algorithm $algorithmType
set NewmarkGamma 0.5; # Parámetro gama para el método de Newmark
set NewmarkBeta 0.25; # Parámetro beta para el método de Newmark
integrator Newmark $NewmarkGamma $NewmarkBeta
analysis Transient ;# Tipo de análisis
set Nsteps [expr int($TmaxAnalysis/$DtAnalysis)];
set ok [analyze $Nsteps $DtAnalysis]; # Realizo análisis; regreso ok=0 si el
#análisis es exitoso
#PROCEDIMIENTO EN CASO DE ANÁLISIS NO EXITOSO
if {$ok != 0} { ;
# análisis fallido
# Se cambia algunos parámetros para alcanzar convergencia
# El proceso es más lento dentro del lazo
# Análisis controlado por tiempo
set ok 0;
set controlTime [getTime];
while {$controlTime < $TmaxAnalysis && $ok == 0} {
set controlTime [getTime]
set ok [analyze 1 $DtAnalysis]
if {$ok != 0} {
puts "Trying Newton with Initial Tangent .."
test NormDispIncr $Tol 1000 0
algorithm Newton -initial
set ok [analyze 1 $DtAnalysis]
test $testTypeDynamic $TolDynamic $maxNumIterDynamic 0
algorithm $algorithmTypeDynamic
}
if {$ok != 0} {
puts "Trying Broyden .."
algorithm Broyden 8
set ok [analyze 1 $DtAnalysis]
algorithm $algorithmTypeDynamic
}
if {$ok != 0} {
puts "Trying NewtonWithLineSearch .."
algorithm NewtonLineSearch .8
set ok [analyze 1 $DtAnalysis]
algorithm $algorithmTypeDynamic
}
}
}; # end if ok !0
puts "ANÁLISIS DINÁMICO REALIZADO: [getTime]"


