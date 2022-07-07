PROLOGUE <- "```{R echo = FALSE, warnings = FALSE}\nsource(\"include.cpp.r\")\nincludeCppPath <- \"%s/\"\n```"

extract.rcpp.chunks <- function(filename, newfile, output.dir = "src/", overwrite = FALSE) {
  BEG <- "```{Rcpp"
  END <- "```"

  # extraction
  x <- scan(filename, character(), sep = "\n", blank.lines.skip = FALSE)
  w.BEG <- which(substring(x,1,8) == BEG)
  c.END <- which(substring(x,1,3) == END)
  CHUNKS <- list()

  keep <- rep(TRUE, length(x))
  for(i in w.BEG) {
    j <- min( c.END[ c.END > i ] )
    if(j == i+1) next # too short
    CHUNKS <- c( CHUNKS, list(x[i:j]) )
    keep[ (i+2):(j-1) ] <- FALSE
  }
 
  # sauvegarde
  cnames <- character(length(CHUNKS)) 
  k <- 0
  for(i in seq_along(CHUNKS)) {
    chunk <- CHUNKS[[i]]
    name <- get.chunk.name(chunk)
    cat("chunk name", name, "\n")
    if(name == "") {
      k <- k+1
      filename <- sprintf("noname%d.cpp", k)
    } else {
      filename <- paste0(name, ".cpp")
    }
    cnames[i] <- filename
    filename <- paste0(output.dir, "/", filename)
    save.chunk(chunk, filename, overwrite)
  }

  # fichier modifié
  if(!missing(newfile)) {
    if(file.exists(newfile))
      stop(newfile, "exists")

    for(k in seq_along(w.BEG)) {
      i <- w.BEG[k]
      x[i] <- '```{R echo = FALSE, results = "asis"}'
      x[i+1] <- sprintf("include.cpp('%s')", cnames[k])
    }
    x <- x[keep]
    x <- c(sprintf(PROLOGUE, output.dir), x)
    zz <- file(newfile, "w")
    cat( paste(x, collapse = "\n"), file = zz )
    close(zz)
  }
}

get.chunk.name <- function(chunk) {
  m <- regexec("^(\\w|:)+.*[[:blank:]+](\\w+)\\(", chunk)
  m <- regmatches(chunk, m)
  m <- m[ sapply(m, length) > 0 ]
  if(length(m) == 0)
    ""
  else
    m[[1]][3]
}

save.chunk <- function(chunk, filename, overwrite = FALSE) {
  if(file.exists(filename)) {
    warning(filename, "exists")
    if(!overwrite) return;
  }  
  zz <- file(filename, "w")
  chunk <- chunk[-1]
  chunk <- chunk[-length(chunk)]
  cat(paste(chunk, collapse = "\n"), "\n", file = zz)
  close(zz)
}
