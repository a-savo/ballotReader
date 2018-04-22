# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

read_vertical_results <- function(url, range, colnames) {
  pages <- tabulizer::extract_tables(url, pages = range)
  elex <- list()
  for (i in 1:length(pages)) {
    df <- as.data.frame(pages[[i]])
    names(df) <- colnames
    df <- df[-length(df)]
    elex[[i]] <- df
  }
  all_elex <- as.data.frame(do.call("rbind", elex), stringsAsFactors = FALSE)
  all_elex
}
