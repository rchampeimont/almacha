# Public domain script.
# Is sin(x - π/2) = cos(x) forall complex x?
f <- function(x) cos(x) - sin(pi/2-x)
X <- seq(-10,10,by=0.05)
Y <- X
Z <- outer(X, Y, function(x,y) abs(f(x+(0+1i)*y)))
image(X, Y, Z, col=rainbow(1000))
title(max(Z))
