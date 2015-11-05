# The data
csiu  
November 4, 2015  

```r
suppressPackageStartupMessages(library(dplyr))
```

- About the survey: http://boingboing.net/2015/10/23/only-you-can-determine-what-to.html
- Survey itself: https://docs.google.com/forms/d/1XjybL7zDs479qYk9jFptDc35fjjXFyXLnTCHCMIw6pI/viewform



```r
candy_survey <- read.delim("candy-survey-2015.csv", sep = ",", check.names = FALSE)

## DATA SIZE
dim(candy_survey)
```

```
## [1] 5658  124
```

## Candy survey questions (aka the data header)

Categories of questions on the survey related to candy:

| Category | Response | Ideal Response class |
|:--------:|:--------:|:--------------------:|
| Going trick or treating? | {yes, no} | logical |
| Age | free text | should be int |
| [the candy] | {joy, despair} | logical | 
| Other joy candy | free text | list |
| Other despair candy | free text | list |
| Comments | free text | text |

Categories of questions on the survey not-related to candy:

| Category | Response | Ideal Response class |
|:--------:|:--------:|:--------------------:|
| guess mints in hand | free text | should be int |
| Betty or Veronica? | {Betty, Veronica, ??} | factor |
| tears when | multiple choice (can select more than 1) | maybe factor | 
| the dress | {blue and black, white and gold} | factor | 
| favorite font | free text | should be factor |
| intelligent design | multiple choice + other | should be factor | 
| [separation] | {1, 2, 3+} | factor | 
| Imitation | {Flattery, Laziness, Lazily flattering someone} | factor | 
| Friday vs Sunday | {Friday, Sunday} | factor |


```r
candy_survey %>% 
  colnames()
```

