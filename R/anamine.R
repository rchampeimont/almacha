rm(list=ls())
invisible(gc(verbose=FALSE))

nice.colors <- rainbow(1000, end=0.7)

mapColors <- function(values, colors=nice.colors, a=min(values, na.rm=TRUE), b=max(values, na.rm=TRUE)) {
  if (a == b) {
    res <- rep(colors[1], length(values))
  } else {
    res <- rep("", length(values))
    for (i in seq(along=values)) {
      if (is.na(values[i])) {
        res[i] <- NA
      } else {
        colorIndex <- round((values[i]-a)/(b-a) * length(colors))
        if (colorIndex < 0) {
          res[i] <- colors[1]
        } else if (colorIndex >= length(colors)) {
          res[i] <- colors[length(colors)]
        } else {
          res[i] <- colors[colorIndex+1]
        }
      }
    }
    return(res)
  }
}



showColorScale <- function(x=NULL, y=NULL, w=NULL, h=NULL, colors=nice.colors, text=NULL) {
  usr <- par("usr")
  UW <- usr[2] - usr[1]
  UH <- usr[4] - usr[3]
  if (is.null(x))
    x <- par("usr")[1]
  if (is.null(y))
    y <- usr[3]-UH/7
  if (is.null(w))
    w <- UW/3
  if (is.null(h))
    h <- UH/20
  mycolors <- colors[seq(1,length(colors),length.out=100)]
  dx <- w/length(mycolors)
  for (i in seq(along=mycolors)) {
    x1 <- x + (i-1)*dx
    rect(x1, y, x1+dx, y+h, col=mycolors[[i]], border=NA, xpd=TRUE)
  }
  if (!is.null(text)) {
    for (i in seq(along=text)) {
      x1 <- x+w/(length(text)-1)*(i-1)
      lines(c(x1,x1), c(y, y+h/2), xpd=TRUE)
      text(x1, y-h/2, text[[i]], xpd=TRUE, cex=0.7)
    }
  }
}


while (sink.number() > 0)
  sink()
while (length(dev.list()) > 0)
  dev.off()

cat("Running...\n")

files <- list.files(pattern="\\.mca$")

parseName <- function(s) {
  parts <- strsplit(s, ".", fixed=TRUE)
  return(as.integer(c(parts[[1]][[2]], parts[[1]][[3]])))
}

x <- c()
z <- c()
mtimes <- c()
for (fn in files) {
  res <- parseName(fn)
  x <- c(x, res[1])
  z <- c(z, res[2])
  mt <- as.numeric(file.info(fn)$mtime)
  mtimes <- c(mtimes, mt)
}
xrange <- range(x)
zrange <- range(z)

#png("Rplot.png", width=1200, height=1000)
#pdf("Rplots.pdf")
pdf(commandArgs(trailingOnly=TRUE)[[1]])

plot(0, 0, xlim=c(xrange[1],xrange[2]+1)*512, ylim=c(zrange[2]+1,zrange[1])*512, type="n", xlab="x", ylab="z", main="jours depuis dernier accès", asp=1)


daysOld <- (max(mtimes)-mtimes) / (3600*24)

fileColors <- mapColors(daysOld, a=0, b=30)
showColorScale(text=c(0,10,20,"30 ou +"))
names(fileColors) <- files

for (fn in files) {
  res <- parseName(fn)
  fi <- file.info(fn)
  rect(res[1]*512, res[2]*512, (res[1]+1)*512, (res[2]+1)*512, col=fileColors[[fn]])
}

dev.off()



cat("Done.\n")
