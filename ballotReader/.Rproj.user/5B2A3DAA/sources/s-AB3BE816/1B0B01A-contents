#' read_clarity_results
#'
#' Downloads election results using the Clarity Elections platform.
#'
#' Automatically downloads and unzips election reports from elections websites that
#' use Scytl's Clarity Elections platform. Users can either provide a link directly
#' to the .zip file or, for Web01 Clarity sites (noted in the website URL), link
#' to the home page and specify the desired report. This function can also generate
#' a list of tidy dataframes containing local election results based on Clarity
#' Elections detail reports.
#'
#' @author Alyssa Savo
#'
#' @param file The URL to a zipped report on a Clarity Elections website, or the
#' homepage of a Web01 Clarity site.
#' @param destfile A path and filename to save the .zip file to.
#' @param Web01  FALSE by default. Clarity Elections sites that use Web01 formatting, which include
#' Web01 in the URL, may not include direct links to .zip reports. In this case,
#' set `Web01` to TRUE and the function will attempt to construct a link to the report.
#' @param report Choose "csv" for a summary report or "xls", "xlm", or "txt" for
#' detailed local-level election results in those formats.
#' @param tidy_detail FALSE by default. Set to TRUE to generate a list of tidy dataframes
#' containing local-level election results using the detail.xls report available on
#' Clarity Elections websites. It's recommended to set the page range (see below),
#' as the tidying process can take a very long time for reports containing a large
#' number of election results.
#' @param page_range A numeric vector containing the range of worksheets to tidy from
#' the detail.xls file. This vector must only contain values greater than 3
#' (i.e. 3:n). You may want to run read_clarity_results once with tidy_detail = FALSE and
#' open detail.xls in another program in order to identify the worksheets of interest.
#'
#' @export
#'

read_clarity_results <- function(url, destfile, Web01 = FALSE, report = NULL, tidy_detail = FALSE, page_range = NULL) {
  if (Web01 == TRUE) {
    ID <- stringr::str_extract(url,"[A-Z][A-Z]/[A-Za-z]+/[0-9]+/[0-9]+")
    url <- paste("http://results.enr.clarityelections.com/",ID,
                 switch(report,
                        csv = "/reports/summary.zip",
                        xls = "/reports/detailxls.zip",
                        txt = "/reports/detailtxt.zip",
                        xml = "/reports/detailxml.zip"), sep = '')
  }

  download.file(url, destfile)
  unzip(destfile)

  `%>%` <- magrittr::`%>%`

  if (tidy_detail == TRUE) {
    message("This function can take a while, especially
            if you're importing the entire report.")
    message("Please be patient!")
    xls <- xml2::read_html("detail.xls")
    sheetnumber <- length(rvest::html_text(rvest::html_nodes(xls,
                                                      xpath = "//worksheet")))
    sheets <- list()
    if (is.null(page_range)) {
      range <- 3:sheetnumber
    } else {
      range <- page_range
    }
    for (i in range) {
      rows <- rvest::html_text(rvest::html_nodes(
        xls, xpath = paste("//worksheet[",i,"]/table/row", sep = '')))

      cols <- strsplit(rows[3], "(?<=[a-z]{2})(?=[A-Z])", perl = TRUE)[[1]]
      cols_votes <- cols[2:length(cols)]
      cols_count <- length(cols_votes)
      candidate_cols_count <- cols_count - 2

      everything <- rvest::html_text(rvest::html_nodes(
        xls, xpath = paste("//worksheet[",i,"]/table/row/cell", sep = '')))
      vote_num <- na.omit(stringr::str_match(everything, "^[0-9]+"))[,1]
      cell_count <- length(vote_num)
      row_count <- (cell_count/cols_count) + 1

      results <- matrix(data = c(cols_votes, vote_num),
                        nrow = row_count, ncol = cols_count,
                        byrow = TRUE)

      # Take out the column names and vote counts
      remaining <- setdiff(setdiff(everything, vote_num), cols_votes)
      county_id <- which(remaining %in% cols)
      counties <- remaining[county_id:length(remaining)]

      remaining <- setdiff(remaining, counties)
      title <- remaining[1]
      remaining <- remaining[-1] %>%
        fill_na() %>%
        na.omit() %>%
        as.character()
      candidates <- length(remaining)
      cols_per_candidate <- candidate_cols_count/candidates
      candidate_rows <- rep(remaining,
                            length.out = candidate_cols_count,
                            each = cols_per_candidate)

      df <- as.data.frame(t(results))
      names(df) <- counties
      df["Candidate"] <- ''
      df[2:(nrow(df)-1), "Candidate"] <- candidate_rows

      df <- df %>%
        dplyr::select(Candidate, dplyr::everything()) %>%
        dplyr::rename("Vote Type" = !!names(.[2])) %>%
        tidyr::gather(3:ncol(df), key = "Locality", value = "Votes") %>%
        dplyr::arrange(Candidate) %>%
        dplyr::mutate(Race = title) %>%
        dplyr::select(Race, dplyr::everything())

      sheets[[(i-2)]] <- df
    }
    sheets
  }
}
