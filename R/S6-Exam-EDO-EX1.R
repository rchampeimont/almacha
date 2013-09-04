library("deSolve")
A <- array(c(-1,1,-3,-1), dim=c(2,2))
f <- function(t, x, parms) {
    list(A %*% x)
}
x0 <- c(1,1)
T <- seq(from=0, to=10, by=0.01)
r <- lsode(x0, T, f, parms = 0)
plot(r[,2],r[,3],type='l')
