# EJEMPLO 2
# ELEMENTOS VIGA, COLUMNA CON SECCIONES TIPO FIBRA
# UNIDADES T, m, seg
# INICIO
#===========================================================
wipe; # borra de la memoria modelos anteriores
model BasicBuilder -ndm 2 -ndf 3; # defino el modelo 2d y 3gdl por nudo
set dataDir Datos2; # asigno el nombre Datos2 al directorio datadir
file mkdir $dataDir; # defino mi archivo de salida Datos1
puts "MODELO DEFINIDO!"
# DEFINO GEOMETRÍA Y PARÁMETROS
#===========================================================
set LCol 3;
# longitud columna
set LViga 4;
# longitud viga
set HCol 0.3;
# altura columna
set BCol 0.3;
# ancho columna
set HViga 0.3;
# altura viga
set BViga 0.25;
# base viga
set cover 0.03;
# recubrimiento
set fic 14;
# diámetro (mm) de varillas de acero columnas
set fiv 16;
# diámetro (mm) de varillas de acero vigas
set Asc [expr (3.1416*pow(0.001*$fic,2))/4]; # área varilla columna
set Asv [expr (3.1416*pow(0.001*$fiv,2))/4]; # área varilla viga
set H [expr 2*$LCol]; # altura de la estructura
set Wb 2.6;
# carga distribuida sobre la viga
set Peso 2*$Wb*$LViga; # peso estructura (2Pisos*LongViga*Carga) (aprox)
set g 9.81;
# aceleración de la gravedad (m/seg2)
set PCol [expr $Peso/4]; # peso nodal en columnas
set Mass [expr $PCol/$g]; # masa nodal
set fy 42000;
# esfuerzo de fluencia del acero de refuerzo
set E 21000000.0; # módulo de Young acero
set fc 2100;
# resistencia característica del hormigón
set xdamp 0.05;
# factor de amortiguamiento
# COORDENADAS NODALES:
#===========================================================
node 1 0 0;
# NUDO X, Y
node 2 $LViga 0
node 3 0 $LCol
node 4 $LViga $LCol
node 5 0 $H
node 6 $LViga $H
# RESTRICCIONES EN APOYOS
#===========================================================
fix 1 1 1 1;
# NUDO DX DY RZ
fix 2 1 1 1
puts "NUDOS CREADOS, RESTRINGIDOS!"
# MASAS NODALES:
#===========================================================
mass 3 $Mass 1.0e-8 1.0e-8;
# NUDO#, Mx My Mz, Mass=PESO/g
mass 4 $Mass 1.0e-8 1.0e-8;
mass 5 $Mass 1.0e-8 1.0e-8;
mass 6 $Mass 1.0e-8 1.0e-8;
#
#
#
puts "MASAS NODALES ASIGNADAS"
# DEFINO MATERIALES
#===========================================================
# CONCRETO DEL NÚCLEO (CONF)
# CONCRETO tag f'c ec0 f'cu ecu
uniaxialMaterial Concrete01 1 -3300 -0.004 -2600 -0.018
# CONCRETO EXTERIOR (NO CONFINADO)
uniaxialMaterial Concrete01 2 -$fc -0.002 0.0 -0.004
# ACERO DE REFUERZO
# tag fy E0 b
uniaxialMaterial Steel01 3 $fy $E 0.005
#PARÁMETROS AUXILIARES PARA DEFINIR SECCIÓN FIBRA
set y1 [expr $HCol/2.0]
set z1 [expr $BCol/2.0]
# CREO SECCIÓN FIBRA PARA COLUMNA
section Fiber 1 {
# CREO LAS FIBRAS DE CONCRETO CONFINADO
patch rect 1 10 1 [expr $cover-$z1] [expr $cover-$y1] [expr $z1-$cover] [expr $y1-$cover] 
# CREO LAS FIBRAS DE CONCRETO NO CONFINADO (DER, IZQU,
#ABAJO, ARRIBA)
patch rect 2 10 1 [expr $z1-$cover] [expr -$y1] $z1 $y1
patch rect 2 10 1 [expr -$z1] [expr -$y1] [expr $cover-$z1] $y1
patch rect 2 2 1 [expr $cover-$z1] [expr -$y1] [expr $z1-$cover] [expr $cover-$y1]
patch rect 2 2 1 [expr $cover-$z1] [expr $y1-$cover] [expr $z1-$cover] $y1
# CREO LAS FIBRAS DE REFUERZO (ARRIBA, MEDIO, ABAJO)
layer straight 3 3 $Asc [expr $cover-$z1] [expr $y1-$cover] [expr $z1-$cover] [expr $y1-$cover]
layer straight 3 2 $Asc [expr $cover-$z1] 0.0 [expr $z1-$cover] 0.0
layer straight 3 3 $Asc [expr $cover-$z1] [expr $cover-$y1] [expr $z1-$cover] [expr $cover-$y1]
}
#PARÁMETROS ADICIONALES PARA DEFINIR SECCIÓN FIBRA VIGA
set y2 [expr $HViga/2.0]
set z2 [expr $BViga/2.0]
# CREO SECCIÓN FIBRA PARA VIGA
section Fiber 2 {
# CREO LAS FIBRAS DE CONCRETO CONFINADO
patch rect 1 10 1 [expr $cover-$z2] [expr $cover-$y2] [expr $z2-$cover] [expr $y2-$cover]
# CREO LAS FIBRAS DE CONCRETO NO CONFINADO (DER, IZQU,
#ABAJO, ARRIBA)
patch rect 2 10 1 [expr $z2-$cover] [expr -$y2] $z2 $y2
patch rect 2 10 1 [expr -$z2] [expr -$y2] [expr $cover-$z2] $y2
patch rect 2 2 1 [expr $cover-$z2] [expr -$y2] [expr $z2-$cover] [expr $cover-$y2]
patch rect 2 2 1 [expr $cover-$z2] [expr $y2-$cover] [expr $z2-$cover] $y2
# CREO LAS FIBRAS DE REFUERZO(ARRIBA, ABAJO)
layer straight 3 2 $Asv [expr $cover-$z2] [expr $y2-$cover] [expr $z2-$cover] [expr $y2-$cover]
layer straight 3 2 $Asv [expr $cover-$z2] [expr $cover-$y2] [expr $z2-$cover] [expr $cover-$y2]
}
puts "SECCIONES FIBRA CREADAS"
# DEFINO ELEMENTOS
#===========================================================
# tag
geomTransf Linear 1
set np 5; # número de puntos de integración a lo largo del elemento
# CREO COLUMNAS Y VIGAS USANDO ELEMENTOS Beam-column
# tag ndI ndJ nsecs secID transfTag
element nonlinearBeamColumn 1 1 3 $np 1 1
element nonlinearBeamColumn 2 2 4 $np 1 1
element nonlinearBeamColumn 3 3 5 $np 1 1
element nonlinearBeamColumn 4 4 6 $np 1 1
# CREO VIGAS USANDO ELEMENTOS Beam-column
geomTransf Linear 2

