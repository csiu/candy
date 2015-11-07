#' ---
#' title: "04_tidy2-mints.R"
#' author: "csiu"
#' date: "November 6, 2015"
#' output:
#'   html_document:
#'     keep_md: TRUE
#' ---
#' ## At a glance
#' - clean up the "Guess the number of mints in my hand." column to `n_mints`
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
                      "Guess the number of mints in my hand.",
                      "n_mints")

#' Clean up mint data by
#'
#' 1. Converting the values to lowercase
#' 2. Removing punctuation at the end of strings
#' 3. Mapping any string starting with 0 or contains "zero" or "none" to be 0
#' 4. Removing commas in strings that contain only digits/commas
#' 5. Manually revalue some factors e.g. "six" is 6 and "7.3/4" is 1.825
#' 6. Converting values to integers (and replacing those that fail conversion with NA)
#' 7. Replacing negative integers with NA (since this is count data)
good_data <- raw %>%
  select(user, n_mints) %>%
  mutate(
    n_mints = tolower(n_mints),
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
    n_mints = suppressWarnings(as.integer(n_mints)),
    n_mints = ifelse(n_mints < 0, NA, n_mints)
  )

#' Save data:
write_csv(good_data, "04_tidy2-mints.csv")
