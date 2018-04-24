#' read_clarity
#'
#' Downloads election results using the Clarity Elections platform.
#'
#' Automatically downloads and unzips election reports from elections websites that
#' use Scytl's Clarity Elections platform. Users can either provide a link directly
#' to the .zip file or, for Web01 Clarity sites (noted in the website URL), link
#' to the home page and specify the desired report.
#'
#' @author Alyssa Savo
#'
#' @param file The URL to a zipped report on a Clarity Elections website, or the
#' homepage of a Web01 Clarity site.
#' @param destfile A path and filename to save the .zip file to.
#' @param Web01 Clarity Elections sites that use Web01 formatting, which include
#' Web01 in the URL, may not include direct links to .zip reports. In this case,
#' set `Web01` to TRUE and the function will attempt to construct a link to the report.
#' @param report This should be NULL unless Web01 is TRUE. Choose "csv" for a summary
#' report or "xls", "xlm", or "txt" for detailed reports in those formats.
#'
#' @export
#'

read_clarity <- function(url, destfile, Web01 = FALSE, report = NULL, tidy_detail = FALSE) {

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

  if (tidy_detail == TRUE) {
    xls <- read.html("detail.xls")
    sheetnumber <- length(html_text(html_nodes(xls, xpath = "//worksheet")))

    for (i in 3:sheetnumber) {
      rows <- html_text(html_nodes(xls, xpath = paste("//worksheet[",i,"]/table/row", sep = ''))

      cols <- strsplit(rows[i], "(?<=[a-z]{2})(?=[A-Z])", perl = TRUE)[[1]]
      cols_votes <- cols[2:length(cols)]
      cols_count <- length(cols_votes)
      candidate_cols_count <- cols_count - 2

      everything <- html_text(html_nodes(xls, xpath = paste("//worksheet[",i,"]/table/row/cell", sep = '')))
      vote_num <- na.omit(str_match(everything, "^[0-9]+"))[,1]
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

      df <- as.data.frame(t(table))
      names(df) <- counties
      df["Candidate"] <- ''
      df[2:(nrow(df)-1), "Candidate"] <- candidate_rows
      df <- df %>%
        select(Candidate, everything()) %>%
        rename("Vote Type" = !!names(.[2])) %>%
        gather(3:ncol(df), key = "Locality", value = "Votes") %>%
        arrange(Candidate) %>%
        mutate(Race = title) %>%
        select(Race, everything())

    }
  }
}
