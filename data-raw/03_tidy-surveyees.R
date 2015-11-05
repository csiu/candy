suppressPackageStartupMessages(library(dplyr))

candy_survey <- read.delim("candy-survey-2015.csv", sep = ",", check.names = FALSE)

## remove space in front of colnames
colnames(candy_survey) <- sub('^\\s+', '', colnames(candy_survey))

## order surveyee by timestamp
candy_surveyee <- candy_survey[,1] %>%
  strptime(format = "%m/%d/%Y %H:%M:%S") %>%
  data.frame(timestamp = .) %>%
  mutate(user = order(timestamp)
         #date = format(timestamp, format="%Y-%m-%d"),
         #time = format(timestamp, format="%H:%M:%S")
         )

## add other fields (excluding joy/despair candy ratings & degree of separations)
candy_surveyee <- cbind(candy_surveyee,
      colnames(candy_survey) %>%
        grep('^\\[|^Please|^Check all that apply|^Timestamp', ., value = TRUE, invert = TRUE) %>%
        candy_survey[,.]) %>%
  tbl_df()

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
