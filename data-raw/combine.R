suppressPackageStartupMessages(library(dplyr))

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
