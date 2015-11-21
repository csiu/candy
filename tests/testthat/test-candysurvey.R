context("Validity of candysurvey data")

suppressPackageStartupMessages(library(dplyr))
find_int <- function(userID, field)
  candysurvey %>% filter(user == userID) %>% select_(field) %>% .[[1]]

test_that("ages are not screwed up when convert to factor and back to integer", {
  expect_equal(find_int("ID-0138", "age"), 35)
  expect_equal(find_int("ID-0150", "age"), 33)
  expect_equal(find_int("ID-0146", "age"), NA_integer_)
})

test_that("n_mints are not screwed up when convert to factor and back to integer", {
  expect_equal(find_int("ID-0138", "n_mints"), 2)
  expect_equal(find_int("ID-0150", "n_mints"), 5)
  expect_equal(find_int("ID-0199", "n_mints"), NA_integer_)
})

test_that("trick_or_treat is boolean", {
  expect_false(find_int("ID-0138", "trick_or_treat"))
  expect_true(find_int("ID-0146", "trick_or_treat"))
})
