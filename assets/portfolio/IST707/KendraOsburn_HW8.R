## IST 707 | HW 8 | WEEK 9 | TEXT MINING 
## ====================================
## STEP 1: IMPORT LIBRARIES & DATA
## ====================================
library(tm)
library(wordcloud)
library(tidyr)
library(tidytext)
library(dplyr)
setwd("/Users/kosburn 1/syracuse/IST707/WK9")
file <- "deception_data_converted.csv"
fileData <- read.csv(file)
str(fileData)
og_fileData <- fileData

fileData <- tidyr::unite(fileData, review, c("review", "X", "X.1", "X.2", "X.3", "X.4", "X.5", "X.6", "X.7", "X.8", "X.9", "X.10", "X.11", "X.12", "X.13", "X.14", "X.15", "X.16", "X.17", "X.18", "X.19", "X.20"))

## ====================================
## STEP 2: TURN DATA INTO CORPUS
## ====================================
## 2i.TURN VARIABLE INTO A CORPUS "BAG OF WORDS" 
## 2ia. FIRST VECTOR, THEN CORPUS
## (corpus needs a vector to make corpus)

reviews <- fileData$review
words.vec <- VectorSource(reviews)
words.corpus <- Corpus(words.vec)
words.corpus

## ====================================
## STEP 3: TRANSFORM DATA
## ====================================
## 3i. TRANSFORM ALL WORDS TO LOWERCASE
words.corpus <- tm_map(words.corpus, content_transformer(tolower))
## 3ii. REMOVE PUNCTUATION
words.corpus <- tm_map(words.corpus, removePunctuation)
## 3iii. REMOVE NUMBERS
words.corpus <- tm_map(words.corpus, removeNumbers)
## 3iv. REMOVE STOPWORDS
words.corpus <- tm_map(words.corpus, removeWords, stopwords("english"))

## ====================================
## STEP 4: CREATE TERM-DOCUMENT MATRIX
## ====================================
## WHAT IS A TERM? TERM = DIFFERENT WORD
tdm <- TermDocumentMatrix(words.corpus)
tdmOG <- TermDocumentMatrix(words.corpus)

## ====================================
## STEP 5:VIEW WORD CLOUD & SEE FREQ
## ====================================
## FOR TDM
m <- as.matrix(tdm)
wordCounts <- rowSums(m)
wordCounts <- sort(wordCounts, decreasing=TRUE)
head(wordCounts)
wordcloud(names(wordCounts), wordCounts)
wordcloud(names(wordCounts), wordCounts, min.freq=2, max.words=50, rot.per=0.35, colors=brewer.pal(8, "Dark2"))

findAssocs(tdm, "food", 0.4)

## ====================================
## STEP 6: Create DTM
## ====================================

## Create DTM
dtm_reviews <- t(tdmOG)
matrix_reviews <- as.matrix(dtm_reviews)

df_reviews <- tidy(matrix_reviews)

df_reviews_normalized <- data.frame(t(apply(df_reviews, 1, function(i) i/sum(i))))


## NON NORMALIZED TEST AND TRAIN
## TURN BACK INTO A MATRIX 
lie <- fileData$lie
sentiment <- fileData$sentiment
alldata <-cbind(lie, sentiment, df_reviews)
alldata <- alldata[-c(83:84),]

alldata_lie_true_sentiment_positive <- subset(alldata, lie == 't' & sentiment =='p')
alldata_lie_true_sentiment_negative <- subset(alldata, lie == 't' & sentiment =='n')
alldata_lie_false_sentiment_positive <- subset(alldata, lie == 'f' & sentiment =='p')
alldata_lie_false_sentiment_negative <- subset(alldata, lie == 'f' & sentiment =='n')

## Ali's amaze functions!!
#Creating a function to create a training df 
my_sample_fun <- function(df, n) { 
  sample(nrow(df), n)
}

