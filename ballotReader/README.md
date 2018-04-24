# Import and Tidy Local Election Results

**ballotReader** is a set of functions designed to efficiently import and tidy local election results in a variety of standardized formats, including the Clarity Elections reporting platform and common .pdf formats.

Note: In order to use most ballotReader functions, users must first install the [tabulizer](https://github.com/ropensci/tabulizer) package via GitHub as well as a recent version of Java.

## Code Examples

`read_results()` is the most basic ballotReader function, designed to import and tidy tables from .pdf files which are already well formatted. For ballotReader's purposes, a table is well formatted if localities (counties, cities, etc.) are listed in the leftmost column, candidate vote totals are listed in each subsequent column, and none of the table text is formatted vertically.

```R
example
```

`read_vertical_results()` is designed to import and tidy otherwise well-formatted .pdf tables where column names are formatted vertically. The column names must be provided manually.

```R
Example
```

`read_clarity_results()` downloads and unzips a variety of summary and detailed reports from election websites that use Scytl's Clarity Elections platform. `read_clarity_results()` can also open and tidy extremely detailed precint-level reports using the `detail.xls` reports provided by Clarity Elections websites, creating a list of dataframes containing the data from each worksheet in the detailed report.

```R
Example, with pictures to illustrate Clarity Elections platform
```
