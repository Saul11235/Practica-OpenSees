#este script grafica los datos 
#de una serie de archivos


#leyendo un archivo e identificando sus numeros
Archivo=open("DatosAleatorios.out","r")
Lista=[] #ordenando los datos en una lista
for fila in Archivo:
    Lista.append(float(fila))

#creando grafico
import matplotlib.pyplot as plt
plt.title("graficando numeros aleatorios en datos de un archivo")
plt.plot(Lista)
plt.xlabel("leyenda en lado x")
plt.show()

print("grafico listo!")

