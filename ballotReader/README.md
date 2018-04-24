# Import and Tidy Local Election Results

**ballotReader** is a set of functions designed to efficiently import and tidy local election results in a variety of standardized formats, including the Clarity Elections reporting platform and common `.pdf` formats. ballotReader is intended to eliminate time spent wrangling election results online, in Microsoft Excel, and in third-party conversion software by processing election data entirely within R, where it can then easily be saved as an analysis-friendly `.csv` file. 

Note: In order to use most ballotReader functions, users must first install the [tabulizer](https://github.com/ropensci/tabulizer) package via Github as well as a recent version of Java.

## Code Examples

`read_results()` is the most basic ballotReader function, designed to import and tidy tables from `.pdf` files which are already well formatted. For ballotReader's purposes, a table is well formatted if localities (counties, cities, etc.) are listed in the leftmost column, candidate vote totals are listed in each subsequent column, and none of the table text is formatted vertically. For example, the following `.pdf` from the New Jersey Division of Elections website is perfectly formatted for `read_results()`:

[![1st District General Election Results: House of Representatives](https://i.imgur.com/thLSu25.png)](https://i.imgur.com/thLSu25.png)

```R
url <- "http://www.njelections.org/2016-results/2016-municipality-hor-district1.pdf"
out <- read_results(url)
head(out, 15)
            Subgroup      Municipality                      Candidate  Votes
1  Burlington County   Maple Shade Twp Donald W. Norcross\rDemocratic  4,025
2  Burlington County      Palmyra Boro Donald W. Norcross\rDemocratic  1,975
3   Federal Overseas Burlington Totals Donald W. Norcross\rDemocratic  6,000
4      Camden County      Audubon Boro Donald W. Norcross\rDemocratic  2,409
5      Camden County Audubon Park Boro Donald W. Norcross\rDemocratic    288
6      Camden County   Barrington Boro Donald W. Norcross\rDemocratic  1,733
7      Camden County     Bellmawr Boro Donald W. Norcross\rDemocratic  2,649
8      Camden County       Berlin Boro Donald W. Norcross\rDemocratic  1,591
9      Camden County       Berlin Twp. Donald W. Norcross\rDemocratic  1,293
10     Camden County    Brooklawn Boro Donald W. Norcross\rDemocratic    455
11     Camden County       Camden City Donald W. Norcross\rDemocratic 16,424
12     Camden County  Cherry Hill Twp. Donald W. Norcross\rDemocratic 20,655
13     Camden County  Chesilhurst Boro Donald W. Norcross\rDemocratic    476
14     Camden County    Clementon Boro Donald W. Norcross\rDemocratic  1,126
15     Camden County Collingswood Boro Donald W. Norcross\rDemocratic  4,581
```

`read_results()` also contains a `merged_header` argument, which allows .pdf tables with merged headers grouping candidates or races together [(example)](http://www.njelections.org/2017-results/2017-general-election-results-gen-assembly-state-senate-district-01.pdf) to be imported.


`read_vertical_results()` is designed to import and tidy otherwise well-formatted .pdf tables where column names are formatted vertically for a single race of interest. Because the `tabulizer` package struggles to correctly interpret vertically-oriented text, the column names must be provided manually. The page range must also be specified for the race of interest. `read_vertical_results()` is designed to import results from `.pdf` files like the following example from the Essex County Clerk's Office in New Jersey:

[![2017 Official Primary Election Results - Democratic for Governor](https://i.imgur.com/v0VD0dA.png)](https://i.imgur.com/v0VD0dA.png)

```R
url <- "http://www.essexclerk.com/_Content/pdf/ElectionResult/DEM_SOV_2017.pdf"
out <- read_vertical_results(url, range = c(1:11), colnames = c("Municipality",
                                          "Registration",
                                          "Ballots Cast",
                                          "Turnout (%)",
                                          "Philip MURPHY",
                                          "William BRENNAN",
                                          "John S. WISNIEWSKI",
                                          "Jim Johnson",
                                          "Mark ZINNA",
                                          "Raymond J. LESNIAK",
                                          "Write-In "))
head(out, 15)
                    Municipality  Vote Choice Votes
1  Belleville 1-1 - Election Day Registration   427
2  Belleville 1-2 - Election Day Registration   412
3  Belleville 1-3 - Election Day Registration   305
4  Belleville 1-4 - Election Day Registration   356
5  Belleville 1-5 - Election Day Registration   383
6  Belleville 1-6 - Election Day Registration   218
7  Belleville 2-1 - Election Day Registration   270
8  Belleville 2-2 - Election Day Registration   191
9  Belleville 2-3 - Election Day Registration   290
10 Belleville 2-4 - Election Day Registration   302
11 Belleville 2-5 - Election Day Registration   314
12 Belleville 2-6 - Election Day Registration   265
13 Belleville 2-7 - Election Day Registration   268
14 Belleville 2-8 - Election Day Registration   411
15 Belleville 3-1 - Election Day Registration   323
```

`read_clarity_results()` is ballotReader's most powerful function, designed to download and process election reports from local election websites that use Scytl's Clarity Elections platform. `read_clarity_results()` downloads and unzips summary `.csv` reports and detailed `.xls`, `.xml`, and `.txt` reports from Clarity Elections websites, and can also import and tidy detailed precinct-level election results, creating a list of data.frames containing data from each worksheet in the `detail.xls` report.

`read_clarity_results()` contains six important arguments:
* `file` should be a link to either the website's home page (if Web01) or a direct link to the desired `.zip` file (if Web02). See below for the difference between Web01 and Web02.
* `destfile` is the directory where the `.zip` file will be downloaded and unzipped. If you are also going to import and tidy the `detail.xls` report, do not set `destfile` outside of the current working directory.
* `Web01` is FALSE by default. Set `Web01` to TRUE for election sites that use the Web01 format.
* `report` should only have a value if `Web01` is TRUE. Pick from "csv", "xls", "xml", or "txt".
* `tidy_detail` is FALSE by default. Set `tidy_detail` to TRUE in order to import and tidy precinct-level election results from the `detail.xls` report. Be aware that this part of the function can take a *long* time to run for large reports with many elections.
* `page_range` should only have a value if `tidy_detail` is TRUE. Set `page_range` to a numeric vector from 3 to n (i.e. `c(3:n)`) to only import and tidy a subset of the `detail.xls` report. Users may want to run `read_clarity_results()` with `tidy_detail` set to FALSE at first in order to determine how many pages to import.

Clarity Elections websites generally come in one of two formats, Web01 and Web02. The site format is included in the URL and can also be determined by the site's formatting (see ). 

```R
Example, with pictures to illustrate Clarity Elections platform
```