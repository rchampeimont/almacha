# Copyright (c) 2013 Raphael Champeimont

# Works only with DHCP failover system

rm(list=ls())

while (sink.number() > 0)
  sink()
while (length(dev.list()) > 0)
  dev.off()

Sys.setlocale("LC_ALL", "C")

source("auxfunctions.R")

cmdargs <- commandArgs(trailingOnly=TRUE)
infiles <- cmdargs

if (length(infiles) == 0) {
  #stop("Argument required: log files")
  cat("Arguments not specified (log files): trying to guess\n")
  infiles <- list.files(pattern="(syslog.*)|(messages.*)")
}

monthsNames <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")

now <- Sys.time()

logTimes <- NULL
frees <- c()
backups <- c()
totals <- c()
for (infile in infiles) {
  ntimes <- 0
  con <- file(infile, "r")
  lines <- readLines(con)
  close(con)
  for (line in lines) {
    if (grepl("dhcpd: balanced pool", line)) {
      parts <- strsplit(line, "\\s+")[[1]]
      monthNumber <- match(parts[[1]], monthsNames)
      day <- as.integer(parts[[2]])
      logTime <- strptime(parts[[3]], format="%H:%M:%S")
      logTime$mday <- day
      logTime$mon <- monthNumber - 1
      if (difftime(now, logTime) < -1) {
        # Log entry must be from last year.
        # Note that we allow log entry to be max 1 day in the future
        # to account for a little clock difference between
        # this machine and the logs.
        logTime$year <- logTime$year - 1
      }
      logTime <- as.POSIXct(logTime)
      if (is.null(logTimes)) {
        logTimes <- logTime
      } else {
        logTimes <- c(logTimes, logTime)
      }
      
      i <- which(parts == "free")
      free <- as.numeric(parts[[i+1]])
      frees <- c(frees, free)
      
      i <- which(parts == "backup")
      backup <- as.numeric(parts[[i+1]])
      backups <- c(backups, backup)
      
      i <- which(parts == "total")
      total <- as.numeric(parts[[i+1]])
      totals <- c(totals, total)
      
      ntimes <- ntimes + 1
    }
  }
  cat(ntimes, "entries found in", infile, "\n")
}
A <- data.frame(logTimes, frees, backups, totals)

cat("Time range is:", paste(range(logTimes), collapse=" to "), "\n")

pdf("logtimes.pdf")
plot(1:length(logTimes), logTimes, type="o")
dev.off()

# Sort by logTime
A <- A[order(A$logTimes), ]


makePlotOld <- function(A, main="DHCP pool over time", ...) {

  mycolors <- c("green","cyan","#ff5555")
  rlcCumPlot(t(data.frame(A$frees, A$backups, A$totals-A$frees-A$backups)),
             A$logTimes,
             col=mycolors,
             ylab="Number of IP addresses",
             xlab=NA,
             main=main, ...)
  
  legend(x=usrFromRelativeX(0), y=usrFromRelativeY(-0.1),
         fill=mycolors,
         legend=c("free (on master)", "free (on slave)", "used"),
         xpd=TRUE, box.col=NA, bg=NA, horiz=TRUE)
}

makePlot <- function(A, main="DHCP pool over time", ...) {
  
  mycolors <- c("black", "red","green","cyan")
  plot(A$logTimes,
       A$totals,
       col=mycolors[[1]],
       ylab="Number of IP addresses",
       xlab=NA,
       main=main,
       type="l",
       ylim=c(0, max(A$totals)),
       ...)
  lines(A$logTimes, A$frees+A$backups, type="l", col=mycolors[[2]])
  lines(A$logTimes, A$free, type="l", col=mycolors[[3]])
  lines(A$logTimes, A$backups, type="l", col=mycolors[[4]])

  
  legend(x=usrFromRelativeX(-0.1), y=usrFromRelativeY(-0.1),
         col=mycolors,
         lty=1,
         legend=c("total in pool", "free", "free (master)", "free (slave)"),
         xpd=TRUE, box.col=NA, bg=NA, horiz=TRUE)
}

pdf("free.pdf")

makePlot(A)

lastMonday <- as.POSIXlt(max(A$logTimes))
lastMonday$hour <- 0
lastMonday$min <- 0
lastMonday$sec <- 0
while (lastMonday$wday != 1) {
  lastMonday$mday <- lastMonday$mday - 1
  lastMonday <- as.POSIXlt(as.POSIXct(lastMonday))
}

a <- as.POSIXlt(lastMonday-3600*24*7)
b <- lastMonday
B <- A[A$logTimes >= a & A$logTimes <= b, ]
makePlot(B, main=paste("DHCP pool - last week only", a), xaxt="n")
ticks <- a + 3600*24*(0:6)
axis(1, ticks, labels=format(ticks, "%a"))

dev.off()