```
##   [1] "Timestamp"                                                                                                        
##   [2] "How old are you?"                                                                                                 
##   [3] "Are you going actually going trick or treating yourself?"                                                         
##   [4] "[Butterfinger]"                                                                                                   
##   [5] "[100 Grand Bar]"                                                                                                  
##   [6] "[Anonymous brown globs that come in black and orange wrappers]"                                                   
##   [7] "[Any full-sized candy bar]"                                                                                       
##   [8] "[Black Jacks]"                                                                                                    
##   [9] "[Bonkers]"                                                                                                        
##  [10] "[Bottle Caps]"                                                                                                    
##  [11] "[Box’o’ Raisins]"                                                                                                 
##  [12] "[Brach products (not including candy corn)]"                                                                      
##  [13] "[Bubble Gum]"                                                                                                     
##  [14] "[Cadbury Creme Eggs]"                                                                                             
##  [15] "[Candy Corn]"                                                                                                     
##  [16] " [Vials of pure high fructose corn syrup, for main-lining into your vein]"                                        
##  [17] "[Candy that is clearly just the stuff given out for free at restaurants]"                                         
##  [18] " [Cash, or other forms of legal tender]"                                                                          
##  [19] "[Chiclets]"                                                                                                       
##  [20] "[Caramellos]"                                                                                                     
##  [21] "[Snickers]"                                                                                                       
##  [22] "[Dark Chocolate Hershey]"                                                                                         
##  [23] "[Dental paraphenalia]"                                                                                            
##  [24] "[Dots]"                                                                                                           
##  [25] "[Fuzzy Peaches]"                                                                                                  
##  [26] "[Generic Brand Acetaminophen]"                                                                                    
##  [27] "[Glow sticks]"                                                                                                    
##  [28] "[Broken glow stick]"                                                                                              
##  [29] "[Goo Goo Clusters]"                                                                                               
##  [30] "[Good N' Plenty]"                                                                                                 
##  [31] "[Gum from baseball cards]"                                                                                        
##  [32] "[Gummy Bears straight up]"                                                                                        
##  [33] "[Creepy Religious comics/Chick Tracts]"                                                                           
##  [34] "[Healthy Fruit]"                                                                                                  
##  [35] "[Heath Bar]"                                                                                                      
##  [36] "[Hershey’s Kissables]"                                                                                            
##  [37] "[Hershey’s Milk Chocolate]"                                                                                       
##  [38] "[Hugs (actual physical hugs)]"                                                                                    
##  [39] "[Jolly Rancher (bad flavor)]"                                                                                     
##  [40] "[Jolly Ranchers (good flavor)]"                                                                                   
##  [41] "[Kale smoothie]"                                                                                                  
##  [42] "[Kinder Happy Hippo]"                                                                                             
##  [43] "[Kit Kat]"                                                                                                        
##  [44] "[Hard Candy]"                                                                                                     
##  [45] "[Lapel Pins]"                                                                                                     
##  [46] "[LemonHeads]"                                                                                                     
##  [47] "[Licorice]"                                                                                                       
##  [48] "[Licorice (not black)]"                                                                                           
##  [49] "[Lindt Truffle]"                                                                                                  
##  [50] "[Lollipops]"                                                                                                      
##  [51] "[Mars]"                                                                                                           
##  [52] "[Mary Janes]"                                                                                                     
##  [53] "[Maynards]"                                                                                                       
##  [54] "[Milk Duds]"                                                                                                      
##  [55] "[LaffyTaffy]"                                                                                                     
##  [56] "[Minibags of chips]"                                                                                              
##  [57] "[JoyJoy (Mit Iodine)]"                                                                                            
##  [58] "[Reggie Jackson Bar]"                                                                                             
##  [59] "[Pixy Stix]"                                                                                                      
##  [60] "[Nerds]"                                                                                                          
##  [61] "[Nestle Crunch]"                                                                                                  
##  [62] "[Now'n'Laters]"                                                                                                   
##  [63] "[Pencils]"                                                                                                        
##  [64] "[Milky Way]"                                                                                                      
##  [65] "[Reese’s Peanut Butter Cups]"                                                                                     
##  [66] "[Tolberone something or other]"                                                                                   
##  [67] "[Runts]"                                                                                                          
##  [68] "[Junior Mints]"                                                                                                   
##  [69] "[Senior Mints]"                                                                                                   
##  [70] "[Mint Kisses]"                                                                                                    
##  [71] "[Mint Juleps]"                                                                                                    
##  [72] "[Mint Leaves]"                                                                                                    
##  [73] "[Peanut M&M’s]"                                                                                                   
##  [74] "[Regular M&Ms]"                                                                                                   
##  [75] "[Mint M&Ms]"                                                                                                      
##  [76] "[Ribbon candy]"                                                                                                   
##  [77] "[Rolos]"                                                                                                          
##  [78] "[Skittles]"                                                                                                       
##  [79] "[Smarties (American)]"                                                                                            
##  [80] "[Smarties (Commonwealth)]"                                                                                        
##  [81] "[Chick-o-Sticks (we don’t know what that is)]"                                                                    
##  [82] "[Spotted Dick]"                                                                                                   
##  [83] "[Starburst]"                                                                                                      
##  [84] "[Swedish Fish]"                                                                                                   
##  [85] "[Sweetums]"                                                                                                       
##  [86] "[Those odd marshmallow circus peanut things]"                                                                     
##  [87] "[Three Musketeers]"                                                                                               
##  [88] "[Peterson Brand Sidewalk Chalk]"                                                                                  
##  [89] "[Peanut Butter Bars]"                                                                                             
##  [90] "[Peanut Butter Jars]"                                                                                             
##  [91] "[Trail Mix]"                                                                                                      
##  [92] "[Twix]"                                                                                                           
##  [93] "[Vicodin]"                                                                                                        
##  [94] "[White Bread]"                                                                                                    
##  [95] "[Whole Wheat anything]"                                                                                           
##  [96] "[York Peppermint Patties]"                                                                                        
##  [97] "Please leave any remarks or comments regarding your choices."                                                     
##  [98] "Please list any items not included above that give you JOY."                                                      
##  [99] "Please list any items not included above that give you DESPAIR."                                                  
## [100] "Guess the number of mints in my hand."                                                                            
## [101] "Betty or Veronica?"                                                                                               
## [102] "Check all that apply: \"I cried tears of sadness at the end of  ____________\""                                   
## [103] "\"That dress* that went viral early this year - when I first saw it, it was ________\""                           
## [104] "Fill in the blank: \"Taylor Swift is a force for ___________\""                                                   
## [105] "What is your favourite font?"                                                                                     
## [106] "If you squint really hard, the words \"Intelligent Design\" would look like."                                     
## [107] "Fill in the blank: \"Imitation is a form of ____________\""                                                       
## [108] "Please estimate the degree(s) of separation you have from the following celebrities [JK Rowling]"                 
## [109] "Please estimate the degree(s) of separation you have from the following celebrities [JJ Abrams]"                  
## [110] "Please estimate the degree(s) of separation you have from the following celebrities [Beyoncé]"                    
## [111] "Please estimate the degree(s) of separation you have from the following celebrities [Bieber]"                     
## [112] "Please estimate the degree(s) of separation you have from the following celebrities [Kevin Bacon]"                
## [113] "Please estimate the degree(s) of separation you have from the following celebrities [Francis Bacon (1561 - 1626)]"
## [114] " [Sea-salt flavored stuff, probably chocolate, since this is the \"it\" flavor of the year]"                      
## [115] "[Necco Wafers]"                                                                                                   
## [116] "Which day do you prefer, Friday or Sunday?"                                                                       
## [117] "Please estimate the degrees of separation you have from the following folks [Bruce Lee]"                          
## [118] "Please estimate the degrees of separation you have from the following folks [JK Rowling]"                         
## [119] "Please estimate the degrees of separation you have from the following folks [Malala Yousafzai]"                   
## [120] "Please estimate the degrees of separation you have from the following folks [Thom Yorke]"                         
## [121] "Please estimate the degrees of separation you have from the following folks [JJ Abrams]"                          
## [122] "Please estimate the degrees of separation you have from the following folks [Hillary Clinton]"                    
## [123] "Please estimate the degrees of separation you have from the following folks [Donald Trump]"                       
## [124] "Please estimate the degrees of separation you have from the following folks [Beyoncé Knowles]"
```


