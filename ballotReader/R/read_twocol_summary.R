#' read_twocol_summary
#'
#' Imports and tidies election results data from two-column summary reports.
#'
#' Downloads and tidies .pdf files containing election results in a standardized
#' two-column summary format - for an example, see http://www.passaiccountynj.org/ArchiveCenter/ViewFile/Item/972.
#' Be warned that this function is pretty unreliable! Further bugtesting to come.
#'
#' @author Alyssa Savo
#'
#' @param file A file or URL linking containing a .pdf file containing election results
#' in a standard two-column summary format.
#'
#' @export
#'

read_twocol_summary <- function(file) {
  `%>%` <- magrittr::`%>%`
  elex <- list()

  #! There is currently a bug where extract_tables doesn't export the
  #! bottommost lines on most pages of PDFs with small margins. How to fix?
  pages <- tabulizer::extract_tables(file)
  for (i in 1:length(pages)) {
    # Drop whitespace columns that do not contain candidates or vote #s
    columns <- apply(pages[[i]],2, function(x) any(grepl('Total|%',x)))
    pages[[i]] <- pages[[i]][,columns]
    # This .pdf format has two columns containing tables of returns;
    # we stack the two columns on top of each other so we have one column
    # for candidates and one for votes

    # Need to fix this for pages with odd column #
    if (ncol(pages[[i]]) == 4) {
      elex[[i]] <- data.frame(Candidate = c(pages[[i]][,1],pages[[i]][,3]),
                         Votes = c(pages[[i]][,2],pages[[i]][,4]))
    }

    # Convert empty rows to NAs and drop them
    elex[[i]] <- elex[[i]] %>%
      fill_na() %>%
      na.omit() %>%
      # Split raw vote totals and percentages into two columns:
      tidyr::separate(Votes, c("Raw Total","Percent"), " ")
  }
  # Combine everything
  all_elex <- as.data.frame(do.call("rbind", elex), stringsAsFactors = FALSE)
  all_elex <- all_elex %>%
    dplyr::filter(!grepl('TOTAL', Candidate, ignore.case = TRUE)) %>%
    dplyr::mutate(Race = ifelse(Percent == "100.00%", as.character(Candidate), NA)) %>%
    tidyr::fill(Race) %>%
    dplyr::select(Race, everything()) %>%
    dplyr::filter(!(Race == Candidate & !is.na(Race))) %>%
    replace(. == "Voters", "100.00%")
  all_elex
}
