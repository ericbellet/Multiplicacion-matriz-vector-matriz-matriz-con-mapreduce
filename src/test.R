#Ejemplificación del uso de los scripts previamente mencionados.
#Leemos los datasets con .csv ya que si lo leemos con file("", W) lo lee mal
#ya que no lee la primera fila, y esta funcion no tiene un parametro tipo header = F
direccion <- "C:/Users/Eric/Desktop/MapReduce/multiplicacion-matriz-vector-matriz-matriz-con-mapreduce-grupo-hej"
setwd(direccion)
source("src/memlimit.R")
source("src/productmv.R")
#source("src/productmvSINMEMORIA.R")
unlink(paste(direccion,"/tmp/archivotemporal.csv", sep = ""))
#***********************SIN MEMORIA MATRIZ*VECTOR 3X3*********************************
A <- read.csv("data/tblAkv3x3.csv", header = FALSE)
x <- read.csv("data/tblxkv3.csv", header = FALSE)
N <- nrow(x)

resultadomvSINMEMORIA <- productmvSINMEMORIA(A, x, N)
cat("El resultado de A*x 3x3 sin memoria es:", direccion )
resultadomvSINMEMORIA

#Borro el archivo temporal.
unlink(paste(direccion,"/tmp/archivotemporal.csv", sep = ""))

#***********************SIN MEMORIA MATRIZ*VECTOR 10X10*********************************
A <- read.csv("data/tblAkv10x10.csv", header = FALSE)
x <- read.csv("data/tblxkv10.csv", header = FALSE)
N <- nrow(x)

resultadomvSINMEMORIA <- productmvSINMEMORIA(A, x, N)
cat("El resultado de A*x 10x10 sin memoria es: " )
resultadomvSINMEMORIA

#Borro el archivo temporal.
unlink(paste(direccion,"/tmp/archivotemporal.csv", sep = ""))

#***********************CON MEMORIA MATRIZ*VECTOR  3X3*********************************
A <- read.csv("data/tblAkv3x3.csv", header = FALSE)
x <- read.csv("data/tblxkv3.csv", header = FALSE)
N <- nrow(x)

#Introduzca la memoria, recuerde que la memoria minima debe permitir hacer una operacion,
# es decir tomar por lo menos un valor de la matriz y un valor del vector, y poder guardar
# el resultado.
#************************************************************************
memoria <- 1760 + 1760 
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
cat("El resultado de A*x 3x3 con memoria es: " )
resultadomv

#Borro el archivo temporal.
unlink(paste(direccion,"/tmp/archivotemporal.csv", sep = ""))


#***********************CON MEMORIA MATRIZ*VECTOR  10X10*********************************
A <- read.csv("data/tblAkv10x10.csv", header = FALSE)
x <- read.csv("data/tblxkv10.csv", header = FALSE)
N <- nrow(x)

#Introduzca la memoria, recuerde que la memoria minima debe permitir hacer una operacion,
# es decir tomar por lo menos un valor de la matriz y un valor del vector, y poder guardar
# el resultado.
#************************************************************************
memoria <- 1888
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
cat("El resultado de A*x 10x10 con memoria es: " )
resultadomv
#Borro el archivo temporal.
unlink(paste(direccion,"/tmp/archivotemporal.csv", sep = ""))
