

library(tidyverse)  # data manipulation
library(cluster)    # clustering algorithms
library(factoextra) # clustering visualization
library(dendextend) # for comparing two dendrograms

fpcsv <- read.csv("/Users/kosburn/syracuse/IST707/fedPapers85_withHM.csv", header = TRUE, sep=",")
fpcsv <- na.omit(fpcsv)
head(fpcsv)

## saving author name in vector called names
author <- fpcsv$author

## changing row names to author name
row.names(fpcsv) <- author

#@ removing author column
fpcsv <- fpcsv[,-1]

#@ removing filename column
fpcsv <- fpcsv[,-1]

## ceating 5 clusters
## you can tell that I'm dead inside because there are no excited comments
fpcsv5 <- kmeans(fpcsv, centers = 8, nstart = 30)
fviz_cluster(fpcsv5, data = fpcsv)

## this is when I started to explore cosine
## it didn't give me nearly as nice of a visual 
## which is indication that in a dream world I would have started this part 
## of the exploratory analysis earlier
## commenting this part out so the rest runs

#df = fpcsv
#cosine <- dist(df, method = "cosine")
#cosKmeans <- kmeans(cosine, 3)
#fviz_cluster(cosKmeans, data = fpcsv)

## yet again, I'm left with an assignment I am so excited about
## yet so disappointed in what I'm turning in
## I don't know how to show all the other work I did
## and I try a new tactic each week for writing the paper
## in hopes I will get a system down so I'm not always doing this at 4am

