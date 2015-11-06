#' ---
#' title: "02_add-user-column.R"
#' author: "csiu"
#' date: "November 6, 2015"
#' output:
#'   html_document:
#'     keep_md: TRUE
#' ---
#'
#' ## At a glance
#' - add `user` id column to the raw candy data
#'
#' ## Code
suppressPackageStartupMessages(library(dplyr))
library(readr)

#' Load raw candy data:
candy_survey <- read_csv("candy-survey-2015.csv")

#' Remove whitespace space in front of column names:
colnames(candy_survey) <- sub('^\\s+', '', colnames(candy_survey))

#' Add `user` id column:
candy_survey <- candy_survey %>%
  mutate(user = sprintf("ID-%04d", order(Timestamp)))
colnames(candy_survey)

#' Save data:
write.table(candy_survey, file = "02_candy-survey.csv", sep=",", row.names = FALSE)
