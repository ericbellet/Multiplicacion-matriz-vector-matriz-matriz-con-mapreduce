library(parallel)

#Multiplicación Matriz-Matriz.
#Parámetros:

#-matrizA(string): ruta del archivo que contiene la matriz(cuadrada) a multiplicar, 
#por ejemplo: '. . . /tblAkv10x10.csv'. 

#-matrizB(string): ruta del archivo que contiene la matriz(cuadrada) a multiplicar, 
#por ejemplo: '. . . /tblAkv10x10ident.csv'. 

#-N(int): dimension asociada a la multiplicación, por ejemplo: 10. 

#-límite de memoria(int): tamaño límite (en bytes) que puede ocupar en la sesión de r 
#donde ejecutará su función, por ejemplo: 480. 


chunks <- function(n) { 
  
  return(n^2) 

}



setwd("C:/Users/Eric/Desktop/MapReduce/multiplicacion-matriz-vector-matriz-matriz-con-mapreduce-grupo-hej")

A <- read.csv("data/tblAkv3x3.csv", header = FALSE)
B <- read.csv("data/tblAkv3x3.csv", header = FALSE)
N <- nrow(A) #O 3

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

#Minmemoria <- Una valor matriz  + Un valor matriz    + El maximo resultado de una multiplicacion
minmemoria <- object.size(A[N,]) + object.size(B[N,]) + object.size(max(A[,ncol(A)]) * max(B[,ncol(B)]))

memoria <- memlimit(memoria)
if (memoria < minmemoria){
  print("No hay suficiente memoria para realizar una operacion")
}


#Calculemos cuantos chunks por columna de la primera matriz podemos tener.
chunks <- function(n) { 
  
  return(n^2) 
  
}

totalchunks <- function(memoria, A, B) { 
  # Tenemos que tener memoria reservada para el resultado y un valor de ambas matrices.
  total <-  object.size(A[N,]) + object.size(B[N,]) + object.size(max(A[,ncol(A)]) * max(B[,ncol(B)]))
  
  #Minimo 1 chunk debe tener un valor.
  chunksT <- 1
  # Calculamos cuantos valores podemos tener en un chunk.
  while (total < memoria){
    #Calculamos si el chunk puede tener otro valor.
    total <- total + object.size(A[N,])
    if (total > memoria){
      #El chunk no puede tener mas valores
      break
    }
    
  }
  
  return(n^2) 
  
}

values <- 1:10

## Number of workers (R processes) to use:
numWorkers <-detectCores(all.tests = FALSE, logical = TRUE)
## Set up the 'cluster'
cl <- makeCluster(numWorkers, type = "PSOCK")
## Parallel calculation (parLapply):
res <- parLapply(cl, values, chunks)
## Shut down cluster
stopCluster(cl)
print(unlist(res))
