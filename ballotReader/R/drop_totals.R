#' drop_totals
#'
#' Drops rows containing totals
#'
#' Takes a data.frame and filters it to return rows that do not contain the
#' word "total" without paying attention to case.
#'
#' @author Alyssa Savo
#'
#' @param df A data.frame
#'
#' @examples
#' essex_gov_17 <- read.csv("data/essex_gov_17.csv")
#' drop_totals(essex_gov_17)
#'
#' @export

drop_totals <- function(df) {
  `%>%` <- magrittr::`%>%`
  df <- df %>%
    dplyr::filter_all(dplyr::all_vars(!grepl('Total',., ignore.case = TRUE)))
  df
}
