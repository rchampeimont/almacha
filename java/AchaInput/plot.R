M <- read.table("log.txt")
plot(M[,1], M[,2], type="s", col="green")
points(M[,1], M[,3], type="s", col="yellow")
points(M[,1], M[,4], type="s", col="red")