element nonlinearBeamColumn 5 3 4 $np 2 2
element nonlinearBeamColumn 6 5 6 $np 2 2
puts "ELEMENTOS CREADOS"
# DEFINO RECORDERS (ARCHIVOS DE SALIDA)
#===========================================================
recorder Node -file $dataDir/Dlibres.out -time -node 4 6 -dof 1 2 3 disp; #
#DESPLAZAMIENTOS NUDOS LIBRES
recorder Node -file $dataDir/DBase.out -time -node 1 2 -dof 1 2 3 disp;
#
#DESPLAZAMIENTOS NUDOS SOPORTE
recorder Node -file $dataDir/RBase.out -time -node 1 2 -dof 1 2 3 reaction;
# REACCIONES EN SOPORTES
recorder Drift -file $dataDir/Deriv.out -time -iNode 2 4 -jNode 4 6 -dof 1 -perpDirn 2 ; # DERIVA LATERAL

recorder Element -file $dataDir/FCol.out -time -ele 1 2 globalForce;
# FUERZAS EN COLUMNAS
recorder Element -file $dataDir/FViga.out -time -ele 3 globalForce;
#
#FUERZAS EN VIGAS
# DEFINO GRAVEDAD
#===========================================================
pattern Plain 1 Linear {
eleLoad -ele 5 6 -type -beamUniform -$Wb ; # carga distribuida sobre vigas
}
constraints Plain; # forma en que se manejan las restricciones de nudo
numberer Plain;
# reenumera los dof para minimizar el ancho de banda
system BandGeneral; # como se resuelven las ecuaciones en el análisis
set Tol 1.0e-8;
# tolerancia para test de convergencia
test NormDispIncr $Tol 6 ; # determina si la convergencia ha sido alcanzada
algorithm Newton; # usa el algoritmo de newton para la solución
set NpGrav 10;
# aplico la gravedad en 10 pasos
set DGrav [expr 1./$NpGrav]; # incrementos para la aplicación de carga
integrator LoadControl $DGrav; # aplico 10% de carga gravitatoria por paso
analysis Static;
# defino el tipo de análisis (estático)
analyze $NpGrav; # Indico OpenSEES los pasos de análisis que debe realizar
loadConst -time 0.0; # Congela aplicación de cargas gravit y reinicia el tiempo
puts "ANALISIS GRAVITATORIO REALIZADO!"
# ANÁLISIS DINÁMICO (SISMO)
#===========================================================
# creamos patrón de carga
set accelSeries "Series -dt 0.02 -filePath centro.txt -factor 1"; # defino
#acelerograma
pattern UniformExcitation 2 1 -accel $accelSeries; # defino como y cuando
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
set maxNumIter 30; # máximo # de iteraciones que se realizarán
set printFlag 0; # prueba de convergencia
set TestType NormDispIncr;
# tipo de prueba de convergencia
test $TestType $Tol $maxNumIter $printFlag;
set algorithmType Newton;
algorithm $algorithmType;
# usa el algoritmo de newton para la solución
set NewmarkGamma 0.5;
# integrador gamma algoritmo newton
set NewmarkBeta 0.25;
# integrador beta algoritmo newton
integrator Newmark $NewmarkGamma $NewmarkBeta; #Integrador
analysis Transient;
# defino el tipo de análisis dependiente de tiempo
# COLOCO PARÁMETROS PARA ANÁLISIS DE ACCIÓN SÍSMICA
set DtAnalysis 0.01; #paso de tiempo para análisis dinámico (recomend 0.5*dt)
set TmaxAnalysis 30;
# duración de acción dinámica (seg)
set Nsteps [expr int($TmaxAnalysis/$DtAnalysis)]; #número de pasos
set ok [analyze $Nsteps $DtAnalysis]; # se realiza el análisis; retorna ok=0 si
el análsis fue exitoso
# ALGORTIMO USADO EN CASO DE ANÁLISIS FALLIDO (Dra. Mazzoni)
if {$ok != 0} { ;
# si el análisis no es exitoso.
# Se cambia algunos parámetros de análisis para alcanzar la
convergencia
# Proceso es más lento dentro de este lazo
# Análisis controlado por tiempo
set ok 0;
set controlTime [getTime];
while {$controlTime < $TmaxAnalysis && $ok == 0} {
set ok [analyze 1 $DtAnalysis]
set controlTime [getTime]
set ok [analyze 1 $DtAnalysis]
if {$ok != 0} {
puts "Trying Newton with Initial Tangent .."
test NormDispIncr $Tol 1000 0
algorithm Newton -initial
set ok [analyze 1 $DtAnalysis]
test $TestType $Tol $maxNumIter 0
algorithm $algorithmType
}
if {$ok != 0} {
puts "Trying Broyden .."
algorithm Broyden 8
set ok [analyze 1 $DtAnalysis]
algorithm $algorithmType
}
if {$ok != 0} {
puts "Trying NewtonWithLineSearch .."
algorithm NewtonLineSearch .8
set ok [analyze 1 $DtAnalysis]
algorithm $algorithmType
}
}
}; # Finaliza si ok !0
puts "ANALISIS DINAMICO REALIZADO: [getTime]"


