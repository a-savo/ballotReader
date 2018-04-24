#' get_totals
#'
#' Retrieves rows containing totals
#'
#' Takes a data.frame and filters it to return only the rows that contain the
#' word "total" without paying attention to case.
#'
#' @author Alyssa Savo
#'
#' @param df A data.frame
#'
#' @export

get_totals <- function(df) {
  `%>%` <- magrittr::`%>%`
  df <- df %>%
    filter_all(any_vars(grepl('Total',., ignore.case = TRUE)))
  df
}
