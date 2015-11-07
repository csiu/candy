#' ---
#' title: "03_tidy1.R"
#' author: "csiu"
#' date: "November 6, 2015"
#' output:
#'   html_document:
#'     keep_md: TRUE
#' ---
#' ## At a glance
#' We will clean up the following columns
#'
#' | Before | After |
#' |:------:|:-----:|
#' | "Are you going actually going trick or treating yourself?" | `trick_or_treat` |
#' | "Betty or Veronica?" | `archie_girls` |
#' | "\"That dress* that went viral early this year - when I first saw it, it was ________\"" | `the_dress` |
#' | "Fill in the blank: \"Imitation is a form of ____________\"" | `imitation` |
#' | "Which day do you prefer, Friday or Sunday?" | `friday_or_sunday` |
#'
#' ## Code
suppressPackageStartupMessages(library(dplyr))
library(readr)

raw <- read_csv("02_candy-survey.csv",
                col_types = cols(
                  Timestamp = col_datetime("%m/%d/%Y %H:%M:%S")
                ))

#' After loading the data, we will rename the columns.
## HELPER FUNCTION:
Rename_columns <- function(raw, old.name, new.name){
  cnames <- colnames(raw)
  colnames(raw)[grep(old.name, cnames)] <- new.name
  raw
}

## RENAME COLUMNS:
raw <- Rename_columns(raw,
                      "Are you going actually going trick or treating yourself?",
                      "trick_or_treat")
raw <- Rename_columns(raw,
                      "Betty or Veronica?",
                      "archie_girls")
raw <- Rename_columns(raw,
                      "That dress",
                      "the_dress")
raw <- Rename_columns(raw,
                      "Taylor Swift is a force for",
                      "taylor_swift")
raw <- Rename_columns(raw,
                      "Imitation is a form of ____________",
                      "imitation")
raw <- Rename_columns(raw,
                      "Which day do you prefer, Friday or Sunday?",
                      "friday_or_saturday")

#' Here we select the columns to work with.
good_data <- raw %>%
  select(
    user,
    trick_or_treat,
    archie_girls,
    the_dress,
    taylor_swift,
    imitation,
    friday_or_saturday
  )

#' In column `tick_or_treat`, we will change the values to logical.
good_data <- good_data %>%
  mutate(trick_or_treat = trick_or_treat == "Yes")

#' In column `taylor_swift`, we will drop it because no user responded to this survey question.
good_data %>%
  select(taylor_swift) %>%
  unique()


good_data <- good_data[,!grepl("taylor_swift", colnames(good_data))]

#' Finally, we save this data to file.
write_csv(good_data, "03_tidy1.csv")
