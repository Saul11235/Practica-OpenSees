#este script genera una secuencia de datos aleatorios 

#importa funcion random de la lib random
from random import random


#crea un objeto tipo file llamado archivo 
archivo=open("DatosAleatorios.out","w")
#usa un bucle para escribir 200 numeros aleatorios
for x in range(200):
    archivo.write(str(random())+"\n")
#cierra el objeto archivo    
archivo.close()


print("Datos aleatorios creados")#
