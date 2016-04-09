setwd("C:/Users/Eric/Desktop/MapReduce/multiplicacion-matriz-vector-matriz-matriz-con-mapreduce-grupo-hej")

productmm <- function(A, B, N, memoria) {
#Multiplicación Matriz-Matriz.
#Parámetros:

#-matrizA(string): ruta del archivo que contiene la matriz(cuadrada) a multiplicar, 
#por ejemplo: '. . . /tblAkv10x10.csv'. 

#-matrizB(string): ruta del archivo que contiene la matriz(cuadrada) a multiplicar, 
#por ejemplo: '. . . /tblAkv10x10ident.csv'. 

#-N(int): dimension asociada a la multiplicación, por ejemplo: 10. 

#-límite de memoria(int): tamaño límite (en bytes) que puede ocupar en la sesión de r 
#donde ejecutará su función, por ejemplo: 480. 


  chunksF <- N
  cont <- chunks(A, B, N, chunksF, 1)
  chunksF <- N - cont
  

      indice <- 1
      for (p in 1:N) {
      
          i <- indice
          indice2 <- 1
          for (k in 1:N) {
            i <- indice
            for (h in indice2:((indice2 +N)-1)) {
              
              if (cont == N){
                chunk <-  list(A[i,ncol(A)], B[h,ncol(B)])
                map(chunk)
                
                i <- i + N
              }else{
                chunk <-  list(A[i,ncol(A)], B[h,ncol(B)])
                map(chunk)
                
                i <- i + N
                remove(chunk)
                cont <- cont + 1
              }
            } 
            indice2 <- indice2 + N
          } 
          indice <- indice + 1
           
      }
      remove(A)
      remove(B)
 
return(reduce(N))


}

#*********************************************************************************
#Calculamos cuantas operaciones podemos hacer utilizando la memoria indicada.
#*********************************************************************************
chunks <- function(A, B, N, chunksF, indice){
  #********************************************************
  #Division de chunks utilizando la memoria.
  #********************************************************
  
  #tamres es el tamano necesario para guardar un resultado.
  tamres <- (object.size(max(A[,ncol(A)]) * max(B[,ncol(B)])))*N
  
  #tamcol es el size de la matriz
  tamcol <- object.size(B)
  
  
  
  #Acumula la cantidad de memoria que se puede utilizar
  acum <- 0
  #Cuenta cuantas operaciones se pueden hacer
  cont <- 0
  for (i in indice:((indice + chunksF)-1)) {
    
    acum <- object.size(A[i,])*N  + tamres  + tamcol + acum
    
    if (acum > memoria){
      
      break
    }
    #Cuento cuantos valores  puedo utilizar.
    cont <- cont + 1
    
  }
  return(cont)
}

#*********************************************************************************
#                               MAP
#*********************************************************************************
map <- function(chunk){
  resultado <- unlist(chunk[1]) * unlist(chunk[2])
  write.table(resultado, file = "tmp/archivotemporal.csv", row.names = FALSE, 
              col.names = FALSE, sep = ",", append = T)
  
}
  
    
#*********************************************************************************
#                               REDUCE
#*********************************************************************************
reduce <- function(N){
  z <- read.csv("tmp/archivotemporal.csv", header = FALSE)
  m <- matrix(0,nrow = N, ncol = N)
  #Calculamos cuantos reducers se necesitan
  reducers <- 1:N
  k <- 1
  j <- 1
  for (i in 1:N) {
    for (g in 1:N) {
    if (j == (N+1)){
      j <- 1
    }
    
    for (h in 1:N) {
      m[i, j] <- z[k,1] +  m[i, j]
      k <- k + 1
      
    }
    j <- j + 1
    }
  }
  remove(z)
  return(m)
  
}
  
  
