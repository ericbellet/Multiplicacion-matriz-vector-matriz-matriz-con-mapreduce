
setwd("C:/Users/Eric/Desktop/MapReduce/multiplicacion-matriz-vector-matriz-matriz-con-mapreduce-grupo-hej")
#Multiplicación Matriz-Vector sin tomar en cuenta la memoria.

productmvSINMEMORIA <- function(A, x, N) {
  #Parámetros:
  
  #-matriz(string): ruta del archivo que contiene la matriz(cuadrada) a multiplicar,
  #por ejemplo: '. . . /tblAkv10x10.csv'. 
  
  #-vector(string): ruta del archivo que contiene el vector a multiplicar, 
  #por ejemplo: . . . /tblxkv10.csv'. 
  
  #-N(int): dimensión asociada a la multiplicación, por ejemplo: 10. 
  
  
  #Retorna el resultado de la multiplicacion 
  

j <- 1
for (i in 1:N) {
  valuesM <- as.vector(A[j:((j+N)-1),ncol(A)])
  valuesV <- as.vector(x[i,ncol(x)])
  resultado <- map(valuesM, valuesV)
  j <- (j + N) 
  write.table(resultado, file = "tmp/archivotemporal.csv", row.names = FALSE, 
              col.names = FALSE, sep = ",", append = T)
}

return(reduce(N))
 
  
}

#*********************************************************************************
#                               MAP
#*********************************************************************************
map <- function(A, x){
 return(A * x)

}

#*********************************************************************************
#                               REDUCE
#*********************************************************************************
reduce <- function(N){
  z <- read.csv("tmp/archivotemporal.csv", header = FALSE)
  m <- matrix(0,nrow = N)
  #Calculamos cuantos reducers se necesitan
  reducers <- 1:N
  
  for (i in 1:N) {
    k <- reducers[i]
    for (h in 1:N) {
      m[i] <- z[k,1] + m[i]
      k <- k + N
    }
  }
  
  return(m)
  
}