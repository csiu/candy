#' ---
#' title: "03_tidy-surveyees.R"
#' author: "csiu"
#' date: "November 5, 2015"
#' output: html_document
#' ---
suppressPackageStartupMessages(library(dplyr))
library(readr)

candy_survey <- read_csv("candy-survey-2015.csv",
                         col_types = cols(
                           Timestamp = col_datetime("%m/%d/%Y %H:%M:%S")
                         ))

## remove space in front of colnames
colnames(candy_survey) <- sub('^\\s+', '', colnames(candy_survey))

candy_surveyee <- colnames(candy_survey) %>%
  grep('^\\[|^Please|^Check all that apply', ., value = TRUE, invert = TRUE) %>%
  candy_survey[,.]

## rename columns
Rename_columns <- function(candy_surveyee, old.name, new.name){
  cnames <- colnames(candy_surveyee)
  colnames(candy_surveyee)[grep(old.name, cnames)] <- new.name
  candy_surveyee
}
candy_surveyee <- Rename_columns(candy_surveyee,
                                 "How old are you?",
                                 "age")
candy_surveyee <- Rename_columns(candy_surveyee,
                                 "Are you going actually going trick or treating yourself?",
                                 "trick_or_treat")
candy_surveyee <- Rename_columns(candy_surveyee,
                                 "Guess the number of mints in my hand.",
                                 "n_mints")
candy_surveyee <- Rename_columns(candy_surveyee,
                                 "Betty or Veronica?",
                                 "archie_girls")
candy_surveyee <- Rename_columns(candy_surveyee,
                                 "That dress",
                                 "the_dress")
candy_surveyee <- Rename_columns(candy_surveyee,
                                 "Taylor Swift is a force for",
                                 "taylor_swift")
candy_surveyee <- Rename_columns(candy_surveyee,
                                 "What is your favourite font?",
                                 "favourite_font")
candy_surveyee <- Rename_columns(candy_surveyee,
                                 "Intelligent Design",
                                 "intelligent_design")
candy_surveyee <- Rename_columns(candy_surveyee,
                                 "Imitation is a form of ____________",
                                 "imitation")
candy_surveyee <- Rename_columns(candy_surveyee,
                                 "Which day do you prefer, Friday or Sunday?",
                                 "friday_or_saturday")

## turn trick_or_treat into logical
candy_surveyee <- candy_surveyee %>%
  mutate(trick_or_treat = trick_or_treat == "yes")

#write.table(candy_surveyee, file = "candy_surveyee.csv", sep=",", row.names = FALSE)
