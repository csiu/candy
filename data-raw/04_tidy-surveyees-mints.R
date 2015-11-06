#' ---
#' title: "04_tidy-surveyees-mints.R"
#' author: "csiu"
#' date: "November 5, 2015"
#' output: html_document
#' ---
#suppressPackageStartupMessages(library(plyr))
suppressPackageStartupMessages(library(dplyr))
library(readr)

candy_surveyee <- read_csv("03_candy-surveyee.csv")

## clean up mints
candy_surveyee <- candy_surveyee %>%
  mutate(n_mints = tolower(n_mints)) %>%
  mutate(
    #old_mints = n_mints,
    n_mints = plyr::mapvalues(n_mints,
                        from = grep("[.!?]$", n_mints, value=TRUE),
                        to   = grep("[.!?]$", n_mints, value=TRUE) %>%
                          gsub("[.!?]$", "", .),
                        warn_missing = FALSE),
    n_mints = plyr::mapvalues(n_mints,
                        from = grep("^0|^zero|none", n_mints, value = TRUE),
                        to   = grep("^0|^zero|none", n_mints, value = TRUE) %>%
                          length() %>%
                          rep(0, .),
                        warn_missing = FALSE),
    n_mints = plyr::mapvalues(n_mints,
                        from = grep("^\\d+,[.,0-9]+$", n_mints, value = TRUE),
                        to   = grep("^\\d+,[.,0-9]+$", n_mints, value = TRUE) %>%
                          gsub(",", "", .)),
    n_mints = plyr::revalue(n_mints, replace = c("one"=1, "two"=2, "three"=3, "four"=4, "five"=5,
                                 "six"=6, "seven"=7, "eight"=8, "nine"=9, "ten"=10,
                                 "twelve"=12, "π"=pi,
                                 "2 1/2"=2.5, "420+69"=489, "7.3/4"=1.825,
                                 "1 billion"=1000000000),
                      warn_missing = FALSE),
    n_mints = suppressWarnings(as.integer(n_mints))
  ) %>%
  filter(n_mints >= 1)

write.table(candy_surveyee, file = "04_candy-surveyee.csv", sep=",", row.names = FALSE)
