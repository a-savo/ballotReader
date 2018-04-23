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

read_clarity <- function(url, destfile, Web01 = FALSE, report = NULL) {
  if (Web01 == TRUE) {
    ID <- str_extract(url,"[A-Z][A-Z]/[A-Za-z]+/[0-9]+/[0-9]+")
    url <- paste("http://results.enr.clarityelections.com/",ID,
                 switch(report,
                        csv = "/reports/summary.zip",
                        xls = "/reports/detailxls.zip",
                        txt = "/reports/detailtxt.zip",
                        xml = "/reports/detailxml.zip"), sep = '')
  }
  download.file(url, destfile)
  unzip(destfile)
}
