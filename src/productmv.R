source("src/memlimit.R")
#Multiplicación Matriz-Vector.

productmv <- function(matriz, vector, N, x) {
#Parámetros:
  
  #-matriz(string): ruta del archivo que contiene la matriz(cuadrada) a multiplicar,
  #por ejemplo: '. . . /tblAkv10x10.csv'. 
    
  #-vector(string): ruta del archivo que contiene el vector a multiplicar, 
  #por ejemplo: . . . /tblxkv10.csv'. 
    
  #-N(int): dimensión asociada a la multiplicación, por ejemplo: 10. 
    
  #-memorylimit(int): tamaño límite (en bytes) que puede ocupar en la sesión de r 
  #donde ejecutará su función, por ejemplo: 480. 
  
#Retorna el resultado de la multiplicacion 
  x <- memory.limit(x)
   return(x)

}
#******************************************************
w<-productmv(1,2,3,-1)

