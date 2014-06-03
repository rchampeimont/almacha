# Copyright (c) 2013 Raphael Champeimont

rm(list=ls())

options(stringsAsFactors=FALSE)

translateTimes <- function(v) {
  as.numeric(as.POSIXct(v))/60 - as.numeric(refTime)/60
}

cmdargs <- commandArgs(trailingOnly=TRUE)
dhcpFile <- NULL

if (length(cmdargs) == 0) {
  dhcpFile <- "dhcpd.leases"
} else {
  dhcpFile <- cmdargs[[1]]
}

allLines <- readLines(dhcpFile)
allLines <- allLines[!grepl(pattern="^#", allLines)]

k <- 0
leases <- list()
allParamNames <- list(IP=1)
for (l in allLines) {
  if (grepl("^lease", l)) {
    k <- k + 1
    lease <- list()
    ip <- strsplit(sub(";", "", l), split=" ")[[1]][[2]]
    lease$IP <- ip
  } else if (grepl("^  ", l)) {
    parts <- strsplit(sub(";", "", l), split=" ")[[1]]
    parts <- parts[nchar(parts) > 0]
    val <- paste(parts[2:length(parts)], collapse=" ")
    lease[[parts[[1]]]] <- val
    allParamNames[[parts[[1]]]] <- 1
  } else if (grepl("}", l)) {
    leases[[k]] <- lease
  }
}

M <- c()
for (p in names(allParamNames)) {
  a <- lapply(leases, function(x) x[[p]])
  a <- sapply(a, function(x) if (is.null(x)) NA else x)
  M <- cbind(M, a)
}
M <- data.frame(M)
colnames(M) <- names(allParamNames)
IPsplit <- strsplit(M$IP, ".", fixed=TRUE)
M$numericIP <- unlist(lapply(IPsplit, function(x) as.integer(x[[1]])*2^24 + as.integer(x[[2]])*2^16 + as.integer(x[[3]])*2^8 + as.integer(x[[4]])))
M <- M[order(M$numericIP),]

# Parse data/times
M$starts <- as.POSIXlt(substring(M$starts, 2))
M$ends <- as.POSIXlt(substring(M$ends, 2))

print(M[,c("IP","starts","ends","binding")])


pdf("DHCP.pdf")

M$leaseClasses <- match(M$binding, c("state free","state active","state backup"))
M$leaseColors <- c("green","red","blue")[M$leaseClasses]
refTime <- as.POSIXct(max(M$ends))

xlim1 <- c(translateTimes(min(M$starts)), translateTimes(max(M$ends)))
xlim2 <- c(translateTimes(min(M$starts[M$leaseClasses == 2])), translateTimes(max(M$ends[M$leaseClasses == 2])))

for (xlim in list(xlim1, xlim2)) {
  plot(translateTimes(M$ends), M$numericIP, col=M$leaseColors, xlab="Lease expiry times (minutes)", ylab="IP address", xlim=xlim, pch=6, yaxt="n")
  abline(h=M$numericIP, col="grey")
  points(translateTimes(M$starts), M$numericIP, pch=2, col=M$leaseColors)
  segments(translateTimes(M$starts), M$numericIP, translateTimes(M$ends), col=M$leaseColors)
  abline(v=translateTimes(Sys.time()))
  keep <- !duplicated(M$numericIP)
  axis(2, at=M$numericIP[keep], labels=M$IP[keep], las=1, cex.axis=0.3)
}

invisible(dev.off())
