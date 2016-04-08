#Multiplicación Matriz-Matriz.
#Parámetros:

#-matrizA(string): ruta del archivo que contiene la matriz(cuadrada) a multiplicar, 
#por ejemplo: '. . . /tblAkv10x10.csv'. 

#-matrizB(string): ruta del archivo que contiene la matriz(cuadrada) a multiplicar, 
#por ejemplo: '. . . /tblAkv10x10ident.csv'. 

#-N(int): dimension asociada a la multiplicación, por ejemplo: 10. 

#-límite de memoria(int): tamaño límite (en bytes) que puede ocupar en la sesión de r 
#donde ejecutará su función, por ejemplo: 480. 

library(rmr2) 
ignore <- rmr.options(backend="local") # Opciones "local" o "hadoop"

setwd("C:/Users/Eric/Desktop/MapReduce/multiplicacion-matriz-vector-matriz-matriz-con-mapreduce-grupo-hej")


# Multiplicacion Matriz por matriz usando mapreduce
# Tipo 1: el caso en que la matriz cabe dentro de la memoria RAM

productmm <- function(A, B) {
  
  d <- values(from.dfs(B))
  
  f <- function(x){
    
    return(x[3]*d[x[2],2])
    
  }
  
  map <- function(.,m) {
    
    i <- m[1]
    m <- as.matrix(m)
    valor <- apply(m,1,f)
    print(valor)
    valor <- as.data.frame(as.numeric(as.character(valor)))
    
    return( keyval(i, valor) )
  }
  
  reduce <- function(i, xi) { 
    print(xi)
    keyval(i, sum(xi))
  }
  
  calc <- mapreduce(input=M, 
                    #output=output, 
                    #input.format="text", 
                    map=map, 
                    reduce=reduce,
                    verbose = FALSE)
  C = values( from.dfs( calc ) ) 
  C
}

#-------------------------
A <- read.csv("data/tblAkv3x3.csv", header = FALSE)

A <- to.dfs(A)

B <- read.csv("data/tblAkv3x3.csv", header = FALSE)

B = to.dfs(B)

y <- productmm(A,B)

