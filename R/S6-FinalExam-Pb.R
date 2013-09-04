# Script dans le domaine public.
# Pour utiliser ce script :
# Lancer R
# Faire : source("S6-FinalExam-Pb.R")

library(deSolve)

F <- function(t, Y, parms) {
	x <- Y[1]
	y <- Y[2]
	return(list(c(x*(1-y), x^2 - y)))
}

T <- seq(0,10,by=0.01)
Y0 <- c(2,10)
Y1 <- c(3,-1)

plot(seq(-10,10), seq(-10,10), type="n")

points(0,0)
points(-1,1)
points(1,1)

lines(c(-10,10), c(0,0)) # y = 0
lines(c(-10,10), c(1,1)) # y = 1
lines(c(0,0), c(-10,10)) # x = 0
X <- seq(-10,10,by=0.1)
lines(X, X^2) # y = x^2

colors <- rainbow(100)

while (1) {
	print("Cliquez avec le bouton droit pour tracer, gauche pour arrêter.")
	Yi <- locator(c(n=1))
	if (length(Yi) == 0) {
		break;
	}
	for (i in seq(1,length(Yi))) {
		x0 <- Yi$x[i]
		y0 <- Yi$y[i]
		R <- ode(c(x0, y0), T, F, NULL)
		color <- colors[1+runif(1)*100]
		#points(R[,2], R[,3], type="p", cex=0.25, col=rainbow(length(T)))
		lines(R[,2], R[,3], col=color)
	}
}
