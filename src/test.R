#Ejemplificación del uso de los scripts previamente mencionados.
#Leemos los datasets con .csv ya que si lo leemos con file("", W) lo lee mal
#ya que no lee la primera fila, y esta funcion no tiene un parametro tipo header = F

setwd("C:/Users/Eric/Desktop/MapReduce/multiplicacion-matriz-vector-matriz-matriz-con-mapreduce-grupo-hej")
source("src/memlimit.R")
source("src/productmv.R")

A <- read.csv("data/tblAkv3x3.csv", header = FALSE)
x <- read.csv("data/tblxkv3.csv", header = FALSE)
N <- nrow(x)


#Introduzca la memoria, recuerde que la memoria minima debe permitir hacer una operacion,
# es decir tomar por lo menos un valor de la matriz y un valor del vector, y poder guardar
# el resultado.
#************************************************************************
memoria <- 1760 + 1760 + 1760
#************************************************************************

if (memoria > memory.limit()){
  print("La maquina no posee tanta memoria, por lo tanto no se puede realizar las operaciones
        con esta cantidad de memoria.")
}

#Minmemoria <- Una valor matriz  + Un valor Vector    + El maximo resultado de una multiplicacion
minmemoria <- object.size(A[N,]) + object.size(x[N,]) + object.size(max(A[,ncol(A)]) * max(x[,2]))

memoria <- memlimit(memoria)
if (memoria < minmemoria){
  print("No hay suficiente memoria para realizar una operacion")
}

#Llamo a producmv
resultadomv <- productmv(A, x, N, memoria)

#Borro el archivo temporal.
unlink("C:/Users/Eric/Desktop/MapReduce/multiplicacion-matriz-vector-matriz-matriz-con-mapreduce-grupo-hej/tmp/archivotemporal.csv")
