setwd("C:/Users/Eric/Desktop/MapReduce/multiplicacion-matriz-vector-matriz-matriz-con-mapreduce-grupo-hej")
#Multiplicación Matriz-Vector.

productmv <- function(A, x, N, memoria) {
  #Parámetros:
  
  #-matriz(string): ruta del archivo que contiene la matriz(cuadrada) a multiplicar,
  #por ejemplo: '. . . /tblAkv10x10.csv'. 
  
  #-vector(string): ruta del archivo que contiene el vector a multiplicar, 
  #por ejemplo: . . . /tblxkv10.csv'. 
  
  #-N(int): dimensión asociada a la multiplicación, por ejemplo: 10. 
  
  #-memorylimit(int): tamaño límite (en bytes) que puede ocupar en la sesión de r 
  #donde ejecutará su función, por ejemplo: 480. 
  
  #Retorna el resultado de la multiplicacion 
  
  #*********************************************************************************
  
  #*********************************************************************************
  indice <- 1
  j <- 1
  while (indice <= (nrow(A))){
    
    #Chunks faltantes = FALTAN TODOS.
    chunksF <- nrow(x)
    acum2 <- 0
    
    rest <- 0
    for (h in 1:N) {
      
      
      #Llamo a la funcion chunks que me dice cuantas operaciones puedo realizar.
      cont <- chunks(A, x, N, chunksF, indice)
      
      
      
      #chunksF son los que faltan.
      chunksF <- N - (cont + acum2)
      
      if (chunksF == 0){
        
        #Si no falta ningun chunk por procesar, entonces
        map(A, x, N, indice, j, cont)
        indice <- indice - rest
        
        break
      }else{
        map(A, x, N, indice, j, cont)
        indice <- indice + cont
        
        rest <- rest + cont
        acum2 <- cont + acum2
      }
      
    }#endfor
    #indice <- indice + 1
    indice <- indice + N  ##puede ser porque le suma n a la i?
   
    j <- j + 1
  }#end while que recorre todas las filas de la matriz.  
  
  #Liberamos memoria para hacer el reduce
  remove(A)
  remove(x)
  
  
  return(reduce(N))
  
  
}
#******************************************************

#*********************************************************************************
#Calculamos cuantas operaciones podemos hacer utilizando la memoria indicada.
#*********************************************************************************


chunks <- function(A, x, N, chunksF, indice){
  #********************************************************
  #Division de chunks utilizando la memoria.
  #********************************************************
  
  #tamres es el tamano necesario para guardar un resultado.
  tamres <- object.size(max(A[,ncol(A)]) * max(x[,2]))
  
  #tamvector es el size de un valor del vector.
  tamvector <- object.size(x[N,])
  #Acumula la cantidad de memoria que se puede utilizar
  acum <- 0
  #Cuenta cuantas operaciones se pueden hacer
  cont <- 0
  for (i in indice:((indice + chunksF)-1)) {
    
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
#                               MAP
#*********************************************************************************
map <- function(A, x, N, i, j, cont){
  #i<-7 #4= 5-1,8-2=6,11-3=8 ,
  for (k in i:((i+cont)-1)) {
    resultado <- A[k, ncol(A)] * x[j, ncol(x)]
    
    write.table(resultado, file = "tmp/archivotemporal.csv", row.names = FALSE, 
                col.names = FALSE, sep = ",", append = T)
    
  }
  
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
  remove(z)
  return(m)
  
}