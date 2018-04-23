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

read_twocol_summary <- function(url) {
  `%>%` <- magrittr::`%>%`
  elex <- list()

  #! There is currently a bug where extract_tables doesn't export the
  #! bottommost lines on most pages of PDFs with small margins. How to fix?
  pages <- tabulizer::extract_tables(url)
  for (i in 1:length(pages)) {
    # Drop whitespace columns that do not contain candidates or vote #s
    columns <- apply(pages[[i]],2, function(x) any(grepl('Total|%',x)))
    pages[[i]] <- pages[[i]][,columns]
    # This .pdf format has two columns containing tables of returns;
    # we stack the two columns on top of each other so we have one column
    # for candidates and one for votes
    elex[[i]] <- data.frame(Candidate = c(pages[[i]][,1],pages[[i]][,3]),
                         Votes = c(pages[[i]][,2],pages[[i]][,4]))
    # Convert empty rows to NAs and drop them
    elex[[i]] <- elex[[i]] %>%
      replace(. == '', NA) %>%
      na.omit() %>%
      # Split raw vote totals and percentages into two columns:
      tidyr::separate(Votes, c("Raw Total","Percent"), " ")
  }
  # Combine everything
  all_elex <- as.data.frame(do.call("rbind", elex), stringsAsFactors = FALSE)
  all_elex
}
