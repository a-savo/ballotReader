#' fill_na
#'
#' Replaces empty cells with NAs
#'
#' Takes a dataframe and replaces empty cells with NA.
#'
#' @author Alyssa Savo
#'
#' @param df A data frame
#'


fill_na <- function(df) {
  `%>%` <- magrittr::`%>%`
  df <- df %>%
    replace(. == "", NA)
  df
}

