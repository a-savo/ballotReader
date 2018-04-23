#' read_vertical_headers
#'
#' Reads election results from .pdf files where column titles are formatted vertically.
#'
#' Vertically formatted text is often formatted incorrectly when converting
#' .pdf files to tabular data formats such as data.frames and tibbles. This
#' function includes additional parameters to help generate well-formatted
#' data.frames for a single race from .pdfs containing election results with
#' vertical column headers.
#'
#' @author Alyssa Savo
#'
#' @param file A URL or path to a .pdf file.
#' @param range An integer vector specifying the pages in the PDF for the race of interest. There currently is not a way to read multiple races at once.
#' @param colnames A character vector containing the names for each column.
#'
#' @export
#'

read_vertical_results <- function(file, range, colnames) {
  `%>%` <- magrittr::`%>%`
  pages <- tabulizer::extract_tables(file, pages = range)
  elex <- list()
  for (i in 1:length(pages)) {
    df <- as.data.frame(pages[[i]])
    names(df) <- colnames
    df <- df[-length(df)]
    elex[[i]] <- df
  }
  all_elex <- as.data.frame(do.call("rbind", elex), stringsAsFactors = FALSE)
  all_elex <- all_elex %>%
    tidyr::gather(key = "Vote Choice", value = "Votes", -1) %>%
    fill_na() %>%
    na.omit()
  all_elex
}
