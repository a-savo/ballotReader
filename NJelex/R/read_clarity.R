# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

read_clarity <- function(url, destfile) {
  download.file(url, destfile)
  unzip(destfile)

}

temp <- tempfile()
download.file("https://results.enr.clarityelections.com/GA/70059/187898/reports/detailxls.zip","GA06.zip", mode = "wb")
unzip("GA06.zip")
unlink(temp)
