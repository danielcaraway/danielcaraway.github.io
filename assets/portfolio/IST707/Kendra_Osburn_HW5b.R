## ====================================
## STEP 1: INSTALL PACKAGES
## ====================================

library(RWeka)

## ====================================
## STEP 2: LOAD DATA
## ====================================

trainset <- read.csv("/Users/kosburn/syracuse/IST707/WK5/fedTRAINSET3.csv", header = TRUE, sep=",")
testset <- read.csv("/Users/kosburn/syracuse/IST707/WK5/fedTESTSET3.csv", header = TRUE, sep=",")


## ====================================
## STEP 3: PREPROCESS DATA 
## ====================================

## 3ai. Make a weka filter to transform a datatype from numeric to nominal
NN <- make_Weka_filter("weka/filters/unsupervised/attribute/NumericToNominal")

## 3aii. Apply filter to both data sets
trainset <- NN(data=trainset, control= Weka_control(R="1-3"), na.action = NULL)
testset <- NN(data=testset, control= Weka_control(R="1,3"), na.action = NULL)

## 3bi. Make a weka filter to replace missing values
MS <- make_Weka_filter("weka/filters/unsupervised/attribute/ReplaceMissingValues") 

## 3bii. Apply filter to both data sets
trainset <- MS(data=trainset, na.action=NULL)
testset <- MS(data=testset, na.action=NULL)

## 3c. Check data
str(trainset)
head(trainset)
## ====================================
## STEP 4: APPLY J48 ALGORITHM 
## ====================================

## 4a. Build decision tree model
m = J48(author~., data=trainset)
m = J48(author~., data=trainset, control=Weka_control(U=FALSE, M=2, C=0.5))

## Experimented with this
plot(m)
## Totally unhelpful

## 4b. View parameters
WOW("J48")

## 4ci. Use 10 fold cross validation to evaluate the model
e <- evaluate_Weka_classifier(m, numFolds = 10, seed = 1, class = TRUE)

## 4cii. View
e


## ====================================
## STEP 5: APPLY MODEL TO TEST DATASET 
## ====================================

pred = predict(m, newdata=testset, type=c("class"))
dfPred <- data.frame(pred)
pred

## Then save to a csv
write.csv(pred, file="/Users/kosburn/syracuse/IST707/WK5/fed-pred.csv")

## ====================================
## STEP 6: VIEW NEXT TO WHAT WE KNOW
## ====================================

testwithanswers <- read.csv("/Users/kosburn/syracuse/IST707/WK5/fedTESTwithanswers.csv", header = TRUE, sep=",")
head(testwithanswers)

dfCompare <- data.frame(testwithanswers[,1], dfPred[,1])
View(dfCompare[,2])

## MORE COLOR PLEASE!!
library(DT)



datatable(dfCompare, rownames = FALSE) %>%
  formatStyle(columns = "testwithanswers...1.", 
              background = styleEqual(c('Madison', 'Hamilton'), c("lightblue", "teal"))) %>%
  formatStyle(columns = "dfPred...1.", 
            background = styleEqual(c('Madison', 'Hamilton'), c("lightblue", "teal")))

## Annnnd I spent waaaay too muhc time doing that and it's not even that pretty.  
