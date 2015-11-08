# 05_tidy2-age.R
csiu  
November 6, 2015  
## At a glance
- clean up the "How old are you?" column to `age`

## Code


```r
suppressPackageStartupMessages(library(dplyr))
library(readr)

raw <- read_csv("02_candy-survey.csv")
```

After loading the data, we will rename the columns.


```r
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
```

Here we also cleanup the age range.


```r
range(na.omit(good_data$age))
```

```
## [1]   5 115
```

According to
[wikipedia's list of verified oldest people](https://en.wikipedia.org/wiki/List_of_the_verified_oldest_people),
the oldest person alive is Susannah Mushatt Jones (116 years old).
This means that any age about this value, I will set as NA.

Here is the resulting list of oldest surveyees


```r
good_data %>%
  arrange(desc(age)) %>%
  head() %>%
  knitr::kable()
```



user       age
--------  ----
ID-1809    115
ID-3502    108
ID-1408    100
ID-1423    100
ID-2640    100
ID-1257     99

I am also going to set any age less than 1 as NA --
this is to get rid of negative ages and/or babies.

Here is the resulting list of youngest surveyees


```r
good_data %>%
  arrange(age) %>%
  head() %>%
  knitr::kable()
```



user       age
--------  ----
ID-0978      5
ID-0371      6
ID-0374      6
ID-2173      6
ID-2366      6
ID-1355      7

what might also be interesting is to analyze surveyees who commented their ages as "old"


```r
raw %>%
  select(user, age) %>%
  filter(grepl("old", age, ignore.case = TRUE),
         !grepl("year[ -]old", age, ignore.case = TRUE)) %>%
  arrange(age) %>%
  knitr::kable()
```



user      age                                 
--------  ------------------------------------
ID-0426   old                                 
ID-2128   old                                 
ID-2823   old                                 
ID-3117   old                                 
ID-3978   old                                 
ID-4108   old                                 
ID-4453   old                                 
ID-4873   old                                 
ID-2951   Old                                 
ID-3040   Old                                 
ID-3379   Old                                 
ID-3666   Old                                 
ID-5484   Old                                 
ID-0041   old but still know joy from despair 
ID-0352   old enough                          
ID-0393   old enough                          
ID-0006   old enough                          
ID-4849   old enough                          
ID-4616   old enough to know better           
ID-1704   old enough to party                 
ID-5513   Old, very old                       
ID-1502   older than dirt                     
ID-1506   older than dirt                     
ID-1059   Older than you                      
ID-5360   So old                              
ID-2520   too old                             
ID-2717   too old                             
ID-2788   too old                             
ID-3039   too old                             
ID-4332   too old                             
ID-4841   too old                             
ID-1565   Too old                             
ID-1566   Too old                             
ID-1567   Too old                             
ID-1568   Too old                             
ID-1569   Too old                             
ID-1965   Too old                             
ID-1248   too old for this                    

```r
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
```


---
title: "05_tidy3-age.R"
author: "csiu"
date: "Sun Nov  8 13:34:54 2015"
---
