setwd("G:/My Drive/Y3/S2/Political Programming/github/govt496-project/ballotReader")
context("testing for valid outputs")

test_that("read_results gives correct data", {
  t1 <- read_results("data/hor_nj01_17.pdf")
  t2 <- read.csv("data/NJ01_17.csv")
  expect_equal(ncol(t1), ncol(t2))
  expect_equal(nrow(t1), nrow(t2))
})

test_that("read_vertical_results gives correct data", {
  t1 <- read_vertical_results("data/dem_primary_essex_17.pdf",
                     range = c(1:11),
                     colnames = c("Municipality","Registration","Ballots Cast","Turnout (%)",
                                  "Philip MURPHY","William BRENNAN","John S. WISNIEWSKI",
                                  "Jim Johnson","Mark ZINNA","Raymond J. LESNIAK","Write-In"))
  t2 <- read.csv("data/essex_gov_dempri_17.csv")
  expect_equal(ncol(t1), ncol(t2))
  expect_equal(nrow(t1), nrow(t2))
})

test_that("read_clarity_results gives correct data", {
  t1 <- read_clarity_results("http://results.enr.clarityelections.com/NJ/Gloucester/71871/191307/Web01/en/summary.html", "gloucester.zip", report = "xls", tidy_detail = TRUE, page_range = 3:5)
  t2 <- read.csv("data/Gloucester_gov_17.csv")
  expect_equal(ncol(t1[[1]]), ncol(t2))
  expect_equal(nrow(t1[[1]]), nrow(t2))
})
