require(readr)
includeCppPath <- ""
include.cpp <- function(file, show.file = TRUE) {
  BEG <- "```{Rcpp eval = FALSE}\n"
  END <- "```\n"
  code <- readr::read_file( paste0(includeCppPath, file) )
  chunk <- if(show.file)
    paste0(BEG, "// file: ", file, "\n", code, END)
  else
    paste0(BEG, code, END)
  nit <- knitr::knit_child(text = chunk, quiet = TRUE)
  cat(nit, sep = '\n')
}

