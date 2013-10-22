# Copyright 2013 Raphael Champeimont

# This program shows with nice colors a random "representative" sample of a file.
# Typically this allows you to see what "kind of" bytes there are in the file.
# More precisely, it divides the file in 10000 equal parts and takes a random byte
# in each of those, then creates a nice PDF image where colors represents
# these bytes values (numbers between 0 and 255).
# If the file is smaller that 10000 bytes, then all bytes are read and shown.
# Note that this program ONLY reads these 10000 bytes, so it works quickly
# even on very big files because it does not need to read them entirely.
# For example it takes ~1min to sample a 1 TB file.

# Tested on Linux only (might work on other unix variants).

# Command-line arguments:
# 1. the file to analyze (will be open in read-only mode)
# 2. the PDF file to create (MUST end with .pdf)
# About argument 1:
# It can be a regular file but also a block device like /dev/sda.
# But the file must have "an end", so you cannot use /dev/zero
# or /dev/urandom for instance.
# About argument 2:
# Note: The requirement on extension being .pdf is a security
# in case you exchange the input and output, so that you don't end up
# deleting your input file. If you think I'm paranoid, think that I wrote
# this program to put /dev/sda as the input file...

rm(list=ls())

max.samples <- 10000

cmdArgs <- commandArgs(trailingOnly=TRUE)

lightcolors <- colorRampPalette(c("darkblue","blue","cyan","green","yellow","orange","red","darkred"))(1000)

drawColorScale <- function(x=NULL, y=NULL, w=NULL, h=NULL, colors=lightcolors, text=NULL) {
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




# Functions to display progress bars
progressBarInit <- function() {
  for (i in 1:10) {
    cat(" ")
  }
  for (i in 1:50) {
    cat("_")
  }
  cat("\n")
  for (i in 1:10) {
    cat(" ")
  }
  .progressBarLast <<- 0
}

# x is in [0,1]
progressBarNext <- function(x) {
  if (x > 1) x <- 1
  while (50*x >= .progressBarLast + 1) {
    cat("X")
    .progressBarLast <<- .progressBarLast + 1
  }
}

progressBarEnd <- function() {
  while (.progressBarLast < 50) {
    cat("X")
    .progressBarLast <<- .progressBarLast + 1
  }
  cat(" done.\n")
}


#set.seed(0)

if (length(cmdArgs) < 2) {
  cat("Argument required: file (block device, eg. /dev/sda) and output PDF file\n", file=stderr())
} else {
  fn <- cmdArgs[[1]]
  outfile <- cmdArgs[[2]]
  if (!grepl("\\.pdf$", outfile, ignore.case=TRUE)) {
    stop("Extension must be .pdf")
  }
  fh <- file(fn, open="rb", raw=TRUE)
  seek(fh, 0, origin="end")
  end <- seek(fh, NA)
  cat("Size =", end, "\n")
  breaks <- unique(round(seq(0, end, length.out=max.samples+1)))
  N <- length(breaks)-1
  indices <- floor(runif(N, min=breaks[1:N], max=breaks[2:(N+1)]))
  cat("Samples =", N, "\n")
  #print(indices)
  if (N > 0) {
    A <- rep(0, N)
    
    progressBarInit()
    
    for (i in 1:N) {
      seek(fh, indices[[i]])
      x <- as.integer(readBin(fh, what="raw", n=1, size=1))
      A[[i]] <- x
      progressBarNext(i/N)
    }
    close(fh)
    
    progressBarEnd()
    
    L <- ceiling(sqrt(N))
    M <- matrix(NA, nrow=L, ncol=L)
    M[1:N] <- A
    
    pdf(outfile)
    image(M[,ncol(M):1], col=lightcolors, zlim=c(0,255), main=fn, xaxt="n", yaxt="n")
    drawColorScale(x=-0.03, y=-0.15, text=c(0,128,255))
    invisible(dev.off())
  }
}
