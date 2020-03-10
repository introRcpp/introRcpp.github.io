rmarkdown::render("index.Rmd")

rmarkdown::render("index.Rmd", output_format = rmarkdown::html_document(toc = TRUE, toc_float = TRUE, toc_depth = 2, theme = "readable"))

