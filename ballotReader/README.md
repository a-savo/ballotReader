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


`read_vertical_results()` is designed to import and tidy otherwise well-formatted .pdf tables where column names are formatted vertically. The column names must be provided manually.

```R
Example
```

`read_clarity_results()` downloads and unzips a variety of summary and detailed reports from election websites that use Scytl's Clarity Elections platform. `read_clarity_results()` can also open and tidy extremely detailed precint-level reports using the `detail.xls` reports provided by Clarity Elections websites, creating a list of dataframes containing the data from each worksheet in the detailed report.

```R
Example, with pictures to illustrate Clarity Elections platform
```
