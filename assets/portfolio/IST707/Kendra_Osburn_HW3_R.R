## ---- STEP ONE: IMPORT ----
## IMPORT LIBRARIES AND DATA

## 1A: IMPORT LIBRARIES -- The libraries for Association Rule Mining were added to the script.
library(plyr)
library(dplyr)
library(arules)
library(arulesViz)

## 1B: IMPORT DATA -- Then the data was read in from the csv file and examined using the structure function.
bankdata = read.csv("/Users/kosburn/Desktop/bankdata.csv")
## 1C: EXAMINE DATA -- The original data was examined for structure 
str(bankdata)
head(bankdata)

## ---- STEP TWO: CLEAN ----
## 2A: REMOVE UNNECESSARY DATA -- Before the data can be analyzed, it needs to be cleaned.
## 2AiL Remove ID
## -- Testing first
bankdataTest <- bankdata[,-1]
bankdata <- bankdata[,-1]

## 2B: DISCRETIZE
## 2Bi: Descretize Age
## -- Testing first
bankdataTest$age <- cut(bankdata$age, breaks = c(0,10,20,30,40,50,60,Inf),
                        labels=c("child","teens","twenties","thirties","fourties","fifties","old"))
## Hooray that works! Now for real...
bankdata$age <- cut(bankdata$age, breaks = c(0,10,20,30,40,50,60,Inf),
                    labels=c("child","teens","twenties","thirties","fourties","fifties","old"))

## 2Bii: Descretize Income into three categories
min_income <- min(bankdata$income)
max_income <- max(bankdata$income)
bins = 3 
width=(max_income - min_income)/bins;
bankdataTest$income = cut(bankdata$income, breaks=seq(min_income, max_income, width),
                          labels=c("lowIncome", "midIncome", "highIncome"))
## Hooray that works! Now for real...
bankdata$income = cut(bankdata$income, breaks=seq(min_income, max_income, width),
                      labels=c("lowIncome", "midIncome", "highIncome"))

## 2C: CONVERT
## 2Ci: Convert children from numeric to nominal 
## -- Testing first
bankdataTest$children <- factor(bankdata$children)
## Hooray that works! Now for real...
bankdata$children <- factor(bankdata$children)

## 2D: REMOVE NAs
## Almost forgot to do this!!
## Test for NAs
(sum(is.na(bankdata)))
## There is one NA
## Test it
bankdataTest <- bankdata[complete.cases(bankdata),]
## Hooray that works! Now for real...
bankdata <- bankdata[complete.cases(bankdata),]
## Triple confirming
(sum(is.na(bankdata)))


## ---- STEP THREE: DO THE THING ----
## ATTEMPT (INITIAL)
bankRules = apriori(bankdata, parameter = list(supp = 0.001, conf = 0.9, maxlen = 3))
options(digits=2)
inspect(bankRules[1:40])
rulesByLift <- head(sort(bankRules, by="lift"), 10)        
plot(rulesByLift, method="graph", interactive=TRUE)
inspect(rulesByLift)

## ATTEMPT TWO
## Changing confidence from 0.9 to 1
bankRulesTwo = apriori(bankdata, parameter = list(supp = 0.001, conf = 1, maxlen = 3))
options(digits=2)
rulesByLiftTwo <- head(sort(bankRulesTwo, by="lift"), 10)        
inspect(rulesByLiftTwo)

## ATTEMPT THREE
## Changing support > 0.001 to 0.01
bankRulesThree = apriori(bankdata, parameter = list(supp = 0.01, conf = 1, maxlen = 3))
options(digits=2)
rulesByLiftThree <- head(sort(bankRulesThree, by="lift"), 10)        
inspect(rulesByLiftThree)

## ATTEMPT FOUR
## -- Changed maxlen
bankRulesFour = apriori(bankdata, parameter = list(supp = 0.01, conf = 1, maxlen = 4))
options(digits=2)
rulesByLiftFour <- head(sort(bankRulesFour, by="lift"), 10)        
inspect(rulesByLiftFour)

## ATTEMPT FIVE
## -- Changed support > 0.01 to 0.1
bankRulesFive = apriori(bankdata, parameter = list(supp = 0.1, conf = 1, maxlen = 4))
options(digits=2)
rulesByLiftFive <- head(sort(bankRulesFive, by="lift"), 10)        
inspect(rulesByLiftFive)

## ATTEMPT FIVE
## -- Changed support > 0.01 to 0.1
bankRulesFive = apriori(bankdata, parameter = list(supp = 0.1, conf = 1, maxlen = 4))
options(digits=2)
rulesByLiftFive <- head(sort(bankRulesFive, by="lift"), 10)        
inspect(rulesByLiftFive)
plot(rulesByLiftFive, method="graph", interactive=TRUE)

