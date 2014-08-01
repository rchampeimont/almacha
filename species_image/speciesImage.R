# Author: Raphael Champeimont

# These functions allow you to automaticaly download a nice
# image for a species. When given a species name
# (like Homo sapiens), it will try do download it from
# Wikispecies. If it succeeds, the image is kept in a cache
# so that it need to look in Wikispecies if the same species
# is requested again. If it cannot find the species, it will
# also remember it to not try the same useless search on
# Wikispecies again (wasting time and bandwith).

# Version 1.2
# Tested on: R 2.14.1/Linux, R 3.0.0/Windows

.speciesImage.dir <- path.expand("~/species_images")

# The main function:
# Download an image for the species or get it from local cache.
# Returns the path to the image or NULL if it failed.
# Force: Force download even if in blacklist or in cache.
getSpeciesImage <- function(species, debug=FALSE, force=FALSE) {
  # We are pretty paranoid about input format
  # since we write all failed searches to a cache,
  # so we don't want to risk to put garbage in it.
  validInput <- TRUE
  # check NULL
  if (is.null(species)) validInput <- FALSE
  # check class
  if (validInput && !is.character(species)) validInput <- FALSE
  # check vector length
  if (validInput && length(species) != 1) validInput <- FALSE
  # check string length
  if (validInput && nchar(species) == 0) validInput <- FALSE
  if (validInput && nchar(species) > 100) validInput <- FALSE
  # stop if anything was invalid
  if (!validInput) {
    if (debug) {
      cat("Invalid input for getSpeciesImage.\n")
    }
    return(NULL)
  }
  
  speciesDir <- .speciesImage.dir
  if (!file.exists(speciesDir)) {
    dir.create(speciesDir)
  }
  
  blacklistFile <- paste(speciesDir, "/blacklist.txt", sep="")
  
  species <- gsub(" ", "_", species)
  # We allow letters, numbers, dot, minus and space/underscore
  species <- gsub("[^A-Za-z0-9\\.\\-\\_]", "", species)
  species <- paste(toupper(substring(species, 1, 1)), tolower(substring(species, 2)), sep="")
  
  # First, try to find the species in the cache.
  speciesRegex <- gsub(".", "\\.", species, fixed=TRUE)
  speciesMatch <- list.files(speciesDir, paste("^", speciesRegex, "\\.[a-zA-Z0-9]+$", sep=""), ignore.case=TRUE)
  if (length(speciesMatch) > 0 && !force) {
    if (debug) {
      cat("Found", speciesMatch[[1]], "\n")
    }
    return(paste(speciesDir, "/", speciesMatch[[1]], sep=""))
    
  } else {
    if (debug) {
      cat("Need to download", species, "\n")
    }
    
    if (!force && file.exists(blacklistFile)) {
      blacklist <- readLines(blacklistFile)
      if (species %in% blacklist) {
        if (debug) {
          cat("We already know species", species, "has no image\n")
        }
        return(NULL)
      }
    }
  
    tmpfile <- tempfile()
    download.file(paste("http://species.wikimedia.org/w/index.php?search=", species, sep=""),
                  destfile=tmpfile, quiet=TRUE, mode="wb")
    
    html <- paste(readLines(tmpfile, warn=FALSE), collapse="\n")
    file.remove(tmpfile)
    
    m <- regexpr("thumbinner", html)
    if (m != -1) {
      rest <- substring(html, m[[1]][[1]])
      l <- regexec("<img[^>]*>", rest)
      img <- substring(rest, l[[1]][[1]], l[[1]][[1]]+attr(l[[1]], "match.length")[[1]]-1)
      k <- regexec("src=\"([^\"]+)\"", img)
      src <- substring(img, k[[1]][2], k[[1]][2]+attr(k[[1]], "match.length")[[2]]-1)
      
      tmpfile2 <- tempfile()
      download.file(paste("http:", src, sep=""),
                    destfile=tmpfile2, quiet=TRUE, mode="wb")
      ext <- strsplit(src, ".", fixed=TRUE)[[1]]
      ext <- ext[[length(ext)]]
      
      finalFile <- paste(speciesDir, "/", species, ".", ext, sep="")
      file.copy(tmpfile2, finalFile, overwrite=TRUE)
      file.remove(tmpfile2)
      
      return(finalFile)
      
    } else {
      if (debug) {
        cat("Could not find species", species, "\n")
      }
      if (!force) {
        # If forced, we don't write to black as we might
        # write the same species twice.
        cat(species, "\n", sep="", file=blacklistFile, append=TRUE)
      }
      return(NULL)
    }
  }
}
#Examples:
#getSpeciesImage("callithrix Jacchus", debug=TRUE)
#getSpeciesImage("not a species", debug=TRUE)
#getSpeciesImage("DNA", debug=TRUE)