#Creating a function to create a training df 
my_train_set <- function(df, vector) { 
  df[vector,]
}

#Creating a function to create a testing df 
my_test_set <- function(df, vector, n) {
  df <- df[-vector,]
  df[sample(nrow(df), n),]
}

sample_lie_true_sentiment_positive <- my_sample_fun(alldata_lie_true_sentiment_positive, 15)
train_lie_true_sentiment_positive <- my_train_set(alldata_lie_true_sentiment_positive, sample_lie_true_sentiment_positive)
test_lie_true_sentiment_positive <- my_test_set(alldata_lie_true_sentiment_positive, sample_lie_true_sentiment_positive, 6)

sample_lie_true_sentiment_negative <- my_sample_fun(alldata_lie_true_sentiment_negative, 15)
train_lie_true_sentiment_negative <- my_train_set(alldata_lie_true_sentiment_negative, sample_lie_true_sentiment_negative)
test_lie_true_sentiment_negative <- my_test_set(alldata_lie_true_sentiment_negative, sample_lie_true_sentiment_negative, 6)

sample_lie_false_sentiment_positive <- my_sample_fun(alldata_lie_false_sentiment_positive, 15)
train_lie_false_sentiment_positive <- my_train_set(alldata_lie_false_sentiment_positive, sample_lie_false_sentiment_positive)
test_lie_false_sentiment_positive <- my_test_set(alldata_lie_false_sentiment_positive, sample_lie_false_sentiment_positive, 6)

sample_lie_false_sentiment_negative <- my_sample_fun(alldata_lie_false_sentiment_negative, 15)
train_lie_false_sentiment_negative <- my_train_set(alldata_lie_false_sentiment_negative, sample_lie_false_sentiment_negative)
test_lie_false_sentiment_negative <- my_test_set(alldata_lie_false_sentiment_negative, sample_lie_false_sentiment_negative, 6)


##############################################
## RUN MODELS: Naive Bayes
##############################################
library(e1071)

train_set <- rbind(train_lie_true_sentiment_positive, train_lie_true_sentiment_negative, train_lie_false_sentiment_positive, train_lie_false_sentiment_negative)
test_set <- rbind(test_lie_true_sentiment_positive, test_lie_true_sentiment_negative, test_lie_false_sentiment_positive, test_lie_false_sentiment_negative)

train_set_lie <- train_set[,!colnames(train_set) %in% c('sentiment')]
test_set_lie <- test_set[,!colnames(test_set) %in% c('sentiment')]

train_set_sentiment <- train_set[,!colnames(train_set) %in% c('lie')]
test_set_sentiment <- test_set[,!colnames(test_set) %in% c('lie')]

##********************************************
## LIE
##********************************************
train_set <- train_set_lie
test_set <- test_set_lie

test_label <- c('lie')
test_set_no_label <- test_set[,!colnames(test_set) %in% test_label]

NB_e1071<-naiveBayes(lie~., data=train_set, na.action = na.pass)
NB_e1071_Pred <- predict(NB_e1071, test_set_no_label)
(pred_table <- table(NB_e1071_Pred,test_set$lie))
correct <- sum(diag(pred_table))
(accuracy <- correct/sum(pred_table))

##********************************************
## SENTIMENT
##********************************************
train_set <- train_set_sentiment
test_set <- test_set_sentiment

test_label <- c('sentiment')
test_set_no_label <- test_set[,!colnames(test_set) %in% test_label]
test_sentiment_lie_label <- test_set[,colnames(test_set) %in% test_label]

NB_e1071<-naiveBayes(sentiment~., data=train_set, na.action = na.pass)
NB_e1071_Pred <- predict(NB_e1071, test_set_no_label)
(pred_table <- table(NB_e1071_Pred,test_set$sentiment))
correct <- sum(diag(pred_table))
(accuracy <- correct/sum(pred_table))

## NEED TWO TRAINING
## NEED ONE TEST

