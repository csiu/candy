# 04_tidy4-candy.R
csiu  
November 8, 2015  
## At a glance
- clean up the *[\<candy\>]* columns

## Code


```r
suppressPackageStartupMessages(library(dplyr))
library(readr)

raw <- read_csv("02_candy-survey.csv")

## Select candy data:
candy_data <- grep("^\\[", colnames(raw), value = TRUE) %>%
  c("user", .) %>%
  raw[,.]
```

Make new variable with updated column names:


```r
cnames <- colnames(candy_data)
cnames <- gsub("^\\[|\\]$", "", cnames) ## get rid of start/stop square brackets
cnames <- gsub("’", "'", cnames)        ## replace single quote

grep('"', cnames, value = TRUE)         ## determine which columns uses double quotes
```

```
## [1] "Sea-salt flavored stuff, probably chocolate, since this is the \"it\" flavor of the year"
```

```r
cnames <- gsub('"it"', "IT", cnames)    ## get rid of quotes around "it"
```

Here are things that I do not want to change


```r
# cnames <- gsub(",.*", "", cnames)       ## get rid of anything after comma
# grep("_", cnames, value = TRUE)         ## check that underscore is not used
# cnames <- gsub(" ", "_", cnames)        ## replace space with underscore
```

Replace candy data column names:


```r
colnames(candy_data) <- cnames
colnames(candy_data)
```

```
##  [1] "user"                                                                                
##  [2] "Butterfinger"                                                                        
##  [3] "100 Grand Bar"                                                                       
##  [4] "Anonymous brown globs that come in black and orange wrappers"                        
##  [5] "Any full-sized candy bar"                                                            
##  [6] "Black Jacks"                                                                         
##  [7] "Bonkers"                                                                             
##  [8] "Bottle Caps"                                                                         
##  [9] "Box'o' Raisins"                                                                      
## [10] "Brach products (not including candy corn)"                                           
## [11] "Bubble Gum"                                                                          
## [12] "Cadbury Creme Eggs"                                                                  
## [13] "Candy Corn"                                                                          
## [14] "Vials of pure high fructose corn syrup, for main-lining into your vein"              
## [15] "Candy that is clearly just the stuff given out for free at restaurants"              
## [16] "Cash, or other forms of legal tender"                                                
## [17] "Chiclets"                                                                            
## [18] "Caramellos"                                                                          
## [19] "Snickers"                                                                            
## [20] "Dark Chocolate Hershey"                                                              
## [21] "Dental paraphenalia"                                                                 
## [22] "Dots"                                                                                
## [23] "Fuzzy Peaches"                                                                       
## [24] "Generic Brand Acetaminophen"                                                         
## [25] "Glow sticks"                                                                         
## [26] "Broken glow stick"                                                                   
## [27] "Goo Goo Clusters"                                                                    
## [28] "Good N' Plenty"                                                                      
## [29] "Gum from baseball cards"                                                             
## [30] "Gummy Bears straight up"                                                             
## [31] "Creepy Religious comics/Chick Tracts"                                                
## [32] "Healthy Fruit"                                                                       
## [33] "Heath Bar"                                                                           
## [34] "Hershey's Kissables"                                                                 
## [35] "Hershey's Milk Chocolate"                                                            
## [36] "Hugs (actual physical hugs)"                                                         
## [37] "Jolly Rancher (bad flavor)"                                                          
## [38] "Jolly Ranchers (good flavor)"                                                        
## [39] "Kale smoothie"                                                                       
## [40] "Kinder Happy Hippo"                                                                  
## [41] "Kit Kat"                                                                             
## [42] "Hard Candy"                                                                          
## [43] "Lapel Pins"                                                                          
## [44] "LemonHeads"                                                                          
## [45] "Licorice"                                                                            
## [46] "Licorice (not black)"                                                                
## [47] "Lindt Truffle"                                                                       
## [48] "Lollipops"                                                                           
## [49] "Mars"                                                                                
## [50] "Mary Janes"                                                                          
## [51] "Maynards"                                                                            
## [52] "Milk Duds"                                                                           
## [53] "LaffyTaffy"                                                                          
## [54] "Minibags of chips"                                                                   
## [55] "JoyJoy (Mit Iodine)"                                                                 
## [56] "Reggie Jackson Bar"                                                                  
## [57] "Pixy Stix"                                                                           
## [58] "Nerds"                                                                               
## [59] "Nestle Crunch"                                                                       
## [60] "Now'n'Laters"                                                                        
## [61] "Pencils"                                                                             
## [62] "Milky Way"                                                                           
## [63] "Reese's Peanut Butter Cups"                                                          
## [64] "Tolberone something or other"                                                        
## [65] "Runts"                                                                               
## [66] "Junior Mints"                                                                        
## [67] "Senior Mints"                                                                        
## [68] "Mint Kisses"                                                                         
## [69] "Mint Juleps"                                                                         
## [70] "Mint Leaves"                                                                         
## [71] "Peanut M&M's"                                                                        
## [72] "Regular M&Ms"                                                                        
## [73] "Mint M&Ms"                                                                           
## [74] "Ribbon candy"                                                                        
## [75] "Rolos"                                                                               
## [76] "Skittles"                                                                            
## [77] "Smarties (American)"                                                                 
## [78] "Smarties (Commonwealth)"                                                             
## [79] "Chick-o-Sticks (we don't know what that is)"                                         
## [80] "Spotted Dick"                                                                        
## [81] "Starburst"                                                                           
## [82] "Swedish Fish"                                                                        
## [83] "Sweetums"                                                                            
## [84] "Those odd marshmallow circus peanut things"                                          
## [85] "Three Musketeers"                                                                    
## [86] "Peterson Brand Sidewalk Chalk"                                                       
## [87] "Peanut Butter Bars"                                                                  
## [88] "Peanut Butter Jars"                                                                  
## [89] "Trail Mix"                                                                           
## [90] "Twix"                                                                                
## [91] "Vicodin"                                                                             
## [92] "White Bread"                                                                         
## [93] "Whole Wheat anything"                                                                
## [94] "York Peppermint Patties"                                                             
## [95] "Sea-salt flavored stuff, probably chocolate, since this is the IT flavor of the year"
## [96] "Necco Wafers"
```

Save data


```r
write_csv(candy_data, "06_tidy4-candy.csv")
```


---
title: "06_tidy4-candy.R"
author: "csiu"
date: "Sun Nov  8 16:29:33 2015"
---