## ATTEMPT SIX
## -- Changed support > 0.1 to 0.05
bankRulesSix = apriori(bankdata, parameter = list(supp = 0.05, conf = 1, maxlen = 3))
options(digits=2)
rulesByLiftSix <- head(sort(bankRulesSix, by="lift"), 10)        
inspect(rulesByLiftSix)

## ATTEMPT SEVEN
## -- Changed CONFIDENCE > 1 to 0.9
bankRulesSeven = apriori(bankdata, parameter = list(supp = 0.1, conf = 0.9, maxlen = 3))
options(digits=2)
rulesByLiftSeven <- head(sort(bankRulesSeven, by="lift"), 10)        
inspect(rulesByLiftSeven)

## I SHOULD REALLY WRITE MYSELF A LOOP LOL

## ATTEMPT EIGHT
## -- Changed CONFIDENCE > 0.9 to 0.2
bankRulesEight = apriori(bankdata, parameter = list(supp = 0.01, conf = 0.2, maxlen = 3))
options(digits=2)
rulesByLiftEight <- head(sort(bankRulesEight, by="lift"), 10)        
inspect(rulesByLiftEight)
plot(rulesByLiftEight, method="graph", interactive=TRUE)

## ATTEMPT NINE
## -- Changed CONFIDENCE > 0.9 to 0.2
bankRulesNine = apriori(bankdata, parameter = list(supp = 0.01, conf = 1, maxlen = 3))
options(digits=2)
rulesByLiftNine <- head(sort(bankRulesNine, by="lift"), 10)        
inspect(rulesByLiftNine)


## MOVE PEP TO RHS
## ATTEMPT  ONE: supp = 0.001, conf = 1, maxlen = 4
## ATTEMPT TWO: supp = 0.01, conf = .9, maxlen = 2
suppVar <- 0.03
confVar <- 1
maxlenVar <- 4
rulesRightPep <- apriori(bankdata, parameter = list(supp = suppVar, conf = confVar, maxlen = maxlenVar), 
                         appearance = list (default = "lhs", rhs="pep=YES"),control=list(verbose=F))

options(digits=2)
## Inspect ALL the things!!
inspect(rulesRightPep)
## Sort by LIFT
rulesRightPepByLift <- head(sort(rulesRightPep, by="lift"), 100)  
inspect(rulesRightPepByLift)
## Sort by Support
rulesRightPepBySupp <- head(sort(rulesRightPep, by="supp"), 20)  
inspect(rulesRightPepBySupp)
## Sort by Confidence
rulesRightPepBySupp <- head(sort(rulesRightPep, by="conf"), 20)  
inspect(rulesRightPepBySupp)

plot(rulesRightPepByLift2[1:10],method="graph",interactive=TRUE,shading=NA)

## TRYING TO FIND WHO NOT TO TARGET
## PEP = NO
suppVar <- 0.001
confVar <- 0.7
maxlenVar <- 2
rulesRightPep <- apriori(bankdata, parameter = list(supp = suppVar, conf = confVar, maxlen = maxlenVar), 
                         appearance = list (default = "lhs", rhs="pep=NO"),control=list(verbose=F))

options(digits=2)
## Inspect ALL the things!!
inspect(rulesRightPep)
## Sort by LIFT
rulesRightPepByLift <- head(sort(rulesRightPep, by="lift", decreasing = TRUE), 100)  
inspect(rulesRightPepByLift)
## Sort by Support
rulesRightPepBySupp <- head(sort(rulesRightPep, by="supp"), 20)  
inspect(rulesRightPepBySupp)
## Sort by Confidence
rulesRightPepBySupp <- head(sort(rulesRightPep, by="conf"), 20)  
inspect(rulesRightPepBySupp)

## RESULTS
plot(rulesRightPepByLift2[1:4],method="graph",interactive=TRUE,shading=NA)

## RULE 1
suppVar <- 0.01
confVar <- 0.7
maxlenVar <- 2

## RULE 2
suppVar <- 0.01
confVar <- 0.9
maxlenVar <- 3

## RULE 3

## RULE 4

## RULE 5
## DON'T FORGET TO SWITCH the rhs to "pep=no"
suppVar <- 0.001
confVar <- 0.7
maxlenVar <- 2

rulesRightPep <- apriori(bankdata, parameter = list(supp = suppVar, conf = confVar, maxlen = maxlenVar), 
                         appearance = list (default = "lhs", rhs="pep=NO"),control=list(verbose=F))

