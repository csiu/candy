#' ---
#' title: "04_tidy4-candy.R"
#' author: "csiu"
#' date: "November 8, 2015"
#' output:
#'   html_document:
#'     keep_md: TRUE
#' ---
#' ## At a glance
#' - clean up the *[\<candy\>]* columns
#'
#' ## Code
suppressPackageStartupMessages(library(dplyr))
library(readr)

raw <- read_csv("02_candy-survey.csv")

## Select candy data:
candy_data <- grep("^\\[", colnames(raw), value = TRUE) %>%
  c("user", .) %>%
  raw[,.]

#' Make new variable with updated column names:
cnames <- colnames(candy_data)
cnames <- gsub("^\\[|\\]$", "", cnames) ## get rid of start/stop square brackets
cnames <- gsub("’", "'", cnames)        ## replace single quote

grep('"', cnames, value = TRUE)         ## determine which columns uses double quotes
cnames <- gsub('"it"', "IT", cnames)    ## get rid of quotes around "it"

#' Here are things that I do not want to change
# cnames <- gsub(",.*", "", cnames)       ## get rid of anything after comma
# grep("_", cnames, value = TRUE)         ## check that underscore is not used
# cnames <- gsub(" ", "_", cnames)        ## replace space with underscore

#' Replace candy data column names:
colnames(candy_data) <- cnames
colnames(candy_data)

#' Save data
write_csv(candy_data, "06_tidy4-candy.csv")
