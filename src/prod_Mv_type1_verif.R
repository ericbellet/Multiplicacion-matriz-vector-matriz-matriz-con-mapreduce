## Comando para establecer el directorio de trabajo
setwd("C:/Users/Eric/Desktop/MapReduce/multiplicacion-matriz-vector-matriz-matriz-con-mapreduce-grupo-hej")

## Inicializo las variables de entorno de hadoop
Sys.setenv("HADOOP_PREFIX"="/opt/hadoop")
Sys.setenv("HADOOP_CMD"="/opt/hadoop/bin/hadoop")
Sys.setenv("HADOOP_STREAMING"="/opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.4.0.jar")

## Librería de manejo de HDFS
library(rhdfs)
hdfs.init()

## Librería de MapReduce sobre Hadoop
library(rmr2) 
ignore <- rmr.options(backend="local") # Opciones "local" o "hadoop"

## Cargo la función de multiplicación de Matriz x Vector, Tipo 1
source("src/prod_Mv_type1.R")
source("src/productmv.R")

A <- read.csv("data/tblAkv3x3.csv", header = FALSE)
object.size(A[1,])
A <- to.dfs(A)

x <- read.csv("data/tblxkv3.csv", header = FALSE)

x = to.dfs(x)

y <- productmv(A,x)
y

memory.size(A)
## Prueba de la función

M <- matrix(1:9,ncol=3, byrow=TRUE)
M
v <- 1:3
v
w <- M %*% v
w
A <- read.csv("data/tblAkv3x3.csv", header = FALSE)
A
A <- to.dfs(A)
from.dfs(A)
x <- read.csv("data/tblxkv3.csv", header = FALSE)
x
x = to.dfs(x)
from.dfs(x)
y <- MultMV_1.mr(A,x)
y

M <- diag(10)
M
v <- 1:10
v
w <- M %*% v
w
A <- read.csv("data/tblAkv10x10ident.csv", header = FALSE)
A
A <- to.dfs(A)
from.dfs(A)
x <- read.csv("data/tblxkv10.csv", header = FALSE)
x
x = to.dfs(x)
from.dfs(x)
y <- MultMV_1.mr(A,x)
y

object.size(x[10,])

d <- 1:100
M <- matrix(1:100,ncol=10, byrow=TRUE)
M
v <- 1:10
v
w <- M %*% v
w
A <- read.csv("data/tblAkv10x10.csv", header = FALSE)
A
A <- to.dfs(A)
from.dfs(A)
y <- MultMV_1.mr(A,x)
y



