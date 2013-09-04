# Public domain script.

X <- seq(-10,10,by=0.1)
Y <- X
Z <- outer(X, Y, function(x,y) abs(log(x+(0+1i)*y)))
image(X, Y, Z, col=rainbow(1000))
