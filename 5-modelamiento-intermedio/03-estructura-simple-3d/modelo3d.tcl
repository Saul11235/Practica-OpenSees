# EJEMPLO 3
# ELEMENTOS VIGA, COLUMNA CON SECCIONES ELÁSTICAS
# UNIDADES T, m, seg
# INICIO
#===========================================================
wipe; # borra de la memoria modelos anteriores
model BasicBuilder -ndm 3 -ndf 6; # defino el modelo 3d y 6gdl por nudo
set dataDir Datos3; # asigno el nombre Datos3 al directorio datadir
file mkdir $dataDir; # defino mi archivo de salida Datos1
puts "MODELO DEFINIDO!"
# DEFINO LA GEOMETRÍA, SECCIONES Y PROP DE MATERIALES
#===========================================================
set LCol 3;
# longitud de columna (paralela eje y)
set LViga 5; # longitud viga (paralela eje x)
set LGird 5; # longitud viga (paralela eje z)
set HCol 0.30;
# altura columna
set BCol 0.30;
# base columna
set HViga 0.30;
# altura viga eje x
set BViga 0.20;
# base viga eje x
set HGird 0.30;
# altura viga eje z
set BGird 0.20;
# base viga eje z
set Ec 1800000;
# módulo Young del concreto
set nu 0.2;
# modulo de Poisson
set Gc [expr $Ec/(2./(1+$nu))]; # modulo rigidez por corte
set J 10000000;
# asigno gran rigidez torsional
set GammaConcreto 2.4; # peso especifico hormigón armado
set g 9.8;
# Aceleración de la gravedad
# COORDENADAS NODALES
#===========================================================
# DETERMINO LA LOCALIZACIÓN DE LA INTERSECCIÓN DE EJES DE
#VIGAS Y COLUMNAS
set X1 0.;
set X2 [expr $X1 + $LViga];
set Y1 0.;
set Y2 [expr $Y1 + $LCol];
set Z1 0.0;
set Z2 [expr $Z1 + $LGird];
node 111 $X1 $Y1 $Z1;
# PÓRTICO 1
node 112 $X2 $Y1 $Z1;
node 121 $X1 $Y2 $Z1;
node 122 $X2 $Y2 $Z1;
node 211 $X1 $Y1 $Z2;
# PÓRTICO 2
node 212 $X2 $Y1 $Z2;
node 221 $X1 $Y2 $Z2;
node 222 $X2 $Y2 $Z2;
#DIAFRAGMA RÍGIDO DE PISO
set RigidDiaphragm ON ; # opciones: on, off. Especificar
set Xa [expr ($X2)/2];
# coordenadas para el diafragma rígido
set Za [expr ($Z2)/2];
# NUDOS PARA DIAFRAGMA RÍGIDO, EN EL CENTRO DE CADA
#DIAFRAGMA
#===========================================================
set RigidDiaphragm ON ; # esto comunica al análisis los parámetros que
#estaré usando para diafragma rígido
node 1121 $Xa $Y2 $Za;
# nudo master -- piso 2, vano 1, pórtico 1-2
# RESTRICCIONES PARA NUDOS MASTER DE DIAFRAGMAS RÍGIDOS
fix 1121 0 1 0 1 0 1
puts "NUDOS CREADOS Y RESTRINGIDOS"
# DEFINO DIAFRAGMA RÍGIDO, GDL 2 ES NORMAL AL PISO
#===========================================================
set perpDirn 2;
rigidDiaphragm $perpDirn 1121 121 122 221 222;
# NIVEL 2
# RESTRICCIONES EN LOS APOYOS
fix 111 1 1 1 1 1 1
# nudos de apoyo empotrados
fix 112 1 1 1 1 1 1
fix 211 1 1 1 1 1 1
fix 212 1 1 1 1 1 1
puts "DIAFRAGMA CREADO"
# DEFINO ETIQUETAS DE SECCIONES:
set ColSecTag 1
set BeamSecTag 2
set GirdSecTag 3
set SecTagTorsion 70
# PROPIEDADES DE LA SECCIÓN COLUMNA:
set AgCol [expr $HCol*$BCol];
# área columna
set IzCol [expr 1./12*$BCol*pow($HCol,3)]; # inercia con respecto al eje local z
set IyCol [expr 1./12*$HCol*pow($BCol,3)]; # inercia con respecto al eje local z
# SECCIONES VIGA:
set AgViga [expr $HViga*$BViga]; # área vigas
set IzViga [expr 1./12*$BViga*pow($HViga,3)]; # inercia respecto a eje local z
set IyViga [expr 1./12*$HViga*pow($BViga,3)]; # inercia respecto a eje local y
# SECCIONES VIGA Z:
set AgGird [expr $HGird*$BGird];
# área vigas
set IzGird [expr 1./12*$BGird*pow($HGird,3)]; # inercia respecto a eje local z
set IyGird [expr 1./12*$HGird*pow($BGird,3)]; # inercia respecto a eje local y
section Elastic $ColSecTag $Ec $AgCol $IzCol $IyCol $Gc $J
section Elastic $BeamSecTag $Ec $AgViga $IzViga $IyViga $Gc $J
section Elastic $GirdSecTag $Ec $AgGird $IzGird $IyGird $Gc $J
puts "SECCIONES CREADAS"
# DEFINO LOS ELEMENTOS
#===========================================================
# DEFINO TRANSFORMACIÓN GEOMÉTRICA DE ELEMENTO
set IDColTransf 1; # todas las columnas
set IDBeamTransf 2; # vigas en x
set IDGirdTransf 3; # vigas en z
set ColTransfType Linear ;
geomTransf $ColTransfType $IDColTransf 0 0 1
geomTransf Linear $IDBeamTransf 0 0 1
geomTransf Linear $IDGirdTransf 1 0 0
# DEFINO ELEMENTOS COLUMNAS Y VIGAS
# PÓRTICO 1
# Columnas
element elasticBeamColumn 1111 111 121 $AgCol $Ec $Gc $J $IyCol $IzCol $IDColTransf;
element elasticBeamColumn 1112 112 122 $AgCol $Ec $Gc $J $IyCol $IzCol $IDColTransf;
# Vigas paralelas a Y
element elasticBeamColumn 1221 121 122 $AgViga $Ec $Gc $J $IyViga $IzViga $IDBeamTransf;;
# PÓRTICO 2
# Columnas
element elasticBeamColumn 2111 211 221 $AgCol $Ec $Gc $J $IyCol $IzCol $IDColTransf;
element elasticBeamColumn 2112 212 222 $AgCol $Ec $Gc $J $IyCol $IzCol $IDColTransf;
#Vigas
element elasticBeamColumn 2221 221 222 $AgViga $Ec $Gc $J $IyViga $IzViga $IDBeamTransf;
#Vigas (eje Z) Conectan Pórticos
# Póticos 1-2
element elasticBeamColumn 1321 121 221 $AgGird $Ec $Gc $J $IyGird $IzGird $IDGirdTransf;
element elasticBeamColumn 1322 122 222 $AgGird $Ec $Gc $J $IyGird $IzGird $IDGirdTransf;
puts "ELEMENTOS CREADOS"
#DEFINO CARGAS GRAVITARIAS, PESO Y MASAS
#===========================================================
#DEFINICIÓN DE LAS CARGAS
set QdlCol [expr $GammaConcreto*$HCol*$BCol]; # peso por longitud columna
set QViga [expr $GammaConcreto*$HViga*$BViga]; # peso por longitud viga
set QGird [expr $GammaConcreto*$HGird*$BGird]; # peso por longitud girders
set TLosa 0.20; # espesor supuesto para losa
set LLosa [expr $LGird/2]; # losa se extiende una distancia de $LGird/2
set Qlosa [expr $GammaConcreto*$TLosa*$LLosa];
set QdlViga [expr $Qlosa + $QViga];
# carga muerta distribuida en la viga
set QdlGird $QGird;
# carga muerta distribuida en viga (eje z)
set PesoCol [expr $QdlCol*$LCol];
# peso total columna
set PesoViga [expr $QdlViga*$LViga];
# peso total viga
set PesoGird [expr $QdlGird*$LGird];
# peso total viga (eje z)
# ASIGNO MASAS EN LOS NUDOS
# CADA NUDO TOMA 1/2 DE LA MASA DE CADA ELEMENTO DEL
#PÓRTICO
set Masa [expr ($PesoCol/2 + $PesoViga/2+$PesoGird/2)/$g];
set Mcero 1.e-6;
# PÓRTICO 1
mass 121 $Masa $Mcero $Masa $Mcero $Mcero $Mcero;
mass 122 $Masa $Mcero $Masa $Mcero $Mcero $Mcero;
# PÓRTICO 2
mass 221 $Masa $Mcero $Masa $Mcero $Mcero $Mcero;
mass 222 $Masa $Mcero $Masa $Mcero $Mcero $Mcero;
set PesoPiso1 [expr 4*$PesoCol + 2*$PesoGird + 2*$PesoViga];
set PesoTotal [expr 1* $PesoPiso1];
# peso total de la estructura
set MasaTotal [expr $PesoTotal/$g];
# masa total del edificio
puts "CARGAS DEFINIDAS Y MASAS ASIGNADAS"
# DEFINO RECORDERS
#===========================================================
#recorder Node -file $dataDir/DEMP.out -time -node 111 112 211 212 -dof 1 2 3 disp;
#desplazamiento nudos de apoyo (debe ser cero)
recorder Node -file $dataDir/DLibres.out -time -node 121 122 221 222 -dof 1 disp;
#desplazamientos nudos libres para GDL 1
recorder Node -file $dataDir/RBase.out -time -node 111 112 211 212 -dof 1 2 3 reaction;
#reacciones en los apoyos
recorder Drift -file $dataDir/Deriv.out -time -iNode 112 212 -jNode 122 222 -dof 1 -perpDirn 2;
# deriva de piso
recorder Element -file $dataDir/Fel1.out -time -ele 1111 localForce; # fuerzas en
#elementos coordenadas locales
# ANÁLISIS GRAVITATORIO
#===========================================================
# Defino cargas gravitatorias aplicadas en los elementos
pattern Plain 101 Linear {
# Pórtico 1
# Columnas
eleLoad -ele 1111 -type -beamUniform 0. 0. -$QdlCol;
eleLoad -ele 1112 -type -beamUniform 0. 0. -$QdlCol
# Vigas
eleLoad -ele 1221 -type -beamUniform -$QdlViga 0.;
# Pórtico 2
# Columnas
eleLoad -ele 2111 -type -beamUniform 0. 0. -$QdlCol;
#1-2
eleLoad -ele 2112 -type -beamUniform 0. 0. -$QdlCol
# Vigas
eleLoad -ele 2221 -type -beamUniform -$QdlViga 0.;
# Vigas (eje z)
# Frame 1-2
eleLoad -ele 1321 -type -beamUniform $QdlGird 0.;
eleLoad -ele 1322 -type -beamUniform $QdlGird 0.;
}
set Tol 1.0e-8;
# Tolerancia para la prueba de convergencia
variable constraintsTypeGravity Plain;
# default;
if { [info exists RigidDiaphragm] == 1} {
if {$RigidDiaphragm=="ON"} {
variable constraintsTypeGravity Lagrange; # large model: try
#Transformation
};
# Si rigid diaphragm está “on”
};
# Si existe diafragma rígido
constraints $constraintsTypeGravity; # forma en que se manejan las
#restricciones de nudo
numberer RCM;
# reenumera los GDL para minimizar el ancho de banda
system BandGeneral ;
# como se resuelven las ecuaciones en el análisis
test EnergyIncr $Tol 6 ;
# determina si la convergencia ha sido alcanzada
algorithm Newton;
# usa algoritmo de newton para la solución
set NpGrav 10;
# aplico carga gravitatoria en 10 intervalos
set DGrav [expr 1./$NpGrav];
# incrementos para la aplicación de la carga;
integrator LoadControl $DGrav; # determino el paso de tiempo para el análisis
analysis Static;
# defino tipo de análisis (estático)
analyze $NpGrav;
# aplico cargas gravitatorias
loadConst -time 0.0; # mantiene constante las cargas gravit y reinicia el tiempo
set Tol 1.0e-6; # reduce la tolerancia después de aplicar las cargas gravitat
puts "ANÁLISIS GRAVITATORIO REALIZADO"
# ACCIÓN SÍSMICA UNIFORME
#===========================================================
# COLOCAR PARÁMETROS PARA ANÁLISIS SÍSMICO
wipeAnalysis; # Borra los objetos que definen el tipo de análisis
set DtAnalysis [expr 0.02]; # paso para análisis sísmico
set TmaxAnalysis [expr 40];
# duración del sismo (max 50seg)
# ASIGNO AMORTIGUAMIENTO RAYLEIGH
set xDamp 0.05;
# factor de amortiguamiento
set MpropSwitch 1.0;
set KcurrSwitch 0.0;
set KcommSwitch 0.0;
set KinitSwitch 0.0;
set nEigenI 1;
# modo1
set nEigenJ 2;
set lambdaN [eigen [expr $nEigenJ]];
set lambdaI [lindex $lambdaN [expr $nEigenI-1]];
# eigenvalor modo i
set lambdaJ [lindex $lambdaN [expr $nEigenJ-1]];
# eigenvalor modo j
set omegaI [expr pow($lambdaI,0.5)];
set omegaJ [expr pow($lambdaJ,0.5)];
set alphaM [expr $MpropSwitch*$xDamp*(2*$omegaI*$omegaJ)/($omegaI+$omegaJ)];
set betaKcurr [ expr $KcurrSwitch*2.*$xDamp/($omegaI+$omegaJ)] ;
set betaKcomm [ expr $KcommSwitch*2.*$xDamp/($omegaI+$omegaJ)] ;
set betaKinit [expr $KinitSwitch*2.*$xDamp/($omegaI+$omegaJ)];
rayleigh $alphaM $betaKcurr $betaKinit $betaKcomm;
set IDloadTag 400; # etiqueta para patrón de carga
set dt 0.02;
# paso con el cual se registro sismo
set GMdirection 1; # dirección del sismo (GDL correspondiente)
set AccelSeries "Series -dt $dt -filePath centro.txt -factor 1"; # defino sismo y
#factor de escala (En este caso sismo Centro)
pattern UniformExcitation $IDloadTag $GMdirection -accel $AccelSeries; #
#creo acción uniforme
#
# OJO >>>>>>> AQUI SE HA MODIFICADO EL SCRIPT
# Parámetros para el análisis
#source LibAnalysisDynamicParameters.tcl; #Invoco a la función externa que
#define los parámetros de análisis
#
set Nsteps [expr int($TmaxAnalysis/$DtAnalysis)]; #número pasos de análisis
set ok [analyze $Nsteps $DtAnalysis]; # realizo análisis; regreso ok=0 si el
#análisis es exitoso
#procedimiento en caso de análisis no exitoso
if {$ok != 0} { ;
# análisis fallido
# Se cambia algunos parámetros para alcanzar convergencia
# El proceso es más lento dentro de este lazo
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
puts "ANÁLISIS DINÁMICO REALIZADO. End Time: [getTime]"


