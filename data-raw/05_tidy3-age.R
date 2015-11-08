#' ---
#' title: "05_tidy3-age.R"
#' author: "csiu"
#' date: "November 6, 2015"
#' output:
#'   html_document:
#'     keep_md: TRUE
#' ---
#' ## At a glance
#' - clean up the "How old are you?" column to `age`
#'
#' ## Code
suppressPackageStartupMessages(library(dplyr))
library(readr)

raw <- read_csv("02_candy-survey.csv")

#' After loading the data, we will rename the columns.
## HELPER FUNCTION:
Rename_columns <- function(raw, old.name, new.name){
  cnames <- colnames(raw)
  colnames(raw)[grep(old.name, cnames)] <- new.name
  raw
}

## RENAME COLUMNS:
raw <- Rename_columns(raw,
                      "How old are you?",
                      "age")

good_data <- raw %>%
  select(user, age) %>%
  mutate(age = plyr::mapvalues(age,
                               from = grep("taking", age, value = TRUE),
                               to = grep("taking", age, value = TRUE) %>%
                                 substr(0, 2),
                               warn_missing = FALSE),
         age = plyr::mapvalues(age,
                               from = grep("^\\d+[,:]$", age, value = TRUE),
                               to = grep("^\\d+[,:]$", age, value = TRUE) %>%
                                 sub("[,:]$", "", .),
                               warn_missing = FALSE),
         age = plyr::mapvalues(age,
                               from = grep("43!", age, value = TRUE),
                               to = 43,
                               warn_missing = FALSE),
         age = plyr::mapvalues(age,
                               from = grep("^40. deal with it.|^45, but the|^50 \\(despair\\)",
                                           age, value = TRUE),
                               to = grep("^40. deal with it.|^45, but the|^50 \\(despair\\)",
                                         age, value = TRUE) %>%
                                 substr(0, 2),
                               warn_missing = FALSE),
         age = suppressWarnings(as.integer(age)),
         age = ifelse(age > 116 | age < 1, NA, age)
  )

#' Here we also cleanup the age range.
range(na.omit(good_data$age))
#' According to
#' [wikipedia's list of verified oldest people](https://en.wikipedia.org/wiki/List_of_the_verified_oldest_people),
#' the oldest person alive is Susannah Mushatt Jones (116 years old).
#' This means that any age about this value, I will set as NA.
#'
#' Here is the resulting list of oldest surveyees
good_data %>%
  arrange(desc(age)) %>%
  head() %>%
  knitr::kable()

#' I am also going to set any age less than 1 as NA --
#' this is to get rid of negative ages and/or babies.
#'
#' Here is the resulting list of youngest surveyees
good_data %>%
  arrange(age) %>%
  head() %>%
  knitr::kable()

#' what might also be interesting is to analyze surveyees who commented their ages as "old"
raw %>%
  select(user, age) %>%
  filter(grepl("old", age, ignore.case = TRUE),
         !grepl("year[ -]old", age, ignore.case = TRUE)) %>%
  arrange(age) %>%
  knitr::kable()

# good_data %>%
#   filter(!grepl('^\\d+$', age)) %>%
#   mutate(age = tolower(age)) %>%
#   group_by(age) %>%
#   summarise(count = length(age)) %>%
#   mutate(age = plyr::mapvalues(age,
#                                from = grep("taking", age, value = TRUE),
#                                to = grep("taking", age, value = TRUE) %>%
#                                  substr(0, 2)),
#          age = plyr::mapvalues(age,
#                                from = grep("^\\d+[,:]$", age, value = TRUE),
#                                to = grep("^\\d+[,:]$", age, value = TRUE) %>%
#                                  sub("[,:]$", "", .)),
#          age = plyr::mapvalues(age,
#                                from = grep("43!", age, value = TRUE),
#                                to = 43),
#          age = plyr::mapvalues(age,
#                                from = grep("^40. deal with it.|^45, but the|^50 \\(despair\\)", age, value = TRUE),
#                                to = grep("^40. deal with it.|^45, but the|^50 \\(despair\\)", age, value = TRUE) %>%
#                                  substr(0, 2))
#          ) %>%
#   filter(!grepl('^\\d+$', age)) %>%
#   knitr::kable()

#' Save:
write_csv(good_data, "05_tidy3-age.csv")
