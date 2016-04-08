#Ejemplificación del uso de los scripts previamente mencionados.
#Leemos los datasets con .csv ya que si lo leemos con file("", W) lo lee mal
#ya que no lee la primera fila, y esta funcion no tiene un parametro tipo header = F

setwd("C:/Users/Eric/Desktop/MapReduce/multiplicacion-matriz-vector-matriz-matriz-con-mapreduce-grupo-hej")
source("src/memlimit.R")

A <- read.csv("data/tblAkv3x3.csv", header = FALSE)
x <- read.csv("data/tblxkv3.csv", header = FALSE)
N <- nrow(x)


#Introduzca la memoria, recuerde que la memoria minima debe permitir hacer una operacion,
# es decir tomar por lo menos un valor de la matriz y un valor del vector, y poder guardar
# el resultado.
#************************************************************************
memoria <- 1760 
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


#********************************************************
#Division de chunks utilizando la memoria.
#********************************************************

#tamres es el tamano necesario para guardar un resultado.
tamres <- object.size(max(A[,ncol(A)]) * max(x[,2]))

#tamvector es el size de un valor del vector.
tamvector <- object.size(x[N,])

#*********************************************************************************
#Calculamos cuantas operaciones podemos hacer utilizando la memoria indicada.
#*********************************************************************************


chunks <- function(A, x, N, chunksF){
  #Acumula la cantidad de memoria que se puede utilizar
  acum <- 0
  #Cuenta cuantas operaciones se pueden hacer
  cont <- 0
  for (i in ((N-chunksF)+1):N) {
    
    acum <- object.size(A[i,]) + tamres + tamvector + acum
    
    if (acum > memoria){
      
      break
    }
    #Cuento cuantos valores de la matriz puedo utilizar.
    cont <- cont + 1
    
  }
  return(cont)
}
#*********************************************************************************
  
#*********************************************************************************
chunksF <- nrow(x)
cont <- chunks(A, x, N, chunksF)

cont <- chunks(A, x, N, chunksF)
  #chunksF son los que faltan.
  chunksF <- N - cont
  for (k in 1:cont) {
    resultado <- A[k, ncol(A)] * x[k, ncol(x)]
    write.table(resultado, file = "data/archivotemporal.csv", row.names = FALSE, 
                col.names = FALSE, sep = ",", append = T)
   
  }
  if (chunksF == 0){
    #Se pasa a la otra columna y a la otra posicion del vector.
    
  }else{
    #Hacer las operaciones en los chunks que faltan.
  }
  
  z <- read.csv("data/archivotemporal.csv", header = FALSE)
  remove(z)
  #Libera espacio en memoria.
  remove(w)
}#end first for

#Podemos utilizar cont valores para el MAP
productmv(A, x, N, memoria)