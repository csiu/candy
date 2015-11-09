#' ---
#' title: "README"
#' author: "csiu"
#' date: "November 8, 2015"
#' output:
#'   html_document:
#'     keep_md: TRUE
#' ---
#' In this directory, I attempt to tidy the candy survey data
#'
#' ## The survey columns
#' Categories of questions in the survey related to candy:
#'
#' | Category | Response | Ideal Response class | Done?/Script # |
#' |:--------:|:--------:|:--------------------:|:-------:|
#' | Timestamp | Timestamp | time | [#3](03_tidy1.md) |
#' | Going trick or treating? | {yes, no} | logical | [#3](03_tidy1.md) |
#' | Age | free text | should be int | [#5](05_tidy3-age.md) |
#' | [the candy] | {joy, despair} | logical | [#6](06_tidy4-candy.md) |
#' | Other joy candy | free text | list | [] |
#' | Other despair candy | free text | list | [] |
#' | Comments | free text | text | [] |
#'
#' Categories of questions in the survey not-related to candy:
#'
#' | Category | Response | Ideal Response class | Tidied? |
#' |:--------:|:--------:|:--------------------:|:-------:|
#' | guess mints in hand | free text | should be int | [#4](04_tidy2-mints.md) |
#' | Betty or Veronica? | {Betty, Veronica, ??} | factor | [#3](03_tidy1.md) |
#' | tears when | multiple choice (can select more than 1) | maybe factor | [] |
#' | the dress | {blue and black, white and gold} | factor | [#3](03_tidy1.md) |
#' | favorite font | free text | should be factor | [] |
#' | intelligent design | multiple choice + other | should be factor | [] |
#' | [separation] | {1, 2, 3+} | factor | [] |
#' | Imitation | {Flattery, Laziness, Lazily flattering someone} | factor | [#3](03_tidy1.md) |
#' | Friday vs Sunday | {Friday, Sunday} | factor | [#3](03_tidy1.md) |
#'
#' ## Combining the good data
#' The following will combine the tidy data from the separate csv files:
suppressPackageStartupMessages(library(dplyr))
library(readr)

infiles <- list.files(".", pattern = "\\d{2}_tidy\\d.*csv$")

round1 = TRUE
for (f in infiles){
  dat1 <- read_csv(f)
  if (round1){
    round1 = FALSE
    good_data <- dat1
    next()
  } else {
    good_data <- left_join(good_data, dat1, by = "user")
  }
}

good_data <- good_data %>%
  arrange(user)