# Load the species image in a format usable by rasterImage()
# This is equivalent to calling getSpeciesImage then loadImage.
loadSpeciesImage <- function(species, debug=FALSE) {
  path <- getSpeciesImage(species, debug=debug)
  if (is.null(path)) {
    return(NULL)
  } else {
    return(loadImage(path, debug=debug))
  }
}


# Load an image in a format usable by rasterImage(),
# using the right library after autodetecting the format.
# This is purely generic and might be used for other things
# than species images.
# Supported format: JPEG, PNG, TIFF
loadImage <- function(path, debug=FALSE) {
  if (grepl(pattern="\\.jpe?g$", path, ignore.case=TRUE)) {
    if (!exists("readJPEG")) {
      if ("jpeg" %in% installed.packages()[,1]) {
        library(jpeg)
      } else {
        if (debug) {
          cat("Sorry, jpeg package not installed - cannot load jpeg image\n")
        }
        return(NULL)
      }
    }
    return(readJPEG(path, native=TRUE))
    
  } else if (grepl(pattern="\\.png$", path, ignore.case=TRUE)) {
    if (!exists("readPNG")) {
      if ("png" %in% installed.packages()[,1]) {
        library(png)
      } else {
        if (debug) {
          cat("Sorry, png package not installed - cannot load png image\n")
        }
        return(NULL)
      }
    }
    return(readPNG(path, native=TRUE))
    
  } else if (grepl(pattern="\\.tiff?$", path, ignore.case=TRUE)) {
    if (!exists("readTIFF")) {
      if ("tiff" %in% installed.packages()[,1]) {
        library(tiff)
      } else {
        if (debug) {
          cat("Sorry, tiff package not installed - cannot load tiff image\n")
        }
        return(NULL)
      }
    }
    return(readTIFF(path, native=TRUE))
  
  } else {
    if (debug) {
      cat("Sorry, the image format is not supported.\nFile: ", path, "\n", sep="")
    }
    return(NULL)
  }
}




# Add image to plot, so that the aspect ratio of the image is preserved.
# To do that, the function makes the assumption that the given area
# is visually a square.
addImageToPlot <- function(img, xleft=0, ybottom=0, xright=1, ytop=1) {
  w <- ncol(img)
  h <- nrow(img)
  if (w > h) { # horizontal
    nw <- xright-xleft
    nh <- h/w * (ytop-ybottom)
    nx <- xleft
    ny <- (ytop+ybottom)/2 - nh/2
  } else { # vertical
    nh <- ytop-ybottom
    nw <- w/h * (xright-xleft)
    ny <- ybottom
    nx <- (xright+xleft)/2 - nw/2
  }
  rasterImage(img, nx, ny, nx+nw, ny+nh, xpd=NA)
}


# Add species image to a plot in the given square area
addSpeciesToPlot <- function(species, xleft=0, ybottom=0, xright=1, ytop=1, debug=FALSE) {
  img <- loadSpeciesImage(species, debug=debug)
  if (!is.null(img)) {
    addImageToPlot(img, xleft, ybottom, xright, ytop)
  }
}


# Handy function to display a species image in a new plot
showSpecies <- function(species) {
  plot(NULL, xlim=c(0,1), ylim=c(0,1), type="n", asp=1, xlab=NA, ylab=NA, xaxt="n", yaxt="n", main=species)
  usr <- par("usr")
  addSpeciesToPlot(species, 0, 0, 1, 1, debug=TRUE)
}
# Examples:
#showSpecies("bos taurus")
#showSpecies("Oryctolagus cuniculus")
#showSpecies("Equus caballus")

