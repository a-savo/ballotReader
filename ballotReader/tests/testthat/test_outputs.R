setwd("G:/My Drive/Y3/S2/Political Programming/github/govt496-project/ballotReader")
context("testing for valid outputs")

test_that("read_results gives correct data", {
  t1 <- read_results("data/hor_nj01_17.pdf")
  t2 <- read.csv("data/NJ01_17.csv")
  expect_equal(ncol(t1), nrow(t2))
})
