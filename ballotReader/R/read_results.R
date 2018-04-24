#' read_results
#'
#' Imports and tidies election results from simply-formatted .pdf files.
#'
#' This function should help read and tidy election results from simple and well-
#' formatted .pdf table, where localities (county, city, voting district, etc.)
#' are listed in the first column, candidate vote totals are listed in all
#' subsequent columns, and vertical text is not used for column names or other parts
#' of the table. See read_vertical_results for well-formatted results where column
#' names are formatted vertically.
#'
#' @author Alyssa Savo
#'
#' @param file A URL or path to a .pdf file.
#' @param merged_header FALSE by default. If the table has merged headers
#' grouping the candidates (by race, etc.) in the first row, setting this to TRUE
#' will drop that row.
#'
#' @export
#'

read_results <- function(file, merged_header = FALSE) {
  `%>%` <- magrittr::`%>%`
  pages <- tabulizer::extract_tables(file)
  if (merged_header == TRUE) {
    for (i in 1:length(pages)) {
      pages[[i]] <- pages[[i]][-1,]
    }
  }
  all_elex <- as.data.frame(do.call("rbind", pages), stringsAsFactors = FALSE)
  names <- as.vector(all_elex[1,])
  names(all_elex) <- names
  all_elex <- all_elex %>%
    fill_na() %>%
    unique() %>%
    dplyr::rename(Municipality = !!names(.[1])) %>%
    dplyr::mutate(count_na = ncol(all_elex)-apply(., 1, function(x) sum(is.na(x)))) %>%
    dplyr::mutate(Subgroup = ifelse(count_na == 1, Municipality,NA))
  if (sum(!is.na(all_elex$count_na)) > 0) {
    all_elex <- all_elex %>%
      tidyr::fill(Subgroup) %>%
      dplyr::select(Subgroup, dplyr::everything(), -count_na) %>%
      dplyr::filter(!(Subgroup == Municipality)) %>%
      tidyr::gather(-Subgroup, -Municipality, key = "Candidate", value = "Votes")
  } else {
    all_elex <- all_elex %>%
      dplyr::select(dplyr::everything(), -count_na, -Subgroup) %>%
      tidyr::gather(-Municipality, key = "Candidate", value = "Votes")
  }
  all_elex
}
