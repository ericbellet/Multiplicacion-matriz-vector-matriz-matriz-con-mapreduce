#Deteccion de la memoria límite
#Parámetros:

#-size(int): si es igual a -1 detecte y retorne la memoria límite de la máquina, 
#para cualquier otro valor simplemente lo retorne, 
#por ejemplo: memlimit(80) retorna 80. 

memlimit <- function(x){
  if (x == -1){
    return(memory.limit())
  }else{
    return(x)
  }
  
}

#reports or increases the limit in force on the total allocation.
#memory.limit()


#reports the current or maximum memory allocation of the malloc function used in this version of R.
#memory.size()


#Calculo la cantidad de memoria minima para hacer una operacion: