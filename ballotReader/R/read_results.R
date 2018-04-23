#' read_results
#'
#' Imports and tidies election results from simply-formatted .pdf files.
#'
#' This function should help read and tidy election results from simple and well-
#' formatted .pdf files, where localities (county, city, voting district, etc.)
#' are listed in the first column and candidate vote totals are listed in all
#' subsequent columns.
#'
#' @author Alyssa Savo
#'
#' @param file A URL or path to a .pdf file.
#'
#' @export
#'

read_results <- function(file) {
  `%>%` <- magrittr::`%>%`
  pages <- tabulizer::extract_tables(file)
  all_elex <- as.data.frame(do.call("rbind", test), stringsAsFactors = FALSE)
  names <- as.vector(all_elex[1,])
  all_elex <- all_elex %>%
    unique() %>%
    fill_na() %>%
    mutate(Header = ifelse(!is.na(V1) & is.na(V2),V1,NA)) %>%
    fill(Header)
  all_elex
}
