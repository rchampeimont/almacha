# Copyright (c) 2014 Raphael Champeimont
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.
# ------------------------------------------------------------------------


# Script to analyze dhcpd.leases file


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
# Parse IP addresses
IPsplit <- strsplit(M$IP, ".", fixed=TRUE)
M$numericIP <- unlist(lapply(IPsplit, function(x) as.integer(x[[1]])*2^24 + as.integer(x[[2]])*2^16 + as.integer(x[[3]])*2^8 + as.integer(x[[4]])))
# Parse date/times
M$starts <- as.POSIXlt(substring(M$starts, 2))
M$ends <- as.POSIXlt(substring(M$ends, 2))

# Order by IP address
M <- M[order(M$numericIP, -as.numeric(as.POSIXct(M$ends))),]
# Remove duplicated (keep most recent lease)
M <- M[!duplicated(M$numericIP), ]



print(M[,c("IP","starts","ends","binding")])


pdf("DHCP.pdf")

mycolors <- c("green","red","blue","purple","black")
M$leaseClasses <- match(M$binding, c("state free","state active","state backup","state abandoned"), nomatch=5)
M$leaseColors <- mycolors[M$leaseClasses]
refTime <- as.POSIXct(max(M$ends))

tab <- tabulate(M$leaseClasses, nbins=4)
barplot(tab, names.arg=paste(c("free","active","backup","abandoned"), "\n", tab, sep=""), col=mycolors, main=paste("DHCP leases states (total = ", nrow(M), ")", sep=""))

xlim1 <- c(translateTimes(min(M$starts)), translateTimes(max(M$ends)))
xlim2 <- c(translateTimes(min(M$starts[M$leaseClasses == 2])), translateTimes(max(M$ends[M$leaseClasses == 2])))

for (xlim in list(xlim1, xlim2)) {
  plot(translateTimes(M$ends), M$numericIP, col=M$leaseColors, xlab="Lease expiry times (minutes)", ylab="IP address", xlim=xlim, pch=6, yaxt="n", main="DHCP leases")
  abline(h=M$numericIP, col="grey")
  points(translateTimes(M$starts), M$numericIP, pch=2, col=M$leaseColors)
  segments(translateTimes(M$starts), M$numericIP, translateTimes(M$ends), col=M$leaseColors)
  abline(v=translateTimes(Sys.time()))
  axis(2, at=M$numericIP, labels=M$IP, las=1, cex.axis=0.3)
}



invisible(dev.off())
