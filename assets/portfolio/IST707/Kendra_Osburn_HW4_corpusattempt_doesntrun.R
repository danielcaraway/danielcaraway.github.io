## ------------------------------------------------------------------
## STEP 1: IMPORT ALL THE THINGS
##-------------------------------------------------------------------
library(wordcloud)
library(tm)
library(slam)
library(quanteda)
library(SnowballC)
library(arules)
library(proxy)


## ------------------------------------------------------------------
## STEP 2: IMPORT THE DATA... AS A CORPUS
##-------------------------------------------------------------------
## I have to google this every time and I hate myself
setwd("/Users/kosburn/syracuse/IST707")
## Load the data
## Name it something meaningful yet short
TheFedCorpus <- Corpus(DirSource("FedPapersCorpusNoJay"))

## ------------------------------------------------------------------
## STEP 3: CLEAN THE CORPUS (NOT CLEAN THE CORPSE)
##-------------------------------------------------------------------
## ++ remove punctuation
## ++ transfer to lower case
## ++ remove stopwords (but also keep a copy of one with stopwords)
CleanFedCorpus <- tm_map(TheFedCorpus, removePunctuation)
CleanFedCorpus <- tm_map(CleanFedCorpus, content_transformer(tolower))
CleanFedCorpusWithStopwords <- CleanFedCorpus
MyStopwords <- stopwords(kind = "en")
CleanFedCorpus <- tm_map(CleanFedCorpus, removeWords, MyStopwords)

## ------------------------------------------------------------------
## STEP 4: TURN INTO CSV AS BACKUP
##-------------------------------------------------------------------
CleanFedCorpusDataframe <- data.frame(text=sapply(CleanFedCorpus, identity), stringsAsFactors=F)
write.csv(CleanFedCorpusDataframe, "CleanFedCorpusoutput.csv")


fedcsv = read.csv("/Users/kosburn/syracuse/IST707/CleanFedCorpusoutput.csv")
fedcsvDF <- data.frame(fedcsv)


## ------------------------------------------------------------------
## STEP 2 (Again): GIVE UP AND USE THE CSV
##-------------------------------------------------------------------
fedcsv = read.csv("/Users/kosburn/syracuse/IST707/CleanFedCorpusoutput.csv")
fedcsvDF <- data.frame(fedcsv)



## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Bachelor Funny Corpus
TheBachCorpus <- Corpus(DirSource("bachelor"))
CleanBachCorpus <- tm_map(TheBachCorpus, removePunctuation)

inspect(CleanCorpus)
inspect(CleanFedCorpus)
inspect(CleanBachCorpus)

## ------------------------------------------------------------------
## STEP 1.5 SAVE FOR LATER
##-------------------------------------------------------------------
CleanCorpusDataframe <- data.frame(text=sapply(CleanCorpus, identity), stringsAsFactors=F)
write.csv(CleanCorpusDataframe, "Corpusoutput.csv")
CleanFedCorpusDataframe <- data.frame(text=sapply(CleanFedCorpus, identity), stringsAsFactors=F)
write.csv(CleanFedCorpusDataframe, "FedCorpusoutput.csv")
CleanBachCorpusDataframe <- data.frame(text=sapply(CleanBachCorpus, identity), stringsAsFactors=F)
write.csv(CleanBachCorpusDataframe, "BachCorpusoutput.csv")

## ------------------------------------------------------------------
## STEP 2 ATTEMPT THE CORPUS WAY
##-------------------------------------------------------------------

CleanFedCorpusTDM <- TermDocumentMatrix(CleanFedCorpus)
inspect(CleanFedCorpusTDM)
CleanFedCorpusTDMasDF <- as.data.frame(inspect(CleanFedCorpusTDM))

## Saving this strange thing for later
CleanFedCorpusTDMasDFSmallWords <- as.data.frame(inspect(CleanFedCorpusTDM))



(CdataframeB <- data.frame(text=sapply(CleanBachelorCorpus, identity), 
                           stringsAsFactors=F))
(MyTDMB <- TermDocumentMatrix(CleanBachelorCorpus))
inspect(MyTDMB)


## ------------------------------------------------------------------
## STEP 2 AGAIN: PANIC AND ATTEMPT THE CSV WAY
##-------------------------------------------------------------------

FedCSV <- 
  
  
findFreqTerms(MyTDM, 1)
findFreqTerms(MyTDMB, 1)

## FOR WORK
findAssocs(MyTDM, 'human', 0.20)

## FOR PLAY
findAssocs(MyTDMB, 'amazing', 0.20)


## FOR WORK
CleanDF <- as.data.frame(inspect(MyTDM))
(CleanDF)
CleanDFScale <- scale(CleanDF)
d <- dist(CleanDFScale,method="euclidean")
fit <- hclust(d, method="ward.D2")
plot(fit)


myStopwords <- stopwords(kind = "en")
myBachCorpus <- removeWords(MyTDMB, myStopwords)

NormalizedTDM <- TermDocumentMatrix(CleanBachelorCorpus, control = list(weighting = weightTfIdf, stopwords = FALSE))
inspect(NormalizedTDM)

## Visualize normalized DTM
## The dendrogram:
## Terms higher in the plot appear more frequently within the corpus
## Terms grouped near to each other are more frequently found together
CleanDF_N <- as.data.frame(inspect(NormalizedTDM))
CleanDFScale_N <- scale(CleanDF_N )
d <- dist(CleanDFScale_N,method="euclidean")
fit <- hclust(d, method="ward.D2")
rect.hclust(fit, k = 4) # cut tree into 4 clusters 
plot(fit)

## Wordcloud
inspect(MyTDMB)


stopwords(kind = "en")


stopwords = readLines('stopwords.txt')     #Your stop words file
x  = df$company        #Company column data
x  =  removeWords(x,stopwords)     #Remove stopwords

df$company_new <- x  