#########################################################
######### Team Project Exploratory Analysis #############
######### Ali Ho, Kendra Osburn, James Robertson ########
#########################################################
library(ggplot2)
library(tidyverse)
library(plyr)
library(reshape2)
library(Metrics)
library(gridExtra)
library(grid)
library(lattice)
library(tm)
library(e1071)
library(arules)

#Setting working directory to my computer IST 707 Team Project
setwd("C:\\Users\\ho511\\Desktop\\IST 707\\Team Project\\CSVs")

#Reading in the Movies Spreadsheet 
movies <- read.csv("movies.csv", header = TRUE)

### KENDRA GETTING THE FILE & prepping for later loop
#filename <- paste(kpath, "movies.csv", sep='')
#movies <- read.csv(filename, header = TRUE)

movies = format(movies, scientific = FALSE)

#Getting the structure of the dataset 
str(movies)

#Need to change budget, runtime, score, votes, gross to numeric
movies$budget = as.numeric(movies$budget)
movies$runtime = as.numeric(movies$runtime)
movies$score = as.numeric(movies$score)
movies$votes = as.numeric(movies$votes)
movies$gross = as.numeric(movies$gross)

#Need to change country, director, genre, rating, star, writer to factor 
movies$country = as.factor(movies$country)
movies$director = as.factor(movies$director)
movies$genre = as.factor(movies$genre)
movies$rating = as.ordered(movies$rating)
movies$star = as.factor(movies$star)
movies$writer = as.factor(movies$writer)
movies$released = as.factor(movies$released)

#Might want to remove the name of the movie
#Might want to break date up just month, since there is already a column for year

#Checking for missing values 
sum(is.na(movies))
#There are 10 missing values 

#Once we lower our df, we will recheck to see if the missing values are still there 

#Removing the movies whose budget was listed as 0 
movies <- subset(movies, budget !=0)

#Removing the company attribute 
movies <- movies[,-2]

#Changing the data type of released from factor to date 
movies$released <- as.Date(movies$released, format = "%m/%d/%Y")

#Since we already have a column for year we are going to extract the month 
#the movie was released 
a <- movies$released
a <- substring(a, 6,7)
month <- a
movies$released <- as.ordered(month)

#Getting a subset of only movies produced in the USA 
moviesUS <- subset(movies, country == "USA")
moviesUS$country = factor(moviesUS$country)

sum(is.na(moviesUS))

#There are still 7 missing values in the df 

#Creating a df for movies based on genre 
actionUSA <- subset(moviesUS, genre == "Action")
actionUSA$genre = factor(actionUSA$genre)

#Getting a subset of of stars  
library(dplyr)
starCount <- as.data.frame(tally(group_by(moviesUS, star)))

#Creating a df of stars with their counts who appear in 5 or more movies 
prolificStars <- subset(starCount, n >= 5)

#Creating a subset of directors who have 5 movies or more 
directorCount <- as.data.frame(tally(group_by(moviesUS, director)))

#Creating a df of directors with their counts who direct 5 or more movies 
prolificDirectors <- subset(directorCount, n >= 5)
prolificDirectors 

#Creating a list of writers who by their counts 
writerCount <- as.data.frame(tally(group_by(moviesUS, writer)))

#Creating a df of writers with their counts who wrote 5 or more movies 
prolificWriters <- subset(writerCount, n >= 5)

#Attempting to keep all of the movies with the prolific stars only 
keep <- prolificStars$star

test <- subset(moviesUS, star %in% keep)
test$star = factor(test$star)
test$director = factor(test$director)
test$writer = factor(test$writer)

#Now lowering the amount of directors 
keep <- prolificDirectors$director
test <- subset(test, director %in% keep)

#This dataframe has 989 obs of 14 variables 
#There are 189 directors 
#There are 190 stars 
#There are still 702 writers... Maybe we could remove the writers? 

test$profit <- (test$gross - test$budget)
test$director = factor(test$director)


moviesUSA <- data.frame(test)
moviesUSA$gross = format(moviesUSA$gross, scientific = FALSE)
moviesUSA$budget = format(moviesUSA$budget, scientific = FALSE)

str(moviesUSA)

#Need to change year to a factor 
moviesUSA$year = as.ordered(moviesUSA$year)

#Need to change gross to numeric 
moviesUSA$gross = as.numeric(moviesUSA$gross)
moviesUSA$budget = as.numeric(moviesUSA$budget)
str(moviesUSA)
summary(moviesUSA$budget)

sum(is.na(moviesUSA))

#The missing values were removed as we narrowed down our dataset 

#Making a percent profit column as comparing movies with 
#different budgets is not fair as the scale of profits will be different 
moviesUSA$percProf <-(moviesUSA$profit/moviesUSA$budget)
moviesUSA$percProf <- round(moviesUSA$percProf, digits = 2)
moviesUSA$writer = factor(moviesUSA$writer)

str(moviesUSA)

#Removing the country column since all movies are in the US 
moviesUSA <- moviesUSA[,-2]

#Resaving the rating as an ordinal factor to make sure that we do not have any factors present that are not in our dataset
moviesUSA$rating = as.character(moviesUSA$rating)
moviesUSA$rating = as.ordered(moviesUSA$rating)

#Going to create a new df of columns that can be discretized and the columns that cannot be 
#Creating a discretized df 
library(arules)
quantile(moviesUSA$budget)
budgetDiscretize <- arules::discretize(moviesUSA$budget, method = "fixed", breaks = c(0, 23000000, 40000000, 73000000, Inf), labels = c("extremely low", "low", "high", "extremely high"))

quantile(moviesUSA$gross)
grossDiscretize <- arules::discretize(moviesUSA$gross, method = "fixed", breaks = c(-Inf, 24984868, 56451232, 106614100, Inf), labels = c("extremely low", "low", "high", "extremely high"))

quantile(moviesUSA$runtime)
runtimeDiscretize <- arules::discretize(moviesUSA$runtime, method = "fixed", breaks = c(0, 100, 125, Inf), labels = c("short", "average", "long")) 

quantile(moviesUSA$score)
scoreDiscretize <- arules::discretize(moviesUSA$score, method = "fixed", breaks = c(0, 6.1, 6.6, 7.2, Inf), labels = c("extremely low", "low", "high", "extremely high"))
scoreDiscretize2 <- arules::discretize(moviesUSA$score, method = "fixed", breaks = c(0, 6.1, Inf), labels = c("low", "high"))
table(moviesUSA$score, scoreDiscretize2)

quantile(moviesUSA$votes)
votesDiscretize <- arules::discretize(moviesUSA$votes, method = "fixed", breaks = c(0, 39651, 92803, 202934, Inf), labels = c("extremely low", "low", "high", "extremely high"))

quantile(moviesUSA$profit)
profitDiscretize <- arules::discretize(moviesUSA$profit, method = "fixed", breaks = c(-Inf, 0, 8608444, 47727583, Inf), labels = c("negative", "low", "medium", "high"))

percProfitDiscretize <- arules::discretize(moviesUSA$percProf, method = "fixed", breaks = c(-Inf, 0, 2, 4, 6, 8, 10, Inf), labels = c("negative", "0 - 2%", "2 - 4%", "4 - 6%", "7 - 8%", "8 - 10%", "10%+"))

moviesUSADiscretized <- data.frame(cbind(as.character(budgetDiscretize), as.character(grossDiscretize), 
                                         as.character(runtimeDiscretize), as.character(scoreDiscretize), 
                                         as.character(votesDiscretize), as.character(profitDiscretize), 
                                         as.character(percProfitDiscretize),
                                         as.character(moviesUSA$star), as.character(moviesUSA$director), 
                                         as.character(moviesUSA$genre), as.character(moviesUSA$name), 
                                         as.character(moviesUSA$rating), as.character(moviesUSA$released),
                                         as.character(moviesUSA$writer), as.character(moviesUSA$year)))

moviesUSADiscretized <- moviesUSADiscretized %>%
  mutate_all(as.factor)

colnames(moviesUSADiscretized) <- c("budget", "gross", "runtime", "score", "votes", "profit", "percProfit", "star", "director", 
                                    "genre", "title", "rating", "released", "writer", "year" )

#Chaning rating, year to an ordered factor 
moviesUSADiscretized$rating = as.ordered(moviesUSADiscretized$rating)
moviesUSADiscretized$year = as.ordered(moviesUSADiscretized$year)

#Writing the df to a csv 
write.csv(moviesUSADiscretized,'moviesUSADiscretized.csv')
write.csv(moviesUSA,'moviesUSA.csv')

################################################################################################################################################
#Exploring: Creating a data frame for just genre and year released 
genreYear <- data.frame(moviesUSA$genre, moviesUSA$year)
colnames(genreYear) <- c("genre", "year")

#melting 
genreYearMelt <- melt(genreYear, id.vars = "year")

ggplot(genreYearMelt, aes(x = year, y = variable, fill = value)) + geom_bar(stat = "identity")+ ylab("Amount of Movies") + ggtitle("Visualization of Movie Genres By Year") 

#Want to figure out how o get a frequency in there too 

year1986 <- subset(genreYear, year == 1986)
table(year1986$genre)
#1986 had 5 action movies, 7 comieds, 1 crime, 1 drame, 

year1987 <- subset(genreYear, year == 1987)
table(year1987$genre)
#1987 had 5 action, 1 biography, 3 comedy, 3 crime, 2 drama, 

year1988 <- subset(genreYear, year == 1988)
table(year1988$genre)
#1988 4 action, 2 biography, 14 comedy, 1 Crime, 3 drama 

year1989 <- subset(genreYear, year == 1989)
table(year1989$genre)

year1990 <- subset(genreYear, year == 1990)
table(year1990$genre)

year1991 <- subset(genreYear, year == 1991)
table(year1991$genre)

year1992 <- subset(genreYear, year == 1992)
table(year1992$genre)

year1993 <- subset(genreYear, year == 1993)
table(year1993$genre)

year1994 <- subset(genreYear, year == 1994)
table(year1994$genre)

year1995 <- subset(genreYear, year == 1995)
table(year1995$genre)

year1996 <- subset(genreYear, year == 1996)
table(year1996$genre)

year1997 <- subset(genreYear, year == 1997)
table(year1997$genre)


year1998 <- subset(genreYear, year == 1998)
table(year1998$genre)

year1999 <- subset(genreYear, year == 1999)
table(year1999$genre)

year2000 <- subset(genreYear, year == 2000)
table(year2000$genre)

year2001 <- subset(genreYear, year == 2001)
table(year2001$genre)

year2002 <- subset(genreYear, year == 2002)
table(year2002$genre)

year2003 <- subset(genreYear, year == 2003)
table(year2003$genre)

year2004 <- subset(genreYear, year == 2004)
table(year2004$genre)

year2005 <- subset(genreYear, year == 2005)
table(year2005$genre)

year2006 <- subset(genreYear, year == 2006)
table(year2006$genre)

year2007 <- subset(genreYear, year == 2007)
table(year2007$genre)

year2008 <- subset(genreYear, year == 2008)
table(year2008$genre)

year2009 <- subset(genreYear, year == 2009)
table(year2009$genre)

year2010 <- subset(genreYear, year == 2010)
table(year2010$genre)

year2011 <- subset(genreYear, year == 2011)
table(year2011$genre)

year2012 <- subset(genreYear, year == 2012)
table(year2012$genre)

year2013 <- subset(genreYear, year == 2013)
table(year2013$genre)

year2014 <- subset(genreYear, year == 2014)
table(year2014$genre)

year2015 <- subset(genreYear, year == 2015)
table(year2015$genre)

year2016 <- subset(genreYear, year == 2016)
table(year2016$genre)

#Reading in the genreYear Spreadsheet 
genreYear <- read.csv("genreYear.csv", header = TRUE, sep = ",")

#Fixing the column names 
colnames(genreYear) <- c("year", "genre", "frequency")

#Melting the genreYear 
genreYearMelt <- melt(genreYear, id=c("year", "frequency"))

genreYearGraph <- ggplot(genreYearMelt, aes(x = year, y = frequency, fill = value)) + geom_bar(stat = "identity")+ ylab("Number of Movies") + ggtitle("Visualization of Movie Genres By Year") 
genreYearGraph

#Creating a visualization of the stars and the movies they appear in 
finalStarCount <- as.data.frame(tally(group_by(moviesUSA, star)))

#Visualizing the stars and number of movies appeared in 
ggplot(finalStarCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Moives Per Star") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Stars")


#Creating a visualization of the directors and the movies they appear in 
finalDirectorCount <- as.data.frame(tally(group_by(moviesUSA, director)))

#Visualizinf the directors and number of movies appeared in 
ggplot(finalDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1))) + ggtitle("Visualization of Number of Moives Per Director") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Directors") 

#Creating a visualization of the genres and the number of movies represented 
finalGenreCount <- as.data.frame(tally(group_by(moviesUSA, genre)))

#Visualizing the genres and number of movies 
ggplot(finalGenreCount, aes(x = genre, y = n)) + geom_bar(stat = "identity", aes(fill = genre)) + ggtitle("Visualization of Number of Movies Per Genre") + theme(legend.position ="none") + xlab("Genre") + ylab("Number of Movies") 

#Creating a visualization of the spread of perc profit for the movies 
#using the discretized df for this visual 
ggplot(moviesUSADiscretized, aes(x = percProfitDiscretize)) + geom_bar(aes(fill = percProfitDiscretize)) + ggtitle("Visualization of Number of Percent Profit") + theme(legend.position ="none") + xlab("Percent Profit") + ylab("Number of Movies") 

#Creating a visualization of the spread of budget for the movies 
ggplot(moviesUSADiscretized, aes(x = budgetDiscretize)) + geom_bar(aes(fill = budgetDiscretize)) + ggtitle("Visualization of Movie Budget") + theme(legend.position ="none") + xlab("Budget") + ylab("Number of Movies") 

#Creating a visualization of the spread of gross for the movies 
ggplot(moviesUSADiscretized, aes(x = grossDiscretize)) + geom_bar(aes(fill = grossDiscretize)) + ggtitle("Visualization of Movie Gross") + theme(legend.position ="none") + xlab("Gross") + ylab("Number of Movies") 

#Could create a visual that is a scatter plot that shows the relationship between percent profit, budget gross 
ggplot(moviesUSA, aes(x = budget, y = profit, color = genre, size = percProf)) + geom_point()

#Creating a visualization of the writers and the movies they appear in 
finalWriterCount <- as.data.frame(tally(group_by(moviesUSA, writer)))
#Visualizing the genres and number of writers 
ggplot(finalWriterCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Moives Per Writer") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Writers")

#Creating a visualization of the writers and the movies they appear in 
finalWriterCount <- as.data.frame(tally(group_by(moviesUSA, writer)))
#Visualizing the genres and number of writers 
ggplot(finalWriterCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Moives Per Writer") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Writers")

#Runtime 
ggplot(moviesUSADiscretized, aes(x = runtimeDiscretize)) + geom_bar(aes(fill = runtimeDiscretize)) + ggtitle("Visualization of Movie Runtime") + theme(legend.position ="none") + xlab("Runtime") + ylab("Number of Movies") 

#Score 
ggplot(moviesUSADiscretized, aes(x = scoreDiscretize)) + geom_bar(aes(fill = scoreDiscretize)) + ggtitle("Visualization of Movie Score") + theme(legend.position ="none") + xlab("Score") + ylab("Number of Movies") 

#Votes 
ggplot(moviesUSADiscretized, aes(x = votesDiscretize)) + geom_bar(aes(fill = votesDiscretize)) + ggtitle("Visualization of Movie Votes") + theme(legend.position ="none") + xlab("Votes") + ylab("Number of Movies") 

#Visualizing the Gross, Budget, Number of Stars, Number of Directors, Number of Writers, percProf, runtime, score, votes by Genre 
actionDiscretized <- subset(moviesUSADiscretized, genre == "Action")
adventureDiscretized <- subset(moviesUSADiscretized, genre == "Adventure")
animationDiscretized <- subset(moviesUSADiscretized, genre == "Animation")
biographyDiscretized <- subset(moviesUSADiscretized, genre == "Biography")
comedyDiscretized <- subset(moviesUSADiscretized, genre == "Comedy")
crimeDiscretized <- subset(moviesUSADiscretized, genre == "Crime")
dramaDiscretized <- subset(moviesUSADiscretized, genre == "Drama")
fantasyDiscretized <- subset(moviesUSADiscretized, genre == "Fantasy")
horrorDiscretized <- subset(moviesUSADiscretized, genre == "Horror")
mysteryDiscretized <- subset(moviesUSADiscretized, genre == "Mystery")
scifiDiscretized <- subset(moviesUSADiscretized, genre == "Sci-Fi")

#Number of Stars 
#Creating a visualization of the stars and the movies they appear in Action 
actionStarCount <- as.data.frame(tally(group_by(actionDiscretized, star)))
#Creating a visualization of the stars and the movies they appear in Adventure 
adventureStarCount <- as.data.frame(tally(group_by(adventureDiscretized, star)))
#Creating a visualization of the stars and the movies they appear in ANimation 
animationStarCount <- as.data.frame(tally(group_by(animationDiscretized, star)))
#Creating a visualization of the stars and the movies they appear in Biography 
biographyStarCount <- as.data.frame(tally(group_by(biographyDiscretized, star)))
#Creating a visualization of the stars and the movies they appear in COmedy 
comedyStarCount <- as.data.frame(tally(group_by(comedyDiscretized, star)))
#Creating a visualization of the stars and the movies they appear in Crime 
crimeStarCount <- as.data.frame(tally(group_by(crimeDiscretized, star)))
#Creating a visualization of the stars and the movies they appear in Drama
dramaStarCount <- as.data.frame(tally(group_by(dramaDiscretized, star)))
#Creating a visualization of the stars and the movies they appear in Fantasy
fantasyStarCount <- as.data.frame(tally(group_by(fantasyDiscretized, star)))
#Creating a visualization of the stars and the movies they appear in Horror
horrorStarCount <- as.data.frame(tally(group_by(horrorDiscretized, star)))
#Creating a visualization of the stars and the movies they appear in Mystery
mysteryStarCount <- as.data.frame(tally(group_by(mysteryDiscretized, star)))
#Creating a visualization of the stars and the movies they appear in Sci-Fi
scifiStarCount <- as.data.frame(tally(group_by(scifiDiscretized, star)))


#Visualizing the stars and number of movies appeared in Action 
ggplot(actionStarCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Action Moives Per Star") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Stars")
#Visualizing the stars and number of movies appeared in Adventure 
ggplot(adventureStarCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Adventure Moives Per Star") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Stars")
#Visualizing the stars and number of movies appeared in Animation
ggplot(animationStarCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Animation Moives Per Star") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Stars")
#Visualizing the stars and number of movies appeared in Biography
ggplot(biographyStarCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Biography Moives Per Star") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Stars")
#Visualizing the stars and number of movies appeared in Comedy
ggplot(comedyStarCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Comedy Moives Per Star") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Stars")
#Visualizing the stars and number of movies appeared in Crime 
ggplot(crimeStarCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Crime Moives Per Star") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Stars")
#Visualizing the stars and number of movies appeared in Drama 
ggplot(dramaStarCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Drama Moives Per Star") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Stars")
#Visualizing the stars and number of movies appeared in Fantasy 
ggplot(fantasyStarCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Fantasy Moives Per Star") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Stars")
#THis looks weird... There are 4 fantasy stars that were in 1 movie each 

#Visualizing the stars and number of movies appeared in Horror
ggplot(horrorStarCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Horror Moives Per Star") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Stars")
#this looks weird... there are 8 stars that were in 1 horror movie each 

#Visualizing the stars and number of movies appeared in Mystery 
ggplot(mysteryStarCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Mystery Moives Per Star") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Stars")
#Visualizing the stars and number of movies appeared in Sci-fi
ggplot(scifiStarCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Sci-Fi Moives Per Star") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Stars")


#Directors 
#Creating a visualization of the Directors and the movies they appear in Action 
actionDirectorCount <- as.data.frame(tally(group_by(actionDiscretized, director)))
#Creating a visualization of the Directors and the movies they appear in Adventure 
adventureDirectorCount <- as.data.frame(tally(group_by(adventureDiscretized, director)))
#Creating a visualization of the Directors and the movies they appear in ANimation 
animationDirectorCount <- as.data.frame(tally(group_by(animationDiscretized, director)))
#Creating a visualization of the Directors and the movies they appear in Biography 
biographyDirectorCount <- as.data.frame(tally(group_by(biographyDiscretized, director)))
#Creating a visualization of the Directors and the movies they appear in COmedy 
comedyDirectorCount <- as.data.frame(tally(group_by(comedyDiscretized, director)))
#Creating a visualization of the Directors and the movies they appear in Crime 
crimeDirectorCount <- as.data.frame(tally(group_by(crimeDiscretized, director)))
#Creating a visualization of the Directors and the movies they appear in Drama
dramaDirectorCount <- as.data.frame(tally(group_by(dramaDiscretized, director)))
#Creating a visualization of the Directors and the movies they appear in Fantasy
fantasyDirectorCount <- as.data.frame(tally(group_by(fantasyDiscretized, director)))
#Creating a visualization of the Directors and the movies they appear in Horror
horrorDirectorCount <- as.data.frame(tally(group_by(horrorDiscretized, director)))
#Creating a visualization of the Directors and the movies they appear in Mystery
mysteryDirectorCount <- as.data.frame(tally(group_by(mysteryDiscretized, director)))
#Creating a visualization of the Directors and the movies they appear in Sci-Fi
scifiDirectorCount <- as.data.frame(tally(group_by(scifiDiscretized, director)))


#Visualizing the Directors and number of movies appeared in Action 
ggplot(actionDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Action Moives Per Director") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Directors")
#Visualizing the Directors and number of movies appeared in Adventure 
ggplot(adventureDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Adventure Moives Per Director") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Director")
#Visualizing the Directors and number of movies appeared in Animation
ggplot(animationDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Animation Moives Per Director") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Director")
#Visualizing the Directors and number of movies appeared in Biography
ggplot(biographyDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Biography Moives Per Director") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Director")
#Visualizing the Directors and number of movies appeared in Comedy
ggplot(comedyDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Comedy Moives Per Director") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Director")
#Visualizing the Directors and number of movies appeared in Crime 
ggplot(crimeDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Crime Moives Per Director") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Director")
#Visualizing the Directors and number of movies appeared in Drama 
ggplot(dramaDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Drama Moives Per Director") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Director")
#Visualizing the Directors and number of movies appeared in Fantasy 
ggplot(fantasyDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Fantasy Moives Per Director") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Director")
#THis looks weird... There are 4 fantasy Directors that were in 1 movie each 

#Visualizing the Directors and number of movies appeared in Horror
ggplot(horrorDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Horror Moives Per Director") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Director")
#this looks weird... there are 8 Directors that were in 1 horror movie each 

#Visualizing the Directors and number of movies appeared in Mystery 
ggplot(mysteryDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Mystery Moives Per Director") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Director")
#Visualizing the Directors and number of movies appeared in Sci-fi
ggplot(scifiDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Sci-Fi Moives Per Director") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Director")

#Writers
#Creating a visualization of the Writers and the movies they appear in Action 
actionWriterCount <- as.data.frame(tally(group_by(actionDiscretized, writer)))
#Creating a visualization of the Writers and the movies they appear in Adventure 
adventureWriterCount <- as.data.frame(tally(group_by(adventureDiscretized, writer)))
#Creating a visualization of the Writers and the movies they appear in ANimation 
animationWriterCount <- as.data.frame(tally(group_by(animationDiscretized, writer)))
#Creating a visualization of the Writers and the movies they appear in Biography 
biographyWriterCount <- as.data.frame(tally(group_by(biographyDiscretized, writer)))
#Creating a visualization of the Writers and the movies they appear in COmedy 
comedyWriterCount <- as.data.frame(tally(group_by(comedyDiscretized, writer)))
#Creating a visualization of the Writers and the movies they appear in Crime 
crimeWriterCount <- as.data.frame(tally(group_by(crimeDiscretized, writer)))
#Creating a visualization of the Writers and the movies they appear in Drama
dramaWriterCount <- as.data.frame(tally(group_by(dramaDiscretized, writer)))
#Creating a visualization of the Writers and the movies they appear in Fantasy
fantasyWriterCount <- as.data.frame(tally(group_by(fantasyDiscretized, writer)))
#Creating a visualization of the Writers and the movies they appear in Horror
horrorWriterCount <- as.data.frame(tally(group_by(horrorDiscretized, writer)))
#Creating a visualization of the Writers and the movies they appear in Mystery
mysteryWriterCount <- as.data.frame(tally(group_by(mysteryDiscretized, writer)))
#Creating a visualization of the Writers and the movies they appear in Sci-Fi
scifiWriterCount <- as.data.frame(tally(group_by(scifiDiscretized, writer)))


#Visualizing the Writers and number of movies appeared in Action 
ggplot(actionDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Action Moives Per Writer") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Writers")
#Visualizing the Writers and number of movies appeared in Adventure 
ggplot(adventureDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Adventure Moives Per Writer") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Writers")
#Visualizing the Writers and number of movies appeared in Animation
ggplot(animationDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Animation Moives Per Writer") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Writers")
#Visualizing the Writers and number of movies appeared in Biography
ggplot(biographyDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Biography Moives Per Writer") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Writers")
#Visualizing the Writers and number of movies appeared in Comedy
ggplot(comedyDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Comedy Moives Per Writer") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Writers")
#Visualizing the Writers and number of movies appeared in Crime 
ggplot(crimeDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Crime Moives Per Writer") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Writers")
#Visualizing the Writers and number of movies appeared in Drama 
ggplot(dramaDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Drama Moives Per Writer") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Writers")
#Visualizing the Writers and number of movies appeared in Fantasy 
ggplot(fantasyDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Fantasy Moives Per Writer") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Writers")
#THis looks weird... There are 4 fantasy Writers that were in 1 movie each 

#Visualizing the Writers and number of movies appeared in Horror
ggplot(horrorDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Horror Moives Per Writer") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Writers")
#this looks weird... there are 8 Writers that were in 1 horror movie each 

#Visualizing the Writers and number of movies appeared in Mystery 
ggplot(mysteryDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Mystery Moives Per Writer") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Writers")
#Visualizing the Writers and number of movies appeared in Sci-fi
ggplot(scifiDirectorCount, aes(x = n)) + geom_bar(aes(fill = rainbow(1)))  + ggtitle("Visualization of Number of Sci-Fi Moives Per Writer") + theme(legend.position ="none") + xlab("Number of Movies") + ylab("Number of Writers")

#Budget 
#Creating a visualization of the spread of budget for the movies Action 
ggplot(actionDiscretized, aes(x = budget)) + geom_bar(aes(fill = budget)) + ggtitle("Visualization of Action Movie Budget") + theme(legend.position ="none") + xlab("Budget") + ylab("Number of Action Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of budget for the movies Adventure 
ggplot(adventureDiscretized, aes(x = budget)) + geom_bar(aes(fill = budget)) + ggtitle("Visualization of Adventure Movie Budget") + theme(legend.position ="none") + xlab("Budget") + ylab("Number of Adventure Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of budget for the movies Animation  
ggplot(animationDiscretized, aes(x = budget)) + geom_bar(aes(fill = budget)) + ggtitle("Visualization of Animation Movie Budget") + theme(legend.position ="none") + xlab("Budget") + ylab("Number of Animation Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of budget for the movies Biography 
ggplot(biographyDiscretized, aes(x = budget)) + geom_bar(aes(fill = budget)) + ggtitle("Visualization of Biography Movie Budget") + theme(legend.position ="none") + xlab("Budget") + ylab("Number of Biography Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of budget for the movies Comedy
ggplot(comedyDiscretized, aes(x = budget)) + geom_bar(aes(fill = budget)) + ggtitle("Visualization of Comedy Movie Budget") + theme(legend.position ="none") + xlab("Budget") + ylab("Number of Comedy Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of budget for the movies Crime 
ggplot(crimeDiscretized, aes(x = budget)) + geom_bar(aes(fill = budget)) + ggtitle("Visualization of Crime Movie Budget") + theme(legend.position ="none") + xlab("Budget") + ylab("Number of Crime Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of budget for the movies Drama 
ggplot(dramaDiscretized, aes(x = budget)) + geom_bar(aes(fill = budget)) + ggtitle("Visualization of Drama Movie Budget") + theme(legend.position ="none") + xlab("Budget") + ylab("Number of Drama Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of budget for the movies Fantasy 
ggplot(fantasyDiscretized, aes(x = budget)) + geom_bar(aes(fill = budget)) + ggtitle("Visualization of Fantasy Movie Budget") + theme(legend.position ="none") + xlab("Budget") + ylab("Number of Fantasy Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of budget for the movies Horror
ggplot(horrorDiscretized, aes(x = budget)) + geom_bar(aes(fill = budget)) + ggtitle("Visualization of Horror Movie Budget") + theme(legend.position ="none") + xlab("Budget") + ylab("Number of Horror Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of budget for the movies Mystery 
ggplot(mysteryDiscretized, aes(x = budget)) + geom_bar(aes(fill = budget)) + ggtitle("Visualization of Mystery Movie Budget") + theme(legend.position ="none") + xlab("Budget") + ylab("Number of Mystery Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of budget for the movies Sci-Fi 
ggplot(scifiDiscretized, aes(x = budget)) + geom_bar(aes(fill = budget)) + ggtitle("Visualization of Sci-Fi Movie Budget") + theme(legend.position ="none") + xlab("Budget") + ylab("Number of Sci-Fi Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))

#Gross
#Creating a visualization of the spread of gross for the movies Action 
ggplot(actionDiscretized, aes(x = gross)) + geom_bar(aes(fill = gross)) + ggtitle("Visualization of Action Movie Gross") + theme(legend.position ="none") + xlab("Gross") + ylab("Number of Action Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of gross for the movies Adventure 
ggplot(adventureDiscretized, aes(x = gross)) + geom_bar(aes(fill = gross)) + ggtitle("Visualization of Adventure Movie Gross") + theme(legend.position ="none") + xlab("Gross") + ylab("Number of Adventure Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of gross for the movies Animation  
ggplot(animationDiscretized, aes(x = gross)) + geom_bar(aes(fill = gross)) + ggtitle("Visualization of Animation Movie Gross") + theme(legend.position ="none") + xlab("Gross") + ylab("Number of Animation Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of gross for the movies Biography 
ggplot(biographyDiscretized, aes(x = gross)) + geom_bar(aes(fill = gross)) + ggtitle("Visualization of Biography Movie Gross") + theme(legend.position ="none") + xlab("Gross") + ylab("Number of Biography Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of gross for the movies Comedy
ggplot(comedyDiscretized, aes(x = gross)) + geom_bar(aes(fill = gross)) + ggtitle("Visualization of Comedy Movie Gross") + theme(legend.position ="none") + xlab("Gross") + ylab("Number of Comedy Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of gross for the movies Crime 
ggplot(crimeDiscretized, aes(x = gross)) + geom_bar(aes(fill = gross)) + ggtitle("Visualization of Crime Movie Gross") + theme(legend.position ="none") + xlab("Gross") + ylab("Number of Crime Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of gross for the movies Drama 
ggplot(dramaDiscretized, aes(x = gross)) + geom_bar(aes(fill = gross)) + ggtitle("Visualization of Drama Movie Gross") + theme(legend.position ="none") + xlab("Gross") + ylab("Number of Drama Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of gross for the movies Fantasy 
ggplot(fantasyDiscretized, aes(x = gross)) + geom_bar(aes(fill = gross)) + ggtitle("Visualization of Fantasy Movie Gross") + theme(legend.position ="none") + xlab("Gross") + ylab("Number of Fantasy Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of gross for the movies Horror
ggplot(horrorDiscretized, aes(x = gross)) + geom_bar(aes(fill = gross)) + ggtitle("Visualization of Horror Movie Gross") + theme(legend.position ="none") + xlab("Gross") + ylab("Number of Horror Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of gross for the movies Mystery 
ggplot(mysteryDiscretized, aes(x = gross)) + geom_bar(aes(fill = gross)) + ggtitle("Visualization of Mystery Movie Gross") + theme(legend.position ="none") + xlab("Gross") + ylab("Number of Mystery Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of gross for the movies Sci-Fi 
ggplot(scifiDiscretized, aes(x = gross)) + geom_bar(aes(fill = gross)) + ggtitle("Visualization of Sci-Fi Movie Gross") + theme(legend.position ="none") + xlab("Gross") + ylab("Number of Sci-Fi Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))

#PercProf 
#Creating a visualization of the spread of PercProf for the movies Action 
ggplot(actionDiscretized, aes(x = percProfit)) + geom_bar(aes(fill = percProfit)) + ggtitle("Visualization of Action Movie Percent Profit") + theme(legend.position ="none") + xlab("Percent Profit") + ylab("Number of Action Movies") + scale_x_discrete(labels = c("negative", "0 - 2%", "2 - 4%", "4 - 6%", "7 - 8%", "8 - 10%", "10%+"))
#Creating a visualization of the spread of PercProf for the movies Adventure 
ggplot(adventureDiscretized, aes(x = percProfit)) + geom_bar(aes(fill = percProfit)) + ggtitle("Visualization of Adventure Movie Percent Profit") + theme(legend.position ="none") + xlab("Percent Profit") + ylab("Number of Adventure Movies")+ scale_x_discrete(labels = c("negative", "0 - 2%", "2 - 4%", "4 - 6%", "7 - 8%", "8 - 10%", "10%+"))
#Creating a visualization of the spread of PercProf for the movies Animation  
ggplot(animationDiscretized, aes(x = percProfit)) + geom_bar(aes(fill = percProfit)) + ggtitle("Visualization of Animation Movie Percent Profit") + theme(legend.position ="none") + xlab("Percent Profit") + ylab("Number of Animation Movies")+ scale_x_discrete(labels = c("negative", "0 - 2%", "2 - 4%", "4 - 6%", "7 - 8%", "8 - 10%", "10%+"))
#Creating a visualization of the spread of PercProf for the movies Biography 
ggplot(biographyDiscretized, aes(x = percProfit)) + geom_bar(aes(fill = percProfit)) + ggtitle("Visualization of Biography Movie Percent Profit") + theme(legend.position ="none") + xlab("Percent Profit") + ylab("Number of Biography Movies") + scale_x_discrete(labels = c("negative", "0 - 2%", "2 - 4%", "4 - 6%", "7 - 8%", "8 - 10%", "10%+"))
#Creating a visualization of the spread of PercProf for the movies Comedy
ggplot(comedyDiscretized, aes(x = percProfit)) + geom_bar(aes(fill = percProfit)) + ggtitle("Visualization of Comedy Movie Percent Profit") + theme(legend.position ="none") + xlab("Percent Profit") + ylab("Number of Comedy Movies")+ scale_x_discrete(labels = c("negative", "0 - 2%", "2 - 4%", "4 - 6%", "7 - 8%", "8 - 10%", "10%+"))
#Creating a visualization of the spread of PercProf for the movies Crime 
ggplot(crimeDiscretized, aes(x = percProfit)) + geom_bar(aes(fill = percProfit)) + ggtitle("Visualization of Crime Movie Percent Profit") + theme(legend.position ="none") + xlab("Percent Profit") + ylab("Number of Crime Movies")+ scale_x_discrete(labels = c("negative", "0 - 2%", "2 - 4%", "4 - 6%", "7 - 8%", "8 - 10%", "10%+"))
#Creating a visualization of the spread of PercProf for the movies Drama 
ggplot(dramaDiscretized, aes(x = percProfit)) + geom_bar(aes(fill = percProfit)) + ggtitle("Visualization of Drama Movie Percent Profit") + theme(legend.position ="none") + xlab("Percent Profit") + ylab("Number of Drama Movies")+ scale_x_discrete(labels = c("negative", "0 - 2%", "2 - 4%", "4 - 6%", "7 - 8%", "8 - 10%", "10%+"))
#Creating a visualization of the spread of PercProf for the movies Fantasy 
ggplot(fantasyDiscretized, aes(x = percProfit)) + geom_bar(aes(fill = percProfit)) + ggtitle("Visualization of Fantasy Movie Percent Profit") + theme(legend.position ="none") + xlab("Percent Profit") + ylab("Number of Fantasy Movies") + scale_x_discrete(labels = c("negative", "0 - 2%", "2 - 4%", "4 - 6%", "7 - 8%", "8 - 10%", "10%+"))
#Creating a visualization of the spread of PercProf for the movies Horror
ggplot(horrorDiscretized, aes(x = percProfit)) + geom_bar(aes(fill = percProfit)) + ggtitle("Visualization of Horror Movie Percent Profit") + theme(legend.position ="none") + xlab("Percent Profit") + ylab("Number of Horror Movies") + scale_x_discrete(labels = c("negative", "0 - 2%", "2 - 4%", "4 - 6%", "7 - 8%", "8 - 10%", "10%+"))
#Creating a visualization of the spread of PercProf for the movies Mystery 
ggplot(mysteryDiscretized, aes(x = percProfit)) + geom_bar(aes(fill = percProfit)) + ggtitle("Visualization of Mystery Movie Percent Profit") + theme(legend.position ="none") + xlab("Percent Profit") + ylab("Number of Mystery Movies") + scale_x_discrete(labels = c("negative", "0 - 2%", "2 - 4%", "4 - 6%", "7 - 8%", "8 - 10%", "10%+"))
#Creating a visualization of the spread of PercProf for the movies Sci-Fi 
ggplot(scifiDiscretized, aes(x = percProfit)) + geom_bar(aes(fill = percProfit)) + ggtitle("Visualization of Sci-Fi Movie Percent Profit") + theme(legend.position ="none") + xlab("Percent Profit") + ylab("Number of Sci-Fi Movies")+ scale_x_discrete(labels = c("negative", "0 - 2%", "2 - 4%", "4 - 6%", "7 - 8%", "8 - 10%", "10%+"))

#runtime 
#Creating a visualization of the spread of runtime for the movies Action 
ggplot(actionDiscretized, aes(x = runtime)) + geom_bar(aes(fill = runtime)) + ggtitle("Visualization of Action Movie Runtime") + theme(legend.position ="none") + xlab("Runtime") + ylab("Number of Action Movies") + scale_x_discrete(labels = c("short", "average", "long")) 
#Creating a visualization of the spread of runtime for the movies Adventure 
ggplot(adventureDiscretized, aes(x = runtime)) + geom_bar(aes(fill = runtime)) + ggtitle("Visualization of Adventure Movie Runtime") + theme(legend.position ="none") + xlab("Runtime") + ylab("Number of Adventure Movies") + scale_x_discrete(labels = c("short", "average", "long")) 
#Creating a visualization of the spread of runtime for the movies Animation  
ggplot(animationDiscretized, aes(x = runtime)) + geom_bar(aes(fill = runtime)) + ggtitle("Visualization of Animation Movie Runtime") + theme(legend.position ="none") + xlab("Runtime") + ylab("Number of Animation Movies") + scale_x_discrete(labels = c("short", "average", "long")) 
#Creating a visualization of the spread of runtime for the movies Biography 
ggplot(biographyDiscretized, aes(x = runtime)) + geom_bar(aes(fill = runtime)) + ggtitle("Visualization of Biography Movie Runtime") + theme(legend.position ="none") + xlab("Runtime") + ylab("Number of Biography Movies") + scale_x_discrete(labels = c("short", "average", "long")) 
#Creating a visualization of the spread of runtime for the movies Comedy
ggplot(comedyDiscretized, aes(x = runtime)) + geom_bar(aes(fill = runtime)) + ggtitle("Visualization of Comedy Movie Runtime") + theme(legend.position ="none") + xlab("Runtime") + ylab("Number of Comedy Movies") + scale_x_discrete(labels = c("short", "average", "long")) 
#Creating a visualization of the spread of runtime for the movies Crime 
ggplot(crimeDiscretized, aes(x = runtime)) + geom_bar(aes(fill = runtime)) + ggtitle("Visualization of Crime Movie Runtime") + theme(legend.position ="none") + xlab("Runtime") + ylab("Number of Crime Movies") + scale_x_discrete(labels = c("short", "average", "long")) 
#Creating a visualization of the spread of runtime for the movies Drama 
ggplot(dramaDiscretized, aes(x = runtime)) + geom_bar(aes(fill = runtime)) + ggtitle("Visualization of Drama Movie Runtime") + theme(legend.position ="none") + xlab("Runtime") + ylab("Number of Drama Movies") + scale_x_discrete(labels = c("short", "average", "long")) 
#Creating a visualization of the spread of runtime for the movies Fantasy 
ggplot(fantasyDiscretized, aes(x = runtime)) + geom_bar(aes(fill = runtime)) + ggtitle("Visualization of Fantasy Movie Runtime") + theme(legend.position ="none") + xlab("Runtime") + ylab("Number of Fantasy Movies") + scale_x_discrete(labels = c("short", "average", "long")) 
#Creating a visualization of the spread of runtime for the movies Horror
ggplot(horrorDiscretized, aes(x = runtime)) + geom_bar(aes(fill = runtime)) + ggtitle("Visualization of Horror Movie Runtime") + theme(legend.position ="none") + xlab("Runtime") + ylab("Number of Horror Movies") + scale_x_discrete(labels = c("short", "average", "long")) 
#Creating a visualization of the spread of runtime for the movies Mystery 
ggplot(mysteryDiscretized, aes(x = runtime)) + geom_bar(aes(fill = runtime)) + ggtitle("Visualization of Mystery Movie Runtime") + theme(legend.position ="none") + xlab("Runtime") + ylab("Number of Mystery Movies") + scale_x_discrete(labels = c("short", "average", "long")) 
#Creating a visualization of the spread of runtime for the movies Sci-Fi 
ggplot(scifiDiscretized, aes(x = runtime)) + geom_bar(aes(fill = runtime)) + ggtitle("Visualization of Sci-Fi Movie Runtime") + theme(legend.position ="none") + xlab("Runtime") + ylab("Number of Sci-Fi Movies") + scale_x_discrete(labels = c("short", "average", "long")) 

#score
#Creating a visualization of the spread of score for the movies Action 
ggplot(actionDiscretized, aes(x = score)) + geom_bar(aes(fill = score)) + ggtitle("Visualization of Action Movie Score") + theme(legend.position ="none") + xlab("Score") + ylab("Number of Action Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of score for the movies Adventure 
ggplot(adventureDiscretized, aes(x = score)) + geom_bar(aes(fill = score)) + ggtitle("Visualization of Adventure Movie Score") + theme(legend.position ="none") + xlab("Score") + ylab("Number of Adventure Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of score for the movies Animation  
ggplot(animationDiscretized, aes(x = score)) + geom_bar(aes(fill = score)) + ggtitle("Visualization of Animation Movie Score") + theme(legend.position ="none") + xlab("Score") + ylab("Number of Animation Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of score for the movies Biography 
ggplot(biographyDiscretized, aes(x = score)) + geom_bar(aes(fill = score)) + ggtitle("Visualization of Biography Movie Score") + theme(legend.position ="none") + xlab("Score") + ylab("Number of Biography Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of score for the movies Comedy
ggplot(comedyDiscretized, aes(x = score)) + geom_bar(aes(fill = score)) + ggtitle("Visualization of Comedy Movie Score") + theme(legend.position ="none") + xlab("Score") + ylab("Number of Comedy Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of score for the movies Crime 
ggplot(crimeDiscretized, aes(x = score)) + geom_bar(aes(fill = score)) + ggtitle("Visualization of Crime Movie Score") + theme(legend.position ="none") + xlab("Score") + ylab("Number of Crime Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of score for the movies Drama 
ggplot(dramaDiscretized, aes(x = score)) + geom_bar(aes(fill = score)) + ggtitle("Visualization of Drama Movie Score") + theme(legend.position ="none") + xlab("Score") + ylab("Number of Drama Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of score for the movies Fantasy 
ggplot(fantasyDiscretized, aes(x = score)) + geom_bar(aes(fill = score)) + ggtitle("Visualization of Fantasy Movie Score") + theme(legend.position ="none") + xlab("Score") + ylab("Number of Fantasy Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of score for the movies Horror
ggplot(horrorDiscretized, aes(x = score)) + geom_bar(aes(fill = score)) + ggtitle("Visualization of Horror Movie Score") + theme(legend.position ="none") + xlab("Score") + ylab("Number of Horror Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of score for the movies Mystery 
ggplot(mysteryDiscretized, aes(x = score)) + geom_bar(aes(fill = score)) + ggtitle("Visualization of Mystery Movie Score") + theme(legend.position ="none") + xlab("Score") + ylab("Number of Mystery Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of score for the movies Sci-Fi 
ggplot(scifiDiscretized, aes(x = score)) + geom_bar(aes(fill = score)) + ggtitle("Visualization of Sci-Fi Movie Score") + theme(legend.position ="none") + xlab("Score") + ylab("Number of Sci-Fi Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))

#votes 
#Creating a visualization of the spread of votes for the movies Action 
ggplot(actionDiscretized, aes(x = votes)) + geom_bar(aes(fill = votes)) + ggtitle("Visualization of Action Movie Votes") + theme(legend.position ="none") + xlab("Votes") + ylab("Number of Action Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of votes for the movies Adventure 
ggplot(adventureDiscretized, aes(x = votes)) + geom_bar(aes(fill = votes)) + ggtitle("Visualization of Adventure Movie Votes") + theme(legend.position ="none") + xlab("Votes") + ylab("Number of Adventure Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of votes for the movies Animation  
ggplot(animationDiscretized, aes(x = votes)) + geom_bar(aes(fill = votes)) + ggtitle("Visualization of Animation Movie Votes") + theme(legend.position ="none") + xlab("Votes") + ylab("Number of Animation Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of votes for the movies Biography 
ggplot(biographyDiscretized, aes(x = votes)) + geom_bar(aes(fill = votes)) + ggtitle("Visualization of Biography Movie Votes") + theme(legend.position ="none") + xlab("Votes") + ylab("Number of Biography Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of votes for the movies Comedy
ggplot(comedyDiscretized, aes(x = votes)) + geom_bar(aes(fill = votes)) + ggtitle("Visualization of Comedy Movie Votes") + theme(legend.position ="none") + xlab("Votes") + ylab("Number of Comedy Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of votes for the movies Crime 
ggplot(crimeDiscretized, aes(x = votes)) + geom_bar(aes(fill = votes)) + ggtitle("Visualization of Crime Movie Votes") + theme(legend.position ="none") + xlab("Votes") + ylab("Number of Crime Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of votes for the movies Drama 
ggplot(dramaDiscretized, aes(x = votes)) + geom_bar(aes(fill = votes)) + ggtitle("Visualization of Drama Movie Votes") + theme(legend.position ="none") + xlab("Votes") + ylab("Number of Drama Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of votes for the movies Fantasy 
ggplot(fantasyDiscretized, aes(x = votes)) + geom_bar(aes(fill = votes)) + ggtitle("Visualization of Fantasy Movie Votes") + theme(legend.position ="none") + xlab("Votes") + ylab("Number of Fantasy Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of votes for the movies Horror
ggplot(horrorDiscretized, aes(x = votes)) + geom_bar(aes(fill = votes)) + ggtitle("Visualization of Horror Movie Votes") + theme(legend.position ="none") + xlab("Votes") + ylab("Number of Horror Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of votes for the movies Mystery 
ggplot(mysteryDiscretized, aes(x = votes)) + geom_bar(aes(fill = votes)) + ggtitle("Visualization of Mystery Movie Votes") + theme(legend.position ="none") + xlab("Votes") + ylab("Number of Mystery Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))
#Creating a visualization of the spread of votes for the movies Sci-Fi 
ggplot(scifiDiscretized, aes(x = votes)) + geom_bar(aes(fill = votes)) + ggtitle("Visualization of Sci-Fi Movie Votes") + theme(legend.position ="none") + xlab("Votes") + ylab("Number of Sci-Fi Movies") + scale_x_discrete(labels = c("extremely low", "low", "high", "extremely high"))

#***************************************************************************************************************************
#
#**************************************************************************************************************************
######################################################################################################################################
######################################################################################################################################
###################        We Decided We Wanted More Information Than Was Provided                ####################################
###################        So We Added New Columns to the DF for Star Gender and                  ####################################
###################        Age at Time of Movie, Director Gender and Age at Time of Movie         ####################################
######################################################################################################################################
######################################################################################################################################
#***************************************************************************************************************************
#
#**************************************************************************************************************************
library(arules)
library(dplyr)
library(tidyr)

#Setting working directory to my computer IST 707 Team Project
setwd("C:\\Users\\ho511\\Desktop\\IST 707\\Team Project\\CSVs")

#This makes it so the budget and gross will not be in scientific notation 
options(scipen=999)

#Reading in the new dfs 
moviesUSA_v2 <- read.csv("moviesUSA_v2.csv", header = TRUE)
moviesUSADiscretized_v2 <- read.csv("moviesUSADiscretized_v2.csv", header = TRUE)

#Super cool df that Kendra Scraped with Python 
actorTMDB <- read.csv('actor_popularity_g.csv',  header = TRUE)
#Super cool df that Kendra Scraped with Python 
directorTMDB <- read.csv('director_popularity_g.csv', header = TRUE)


##----- STEP 1i. Import Ali's awesome new files!!
#moviesUSA_v2_csv <- paste(kpath, "/project/moviesUSA_v2.csv", sep='')
#moviesUSADiscretized_v2_csv <- paste(kpath, "/project/moviesUSADiscretized_v2.csv", sep='')

#moviesUSA_v2 <- read.csv(moviesUSA_v2_csv, header = TRUE)
#moviesUSADiscretized_v2 <- read.csv(moviesUSADiscretized_v2_csv, header = TRUE)

##----- STEP 1ii. Import TMDB detail files
#actorCSV <- paste(kpath, "/python/actor_popularity_g.csv", sep='')
#actorTMDB <- read.csv(actorCSV, header = TRUE)

#directorCSV <- paste(kpath, "/python/director_popularity_g.csv", sep='')
#directorTMDB <- read.csv(directorCSV, header = TRUE)

## -- STEP 1iii. CLEAN AND FIX FILES
## Change column name from 'actor' to 'star' because


everything_MoviesUSADiscretized <- actorTMDB %>% full_join(moviesUSADiscretized_v2)
everything_MoviesUSADiscretized <- directorTMDB %>% full_join(everything_MoviesUSADiscretized)

everything_MoviesUSA <- actorTMDB %>% full_join(moviesUSA_v2)
everything_MoviesUSA <- directorTMDB %>% full_join(everything_MoviesUSA)

#Checking the structure of the new dfs 
str(everything_MoviesUSA)
#Released needs to be changed to an ordered factor (months)
everything_MoviesUSA$released = as.ordered(everything_MoviesUSA$released)
#Rating should be an ordered factor too 
everything_MoviesUSA$rating = as.ordered(everything_MoviesUSA$rating)
#Buget, Year, Age, runtime, yearborn, age, votes, year all are going to be changed to numeric 
#Changing all integar to numeric 
everything_MoviesUSA <- everything_MoviesUSA %>% mutate_if(is.integer, as.numeric)

#Checking the structure again 
str(everything_MoviesUSA)

#CHecking to make sure no NAs were introduce 
sum(is.na(everything_MoviesUSA))
#No NAS! 

#Repeating the process for the everything_MoviesUSADiscretized df 
str(everything_MoviesUSADiscretized)

#We do not need the year the star and director were born, 
#we just gathered that info to determine the age of the director and star at the time the movie was released
everything_MoviesUSADiscretized <- everything_MoviesUSADiscretized[,!colnames(everything_MoviesUSADiscretized) %in% c('starYearBorn', 'directorYearBorn')]
everything_MoviesUSA <- everything_MoviesUSA[,!colnames(everything_MoviesUSA) %in% c('starYearBorn', 'directorYearBorn')]

#Released and rating needs to be changed to an ordered factor 
everything_MoviesUSADiscretized$released = as.ordered(everything_MoviesUSADiscretized$released)
everything_MoviesUSADiscretized$rating = as.ordered(everything_MoviesUSADiscretized$rating)

#Want to change all integers to numeric 
everything_MoviesUSADiscretized <- everything_MoviesUSADiscretized %>% mutate_if(is.integer, as.numeric)

#Checking the structure again 
str(everything_MoviesUSADiscretized)

#Chaning the way we discretized score, percent profit
#Since the discretized df already has a discretized version of score and percent profit, 
#we are going to use the everything_MoviesUSA df info to discretized and replace the everything_MoviesDiscretized df
(avg_score <- mean(everything_MoviesUSA$score))
quantile(everything_MoviesUSA$score)

quantile(everything_MoviesUSA$score)
scoreDiscretize <- arules::discretize(everything_MoviesUSA$score, method = "fixed", breaks = c(0, 6.1, 7.2, Inf), labels = c("low", "average", "high"))
everything_MoviesUSADiscretized$score <- scoreDiscretize

#Loooking at percent Profit 
(avg_percProf <- mean(everything_MoviesUSA$percProf))
quantile(everything_MoviesUSA$percProf)
percProfDiscretize <- arules::discretize(everything_MoviesUSA$percProf, method = "fixed", breaks = c(-Inf, 0, 1.17, Inf), labels = c("negative", "average", "high"))
everything_MoviesUSADiscretized$percProfit <- percProfDiscretize

#Star Popularity 
(avg_starPop <- mean(everything_MoviesUSADiscretized$starPopularity))
quantile(everything_MoviesUSADiscretized$starPopularity)
starPopDiscretized <- arules::discretize(everything_MoviesUSADiscretized$starPopularity, method = "fixed", breaks = c(0, 3.803, 8.266, Inf), labels = c("low", "average", "high"))
everything_MoviesUSADiscretized$starPopularity <- starPopDiscretized

#Director Popularity 
(avg_directorPop <- mean(everything_MoviesUSADiscretized$directorPopularity))
quantile(everything_MoviesUSADiscretized$directorPopularity)
directorPopDiscretized <- arules::discretize(everything_MoviesUSADiscretized$directorPopularity, method = "fixed", breaks = c(0, 1.38, 2.474, Inf), labels = c("low", "average", "high"))
everything_MoviesUSADiscretized$directorPopularity <- directorPopDiscretized

#Star Age 
(min_starAge <- min(everything_MoviesUSADiscretized$starAge))
(max_starAge <- max(everything_MoviesUSADiscretized$starAge))
(avg_starAge <- mean(everything_MoviesUSADiscretized$starAge))
quantile(everything_MoviesUSADiscretized$directorAge)
starAgeDiscretized <- arules::discretize(everything_MoviesUSADiscretized$starAge, method = "fixed", breaks = c(0, 30, 50, Inf), labels = c("30s and younger", "40s - 50s", "60s+"))
everything_MoviesUSADiscretized$starAge <- starAgeDiscretized

#Director Age 
(min_directorAge <- min(everything_MoviesUSADiscretized$directorAge))
(max_directorAge <- max(everything_MoviesUSADiscretized$directorAge))
(avg_directorAge <- mean(everything_MoviesUSADiscretized$directorAge))
quantile(everything_MoviesUSADiscretized$directorAge)
directorAgeDiscretized <- arules::discretize(everything_MoviesUSADiscretized$directorAge, method = "fixed", breaks = c(0, 30, 50, Inf), labels = c("30s and younger", "40s - 50s", "60s+"))
everything_MoviesUSADiscretized$directorAge <- directorAgeDiscretized

#Year Released 
quantile(everything_MoviesUSADiscretized$year)
yearReleasedDiscretized <- arules::discretize(everything_MoviesUSADiscretized$year, method = "fixed", breaks = c(1985, 2000, 2010, Inf), labels = c("before 2000", "2000 - 2009","2010 +" ))  
everything_MoviesUSADiscretized$year <- yearReleasedDiscretized

#Also changing the way we originally discretized budget, gross and profit 
quantile(everything_MoviesUSA$budget)
budgetDiscretize <- arules::discretize(everything_MoviesUSA$budget, method = "fixed", breaks = c(0, 23000000, 73000000, Inf), labels = c("low", "average", "high"))
everything_MoviesUSADiscretized$budget <- budgetDiscretize

#Gross 
quantile(everything_MoviesUSA$gross)
grossDiscretize <- arules::discretize(everything_MoviesUSA$gross, method = "fixed", breaks = c(0, 24984868, 106614100, Inf), labels = c("low", "average", "high"))
everything_MoviesUSADiscretized$gross <- grossDiscretize

#Profit
quantile(everything_MoviesUSA$profit)
profitDiscretize <- arules::discretize(everything_MoviesUSA$profit, method = "fixed", breaks = c(-Inf, 0, 47727583, Inf), labels = c("negative", "average", "high"))
everything_MoviesUSADiscretized$profit <- profitDiscretize

#Checking to make sure that everything was discretized properly 
str(everything_MoviesUSADiscretized)

#Need to change the way votes is discretized 
quantile(everything_MoviesUSA$votes)
votesDiscretize <- arules::discretize(everything_MoviesUSA$votes, method = "fixed", breaks = c(0, 39651, 202934, Inf), labels = c("low", "average", "high"))
everything_MoviesUSADiscretized$votes <- votesDiscretize

library(ggplot2)
#Score 
ggplot(everything_MoviesUSADiscretized, aes(x = score)) + geom_bar(aes(fill = score)) + ggtitle("Visualization of Movie Score") + theme(legend.position ="none") + xlab("Score") + ylab("Number of Movies") 


#Creating a visualization of the spread of perc profit for the movies 
#using the discretized df for this visual 
ggplot(everything_MoviesUSADiscretized, aes(x = percProfit)) + geom_bar(aes(fill = percProfit)) + ggtitle("Visualization of Percent Profit") + theme(legend.position ="none") + xlab("Percent Profit") + ylab("Number of Movies") 

#******************************************************************************************************************************
#
# CREATING TESTING AND TRAINING DATAFRAMES 
#
#***************************************************************************************************************************

#********************************************************************
# Code to Create a Training and Testing DF for moviesUSA for Genre
#********************************************************************

#Creating a function to take a random sample from nrows. 
my_sample_fun <- function(df, n) { 
  set.seed(1)
  sample(nrow(df), n)
}

#Creating a function to create a training df 
my_train_set <- function(df, vector) { 
  df[vector,]
}

#Creating a function to create a testing df 
my_test_set <- function(df, vector, n) {
  df <- df[-vector,]
  set.seed(1)
  df[sample(nrow(df), n),]
  
}

#Reading in the Movies Spreadsheet 
everything_MoviesUSA <- read.csv("everything_MoviesUSA.csv", header = TRUE)

genre_pred <- everything_MoviesUSA

#Separating the genre into 4 groups, Action, Comedy, Drama and Other 
genre_action <- subset(genre_pred, genre == "Action")
genre_adventure <- subset(genre_pred, genre == "Adventure")
genre_animation <- subset(genre_pred, genre == "Animation")
genre_biography <- subset(genre_pred, genre == "Biography")
genre_comedy <- subset(genre_pred, genre == "Comedy")
genre_crime <- subset(genre_pred, genre == "Crime")
genre_drama <- subset(genre_pred, genre == "Drama")
genre_fantasy <- subset(genre_pred, genre == "Fantasy")
genre_horror <- subset(genre_pred, genre == "Horror")
genre_mystery <- subset(genre_pred, genre == "Mystery")
genre_scifi <- subset(genre_pred, genre == "Sci-Fi")

#Issue with subsetting equally is that there is only 1 sci-fi movie, 8 horror movies, 7 mysteries, 4 fantasies and 21 animations 
#I think that we should see if we can predict whether the movie is an action, comedy, or drama 

sample_action <- my_sample_fun(genre_action, 95)
train_action <- my_train_set(genre_action, sample_action)
test_action <- my_test_set(genre_action, sample_action, 41)

sample_comedy <- my_sample_fun(genre_comedy, 95)
train_comedy <- my_train_set(genre_comedy, sample_comedy)
test_comedy <- my_test_set(genre_comedy, sample_comedy, 41)

sample_drama <- my_sample_fun(genre_drama, 95)
train_drama <- my_train_set(genre_drama, sample_drama)
test_drama <- my_test_set(genre_drama, sample_drama, 41)

#Combining the test and train dfs 
train_genre <- rbind(train_action, train_comedy, train_drama)
test_genre <- rbind(test_action, test_comedy, test_drama)

#Checking to see if this will help with my error message 
train_genre <- train_genre %>% mutate_if(is.factor, as.character)
train_genre <- train_genre %>% mutate_if(is.character, as.factor)

test_genre <- test_genre %>% mutate_if(is.factor, as.character)
test_genre <- test_genre %>% mutate_if(is.character, as.factor)

write.csv(train_genre, 'train_genre.csv')
write.csv(test_genre, 'test_genre.csv')

#We need to remove the column for score and save it as a test label
test_label_genre <- test_genre[,colnames(test_genre) %in% c('genre')]
test_genre <- test_genre[,!colnames(test_genre) %in% c('genre')]

#*****************************************************************************************
# Code to Create a Training and Testing DF for everything_MoviesUSADiscretized for Genre
#*****************************************************************************************

#Reading in the Movies Spreadsheet 
everything_MoviesUSADiscretized <- read.csv("everything_MoviesUSADiscretized.csv", header = TRUE)

everything_discretized_genre <- everything_MoviesUSADiscretized

#Separating the genre into 4 groups, Action, Comedy, Drama and Other 
everything_discretized_genre_action <- subset(everything_discretized_genre, genre == "Action")
everything_discretized_genre_adventure <- subset(everything_discretized_genre, genre == "Adventure")
everything_discretized_genre_animation <- subset(everything_discretized_genre, genre == "Animation")
everything_discretized_genre_biography <- subset(everything_discretized_genre, genre == "Biography")
everything_discretized_genre_comedy <- subset(everything_discretized_genre, genre == "Comedy")
everything_discretized_genre_crime <- subset(everything_discretized_genre, genre == "Crime")
everything_discretized_genre_drama <- subset(everything_discretized_genre, genre == "Drama")
everything_discretized_genre_fantasy <- subset(everything_discretized_genre, genre == "Fantasy")
everything_discretized_genre_horror <- subset(everything_discretized_genre, genre == "Horror")
everything_discretized_genre_mystery <- subset(everything_discretized_genre, genre == "Mystery")
everything_discretized_genre_scifi <- subset(everything_discretized_genre, genre == "Sci-Fi")

#Issue with subsetting equally is that there is only 1 sci-fi movie, 8 horror movies, 7 mysteries, 4 fantasies and 21 animations 
#I think that we should see if we can predict whether the movie is an action, comedy, or drama 

sample_action <- my_sample_fun(everything_discretized_genre_action, 95)
everything_discretized_train_action <- my_train_set(everything_discretized_genre_action, sample_action)
everything_discretized_test_action <- my_test_set(everything_discretized_genre_action, sample_action, 41)

sample_comedy <- my_sample_fun(everything_discretized_genre_comedy, 95)
everything_discretized_train_comedy <- my_train_set(everything_discretized_genre_comedy, sample_comedy)
everything_discretized_test_comedy <- my_test_set(everything_discretized_genre_comedy, sample_comedy, 41)

sample_drama <- my_sample_fun(everything_discretized_genre_drama, 95)
everything_discretized_train_drama <- my_train_set(everything_discretized_genre_drama, sample_drama)
everything_discretized_test_drama <- my_test_set(everything_discretized_genre_drama, sample_drama, 41)

#Combining the test and train dfs 
everything_discretized_train_genre <- rbind(everything_discretized_train_action, everything_discretized_train_comedy, everything_discretized_train_drama)
everything_discretized_test_genre <- rbind(everything_discretized_test_action, everything_discretized_test_comedy, everything_discretized_test_drama)

#Checking to see if this will help with my error message 
everything_discretized_train_genre <- everything_discretized_train_genre %>% mutate_if(is.factor, as.character)
everything_discretized_train_genre <- everything_discretized_train_genre %>% mutate_if(is.character, as.factor)

everything_discretized_test_genre <- everything_discretized_test_genre %>% mutate_if(is.factor, as.character)
everything_discretized_test_genre <- everything_discretized_test_genre %>% mutate_if(is.character, as.factor)

write.csv(everything_discretized_train_genre, 'everything_discretized_train_genre.csv')
write.csv(everything_discretized_test_genre, 'everything_discretized_test_genre.csv')

#We need to remove the column for score and save it as a test label
everything_discretized_test_label_genre <- everything_discretized_test_genre[,colnames(everything_discretized_test_genre) %in% c('genre')]
everything_discretized_test_genre <- everything_discretized_test_genre[,!colnames(everything_discretized_test_genre) %in% c('genre')]

#****************************************************************************
# Creating Training and Test DFs for everything_MoviesUSA for Profit 
#***************************************************************************

#Reading in the Movies Spreadsheet 
everything_MoviesUSA <- read.csv("everything_MoviesUSA.csv", header = TRUE)
everything_MoviesUSADiscretized <- read.csv("everything_MoviesUSADiscretized.csv", header = TRUE)

everything_percProf <- everything_MoviesUSA
everything_percProf$percProf <- everything_MoviesUSADiscretized$percProfit

#Subsetting
everything_perc_profit_negative <- subset(everything_percProf, percProf == "negative")
everything_perc_profit_average <- subset(everything_percProf, percProf == "average")
everything_perc_profit_high <- subset(everything_percProf, percProf == "high")


#PercProf

sample_perc_profit_negative <- my_sample_fun(everything_perc_profit_negative, 174)
everything_train_perc_profit_negative <- my_train_set(everything_perc_profit_negative, sample_perc_profit_negative)
everything_test_perc_profit_negative <- my_test_set(everything_perc_profit_negative, sample_perc_profit_negative, 74)

sample_perc_profit_average <- my_sample_fun(everything_perc_profit_average, 174)
everything_train_perc_profit_average <- my_train_set(everything_perc_profit_average, sample_perc_profit_average)
everything_test_perc_profit_average <- my_test_set(everything_perc_profit_average, sample_perc_profit_average, 74)

sample_perc_profit_high <- my_sample_fun(everything_perc_profit_high, 174)
everything_train_perc_profit_high <- my_train_set(everything_perc_profit_high, sample_perc_profit_high)
everything_test_perc_profit_high <- my_test_set(everything_perc_profit_high, sample_perc_profit_high, 74)

#Combining the test and train dfs 
everything_train_perc_profit <- rbind(everything_train_perc_profit_negative, everything_train_perc_profit_average, everything_train_perc_profit_high)
everything_test_perc_profit <- rbind(everything_test_perc_profit_negative, everything_test_perc_profit_average, everything_test_perc_profit_high)

write.csv(everything_train_perc_profit, 'everything_train_perc_profit.csv')
write.csv(everything_test_perc_profit, 'everything_test_perc_profit.csv')

#We need to remove the column for perc profit and save it as a test label
everything_test_label_perc_profit <- everything_test_perc_profit[,colnames(everything_test_perc_profit) %in% c('percProf')]
everything_test_perc_profit <- everything_test_perc_profit[,!colnames(everything_test_perc_profit) %in% c('percProf')]

#****************************************************************************
# Creating Training and Test DFs for everything_MoviesUSA for Percent Profit 
#***************************************************************************

#Reading in the Movies Spreadsheet 
everything_MoviesUSADiscretized <- read.csv("everything_MoviesUSADiscretized.csv", header = TRUE)

everything_discretized_percProf <- everything_MoviesUSADiscretized

#Subsetting
everything_discretized_perc_profit_negative <- subset(everything_discretized_percProf, percProfit == "negative")
everything_discretized_perc_profit_average <- subset(everything_discretized_percProf, percProfit == "average")
everything_discretized_perc_profit_high <- subset(everything_discretized_percProf, percProfit == "high")

#PercProf

sample_perc_profit_negative <- my_sample_fun(everything_discretized_perc_profit_negative, 174)
everything_discretized_train_perc_profit_negative <- my_train_set(everything_discretized_perc_profit_negative, sample_perc_profit_negative)
everything_discretized_test_perc_profit_negative <- my_test_set(everything_discretized_perc_profit_negative, sample_perc_profit_negative, 74)

sample_perc_profit_average <- my_sample_fun(everything_discretized_perc_profit_average, 174)
everything_discretized_train_perc_profit_average <- my_train_set(everything_discretized_perc_profit_average, sample_perc_profit_average)
everything_discretized_test_perc_profit_average <- my_test_set(everything_discretized_perc_profit_average, sample_perc_profit_average, 74)

sample_perc_profit_high <- my_sample_fun(everything_discretized_perc_profit_high, 174)
everything_discretized_train_perc_profit_high <- my_train_set(everything_discretized_perc_profit_high, sample_perc_profit_high)
everything_discretized_test_perc_profit_high <- my_test_set(everything_discretized_perc_profit_high, sample_perc_profit_high, 74)

#Combining the test and train dfs 
everything_discretized_train_perc_profit <- rbind(everything_discretized_train_perc_profit_negative, everything_discretized_train_perc_profit_average, everything_discretized_train_perc_profit_high)
everything_discretized_test_perc_profit <- rbind(everything_discretized_test_perc_profit_negative, everything_discretized_test_perc_profit_average, everything_discretized_test_perc_profit_high)

write.csv(everything_discretized_train_perc_profit, 'everything_discretized_train_perc_profit.csv')
write.csv(everything_discretized_test_perc_profit, 'everything_discretized_test_perc_profit.csv')

#We need to remove the column for perc profit and save it as a test label
everything_discretized_test_label_perc_profit <- everything_discretized_test_perc_profit[,colnames(everything_discretized_test_perc_profit) %in% c('percProf')]
everything_discretized_test_perc_profit <- everything_discretized_test_perc_profit[,!colnames(everything_discretized_test_perc_profit) %in% c('percProf')]


#*********************************************************************************************
# Code to Create Training and Testing Dataframe for everything_MoviesUSA for SCORE
#*********************************************************************************************

#This makes it so the budget and gross will not be in scientific notation 
options(scipen=999)

#Reading in the new dfs 
everything_MoviesUSA <- read.csv("everything_MoviesUSA.csv", header = TRUE)
everything_MoviesUSADiscretized <- read.csv("everything_MoviesUSADiscretized.csv", header = TRUE)

everything_score <- everything_MoviesUSA
#Saving the discretized score to the everything_MoviesUSA df 
everything_score$score = everything_MoviesUSADiscretized$score

#Ready to Create Training and Testing Datasets 
score_low <- subset(everything_score, score == 'low')
score_average <- subset(everything_score, score == 'average')
score_high <- subset(everything_score, score == 'high')

#We have 247 low scores, 485 average scores, and 257 high scores 
#Going to take 70% of 247 for the training data and the remaining 30% for the test data 
sample_score_low <- my_sample_fun(score_low, 173)
train_score_low <- my_train_set(score_low, sample_score_low)
test_score_low <- my_test_set(score_low, sample_score_low, 74)

sample_score_average <- my_sample_fun(score_average, 173)
train_score_average <- my_train_set(score_average, sample_score_average)
test_score_average <- my_test_set(score_average, sample_score_average, 74)

sample_score_high <- my_sample_fun(score_high, 173)
train_score_high <- my_train_set(score_high, sample_score_high)
test_score_high <- my_test_set(score_high, sample_score_high, 74)

#Combining the training and testing dfs together 
everything_train_score <- rbind(train_score_low, train_score_average, train_score_high)
everything_test_score <- rbind(test_score_low, test_score_average, test_score_high)

#Writing csv for train score discretized 
write.csv(everything_train_score,'everything_train_score.csv')
#Writing csv for test score discretized 
write.csv(everything_test_score,'everything_test_score.csv')

#Removing the score label from test_score and saving it 
everything_test_label_score <- everything_test_score[,colnames(everything_test_score) %in% 'score']
everything_test_score <- everything_test_score[,!colnames(everything_test_score) %in% 'score']

#*********************************************************************************************
# Code to Create Training and Testing Dataframe for everything_MoviesUSA for SCORE Normalized 
#*********************************************************************************************

#This makes it so the budget and gross will not be in scientific notation 
options(scipen=999)

#Reading in the new dfs 
everything_MoviesUSA <- read.csv("everything_MoviesUSA.csv", header = TRUE)
everything_MoviesUSADiscretized <- read.csv("everything_MoviesUSADiscretized.csv", header = TRUE)

everything_score <- everything_MoviesUSA
#Saving the discretized score to the everything_MoviesUSA df 
everything_score$score = everything_MoviesUSADiscretized$score

#Need to remove all factors 
norm_everything_score <- everything_score[,!colnames(everything_score) %in% c('director', 'rating', 'star', 'directorGender', 'genre', 'name', 'starGender', 'score')]
svm_norm = data.frame(apply(norm_everything_score, 2, function(x){x/max(x)}))

svm_norm$score = everything_score$score

#Ready to Create Training and Testing Datasets 
norm_score_low <- subset(svm_norm, score == 'low')
norm_score_average <- subset(svm_norm, score == 'average')
norm_score_high <- subset(svm_norm, score == 'high')

#We have 247 low scores, 485 average scores, and 257 high scores 
#Going to take 70% of 247 for the training data and the remaining 30% for the test data 
sample_score_low <- my_sample_fun(norm_score_low, 173)
norm_train_score_low <- my_train_set(norm_score_low, sample_score_low)
norm_test_score_low <- my_test_set(norm_score_low, sample_score_low, 74)

sample_score_average <- my_sample_fun(norm_score_average, 173)
norm_train_score_average <- my_train_set(norm_score_average, sample_score_average)
norm_test_score_average <- my_test_set(norm_score_average, sample_score_average, 74)

sample_score_high <- my_sample_fun(norm_score_high, 173)
norm_train_score_high <- my_train_set(norm_score_high, sample_score_high)
norm_test_score_high <- my_test_set(norm_score_high, sample_score_high, 74)

#Combining the training and testing dfs together 
norm_everything_train_score <- rbind(norm_train_score_low, norm_train_score_average, norm_train_score_high)
norm_everything_test_score <- rbind(norm_test_score_low, norm_test_score_average, norm_test_score_high)

#Writing csv for train score discretized 
write.csv(norm_everything_train_score,'norm_everything_train_score.csv')
#Writing csv for test score discretized 
write.csv(norm_everything_test_score,'norm_everything_test_score.csv')

#Removing the score label from test_score and saving it 
everything_test_label_score <- everything_test_score[,colnames(everything_test_score) %in% 'score']
everything_test_score <- everything_test_score[,!colnames(everything_test_score) %in% 'score']

norm_everything_test_label_score <- norm_everything_test_score[,colnames(norm_everything_test_score) %in% 'score']
norm_everything_test_score <- norm_everything_test_score[,!colnames(norm_everything_test_score) %in% 'score']

#*********************************************************************************************
# Code to Create Training and Testing Dataframe for everything_MoviesUSADiscretized for SCORE
#*********************************************************************************************

#This makes it so the budget and gross will not be in scientific notation 
options(scipen=999)

#Reading in the new dfs 
everything_MoviesUSADiscretized <- read.csv("everything_MoviesUSADiscretized.csv", header = TRUE)

#Ready to Create Training and Testing Datasets 
everything_discretized_score_low <- subset(everything_MoviesUSADiscretized, score == 'low')
everything_discretized_score_average <- subset(everything_MoviesUSADiscretized, score == 'average')
everything_discretized_score_high <- subset(everything_MoviesUSADiscretized, score == 'high')

#We have 247 low scores, 485 average scores, and 257 high scores 
#Going to take 70% of 247 for the training data and the remaining 30% for the test data 
sample_score_low <- my_sample_fun(everything_discretized_score_low, 173)
everything_discretized_train_score_low <- my_train_set(everything_discretized_score_low, sample_score_low)
everything_discretized_test_score_low <- my_test_set(everything_discretized_score_low, sample_score_low, 74)

sample_score_average <- my_sample_fun(everything_discretized_score_average, 173)
everything_discretized_train_score_average <- my_train_set(everything_discretized_score_average, sample_score_average)
everything_discretized_test_score_average <- my_test_set(everything_discretized_score_average, sample_score_average, 74)

sample_score_high <- my_sample_fun(everything_discretized_score_high, 173)
everything_discretized_train_score_high <- my_train_set(everything_discretized_score_high, sample_score_high)
everything_discretized_test_score_high <- my_test_set(everything_discretized_score_high, sample_score_high, 74)

#Combining the training and testing dfs together 
everything_discretized_train_score <- rbind(everything_discretized_train_score_low, everything_discretized_train_score_average, everything_discretized_train_score_high)
everything_discretized_test_score <- rbind(everything_discretized_test_score_low, everything_discretized_test_score_average, everything_discretized_test_score_high)

#Writing csv for train score discretized 
write.csv(everything_discretized_train_score,'everything_discretized_train_score.csv')
#Writing csv for test score discretized 
write.csv(everything_discretized_test_score,'everything_discretized_test_score.csv')

#Removing the score label from test_score and saving it 
everything_test_label_score <- everything_test_score[,colnames(everything_test_score) %in% 'score']
everything_test_score <- everything_test_score[,!colnames(everything_test_score) %in% 'score']


##########################################################################
#
#Association Rule Mining moviesUSA 
#
############################################################################

#Association Rule Mining for the moviesUSADiscretized dataframe 
library(arules)

#Setting working directory to my computer IST 707 Team Project

#Reading in the Movies Spreadsheet 
moviesUSADiscretized <- read.csv("moviesUSADiscretized.csv", header = TRUE)

#Chaning released to an ordered factor 
moviesUSADiscretized$released = as.ordered(moviesUSADiscretized$released)

suppVar <- 0.01
confVar <- 0.8
maxlenVar <- 3

budget <- unique(moviesUSADiscretized$budget)
gross <- unique(moviesUSADiscretized$gross)
runtime <- unique(moviesUSADiscretized$runtime)
score <- unique(moviesUSADiscretized$score)
votes <- unique(moviesUSADiscretized$votes)
profit <- unique(moviesUSADiscretized$profit)
genre <- unique(moviesUSADiscretized$genre)
rating <- unique(moviesUSADiscretized$rating)


stats <- list(
  "budget"=budget,
  "gross"=gross,
  "runtime"=runtime,
  "score"=score,
  "votes"=votes,
  "profit"=profit,
  "genre"=genre,
  "rating"=rating
)
rulesDF = data.frame()
spot = 1
for (stat in stats) {
  for (i in stat) {
    rhsVar <- paste(names(stats)[spot],"=",i,sep = "")
    rulesRight <- apriori(moviesUSADiscretized, parameter = list(supp = suppVar, conf = confVar, maxlen = maxlenVar), 
                          appearance = list (default = "lhs", rhs=rhsVar),control=list(verbose=F))
    
    options(digits=2)
    ## rulesByLift <- head(sort(rulesRight, by="lift"), 10)   
    ## rulesByCount <- head(sort(rulesRight, by="count"), 10)   
    ## arules::inspect(rulesRight)s
    ## arules::inspect(rulesByLift)
    ## arules::inspect(rulesByCount)
    if(length(rulesRight) > 0){
      miniruledf = data.frame(
        lhs = labels(lhs(rulesRight)),
        rhs = labels(rhs(rulesRight)), 
        rulesRight@quality)
      rulesDF <- rbind(miniruledf, rulesDF)
    }
  }
  spot <- spot + 1
}





#################################################################################################
#
# ASSOCIATION RULE MINING - EVERYTHING MOVIESUSA
#
#####################################################################################################
#Association Rule Mining for the moviesUSADiscretized dataframe 

#Reading in the Movies Spreadsheet 
everything_MoviesUSADiscretized <- read.csv("everything_MoviesUSADiscretized.csv", header = TRUE)

#Chaning released to an ordered factor 
everything_MoviesUSADiscretized$released = as.ordered(everything_MoviesUSADiscretized$released)

suppVar <- 0.01
confVar <- 0.8
maxlenVar <- 3

budget <- unique(everything_MoviesUSADiscretized$budget)
gross <- unique(everything_MoviesUSADiscretized$gross)
runtime <- unique(everything_MoviesUSADiscretized$runtime)
score <- unique(everything_MoviesUSADiscretized$score)
votes <- unique(everything_MoviesUSADiscretized$votes)
profit <- unique(everything_MoviesUSADiscretized$profit)
genre <- unique(everything_MoviesUSADiscretized$genre)
rating <- unique(everything_MoviesUSADiscretized$rating)
directorPopularity <- unique(everything_MoviesUSADiscretized$directorPopularity)
starPopularity <- unique(everything_MoviesUSADiscretized$starPopularity)
directorAge <- unique(everything_MoviesUSADiscretized$directorAge)
starAge <- unique(everything_MoviesUSADiscretized$starAge)

stats <- list(
  "budget"=budget,
  "gross"=gross,
  "runtime"=runtime,
  "score"=score,
  "votes"=votes,
  "profit"=profit,
  "genre"=genre,
  "rating"=rating,
  "directorPopularity" = directorPopularity,
  "starPopularity" = starPopularity
)
everything_rulesDF = data.frame()
spot = 1
for (stat in stats) {
  for (i in stat) {
    rhsVar <- paste(names(stats)[spot],"=",i,sep = "")
    rulesRight <- apriori(everything_MoviesUSADiscretized, parameter = list(supp = suppVar, conf = confVar, maxlen = maxlenVar), 
                          appearance = list (default = "lhs", rhs=rhsVar),control=list(verbose=F))
    
    options(digits=2)
    ## rulesByLift <- head(sort(rulesRight, by="lift"), 10)   
    ## rulesByCount <- head(sort(rulesRight, by="count"), 10)   
    ## arules::inspect(rulesRight)s
    ## arules::inspect(rulesByLift)
    ## arules::inspect(rulesByCount)
    if(length(rulesRight) > 0){
      miniruledf = data.frame(
        lhs = labels(lhs(rulesRight)),
        rhs = labels(rhs(rulesRight)), 
        rulesRight@quality)
      everything_rulesDF <- rbind(miniruledf, everything_rulesDF)
    }
  }
  spot <- spot + 1
}

##################################################################################################################################
##############################        DECISION TREES        ######################################################################
##################################################################################################################################

#For decision trees 
library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)
library(Cairo)

#Using Discretized Data for my Random Forest 

everything_discretized_train_score <- read.csv("everything_discretized_train_score.csv", header = TRUE)
everything_discretized_test_score <- read.csv("everything_discretized_test_score.csv", header = TRUE)

#Need to change released to an ordered factor 
dt_discretized_train_score <- everything_discretized_train_score
dt_discretized_test_score <- everything_discretized_test_score

dt_discretized_train_score$released = as.ordered(dt_discretized_train_score$released)
dt_discretized_test_score$released = as.ordered(dt_discretized_test_score$released)

#Removing title, star and director 
dt_discretized_train_score <- dt_discretized_train_score[,!colnames(dt_discretized_train_score) %in% c('title', 'star', 'director', 'released')]
dt_discretized_test_score <- dt_discretized_test_score[,!colnames(dt_discretized_test_score) %in% c('title', 'star', 'director', 'released')]

#Removing the score label from the test set and saving to a vector 
dt_discretized_test_score_label <- dt_discretized_test_score[,colnames(dt_discretized_test_score) %in% ('score')]
dt_discretized_test_score <- dt_discretized_test_score[,!colnames(dt_discretized_test_score) %in% ('score')]

#Starting decision Tree 
set.seed(576)
fit <- rpart(score ~ ., data = dt_discretized_train_score, method="class", control=rpart.control(minsplit=40, cp=0))
summary(fit)
predicted= predict(fit, dt_discretized_test_score, type="class")
(rpart_table_score <- table(dt_discretized_test_score_label, predicted))
#Accuracy  Average - 46%, High 76%, Low 69%
(miscalculation_rate <- 1 - sum(diag(rpart_table_score))/sum(rpart_table_score))
(accuracy_rate <- sum(diag(rpart_table_score))/sum(rpart_table_score))
#64% accuracy for predicting score 
rpart.plot(fit, main = 'Decision Tree for Score')

score <- c('Average', 'High', 'Low')
model <- replicate(3, "Decision Tree")
accuracy <- c(46, 76, 70)
dt_accuracy <- data.frame(score, model, accuracy)
(dt_accuracy_plot <- ggplot(dt_accuracy, aes(x = score, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c('Low', 'Average', 'High')))
(dt_accuracy_plot <- dt_accuracy_plot + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Accuracy Percentage for Decision Tree") + ylim(0, 100))


####################################################################################
###### Decision Tree Attempt 2 with information gain as the method #################
####################################################################################

#Decision Tree 1 
set.seed(576)
fitIG <- rpart(score ~ ., data = dt_discretized_train_score, method="class", parms = list(split = 'information'), 
               minsplit = 70, minbucket = 1, cp = -1)
summary(fitIG)
#Correctly classified the 10 Madison and 10 Hamilton Papers with upon 
#There was one error in the training data set with the author column removed 
predictedIG= predict(fitIG, dt_discretized_test_score, type="class")
#Checking results 
(table_ig_score <- table(dt_discretized_test_score_label, predictedIG))
#Accuracy average - 41, high = 74, low = 66
(miscalculation_rate <- 1 - sum(diag(table_ig_score))/sum(table_ig_score))
(accuracy_rate <- sum(diag(table_ig_score))/sum(table_ig_score))
#60% accuracy 
rpart.plot(fitIG, main = 'Decision Tree with Information Gain')
#Looks like the same result as fit 

score <- c('Average', 'High', 'Low')
model <- replicate(3, "Decision Tree Information Gain")
accuracy <- c(41, 74, 66)
ig_dt_accuracy <- data.frame(score, model, accuracy)
(ig_dt_accuracy_plot <- ggplot(ig_dt_accuracy, aes(x = score, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c('Low', 'Average', 'High')))
(ig_dt_accuracy_plot <- ig_dt_accuracy_plot + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Accuracy Percentage for Decision Tree Information Gain") + ylim(0, 100))


#Comparison of all models 
all_dt_score_models <- rbind(dt_accuracy, ig_dt_accuracy)
(all_dt_score_models_plot <- ggplot(all_dt_score_models, aes(fill = model, y = accuracy, x = score)) + geom_bar(stat = "identity", position = "dodge") + scale_x_discrete(limit = c('Low', 'Average', 'High')))
(all_dt_score_models_plot <- all_dt_score_models_plot + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Comparison of Accuracy Percentage for All everything MoviesUSA Score Decision Tree") + ylim(0, 100))

#Comparison of overall Accuracy 
overall_accuracy <- replicate(2, "Overall Accuracy")
model <- c("Decision Tree", "Decision Tree with Information Gain")
accuracy <- c(64, 60)
everything_overall_accuracy_dt <- data.frame(overall_accuracy, model, accuracy)
(everything_overall_accuracy_score_models_plot_dt <- ggplot(everything_overall_accuracy_dt, aes(fill = model, y = accuracy, x = overall_accuracy)) + geom_bar(stat = "identity", position = "dodge"))
(everything_all_models_plot_dt <- everything_overall_accuracy_score_models_plot_dt + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Comparison of Overall Accuracy Percentage for All everything MoviesUSA Score Decision Tree") + ylim(0, 100))


#**********************************************************************************
# kMeans for Score 
#**********************************************************************************

library(proxy)
library(RColorBrewer)
library(cluster)
library(factoextra)
library(cluster)
library(fpc)

#Trying to figure out the best number of clusters for kMeans 
norm_everything_train_score <- read.csv('norm_everything_train_score.csv', header = TRUE)
norm_everything_test_score <- read.csv('norm_everything_test_score.csv', header = TRUE)

#Combining everything together because there is no train and test data for this problem, just clustering 
norm_everything_kMeans <- rbind(norm_everything_train_score, norm_everything_test_score)

norm_everything_kMeans_label <- norm_everything_kMeans[,colnames(norm_everything_kMeans) %in% ('score')]
norm_everything_kMeans <- norm_everything_kMeans[,!colnames(norm_everything_kMeans) %in% ('score')]

#Creating a distance matrix with cosine similarity 
library(proxy)
dist <- dist(norm_everything_kMeans, method="cosine")

wss <- (nrow(dist)- 1)*sum(apply(dist, 2, var))
for (i in 2:20) wss [i] <- sum(kmeans(dist, centers = i)$withinss)
plot(1:20, wss, type ="b", xlab="Number of Clusters", ylab="Within group SS", main = "WSS for Distance Matrix with Cosine Similarity for kMeans Norm") 
#Looks like 4 - 6 clusters might be the best 

#K-means attempt 1 with cosine: 
set.seed(10)
cosine1 <- kmeans(dist, 4, nstart = 50)
cosine1
fviz_cluster(cosine1, data = dist, main = 'Cluster Plot for Dist k = 4')
#K-means clustering with 4 clusters of sizes 248, 181, 58, 254
#comparing results 
table(norm_everything_kMeans_label, cosine1$cluster)
plotcluster(norm_everything_kMeans, cosine1$cluster, main = "Plot Cluster of Cosine Distance k = 4")

#K-means attempt 2 with cosine: 
set.seed(10)
cosine2 <- kmeans(dist, 5, nstart = 50)
cosine2
fviz_cluster(cosine2, data = dist, main = "fviz Visualization of Cosine Distance k = 5")
#Created 6 clusters of sizes 312, 128, 135, 127, 131, 156
#comparing results 
table(norm_everything_kMeans_label, cosine2$cluster)
#Does not look like to clustered by genre 

plotcluster(norm_everything_kMeans, cosine2$cluster, main = "Plot Cluster of Cosine Distance k = 5")

#K-means attempt 3 with cosine: 
set.seed(10)
cosine3 <- kmeans(dist, 6, nstart = 50)
cosine3
fviz_cluster(cosine3, data = dist, main = "fviz Visualization of Cosine Distance k = 6")
#Created with 7 clusters of sizes 129, 281, 117, 124, 121, 119, 98
#comparing results 
table(norm_everything_kMeans_label, cosine3$cluster)
#Does not look like to clustered by genre 


#Lowering dimensions to votes, budget, runtime, profit

reduced_norm_everything_kMeans <- norm_everything_kMeans[,colnames(norm_everything_kMeans) %in% c('votes', 'budget', 'runtime')]

reduced_dist <- dist(reduced_norm_everything_kMeans, method="cosine")

wss <- (nrow(dist)- 1)*sum(apply(reduced_dist, 2, var))
for (i in 2:20) wss [i] <- sum(kmeans(reduced_dist, centers = i)$withinss)
plot(1:20, wss, type ="b", xlab="Number of Clusters", ylab="Within group SS", main = "WSS for Distance Matrix with Cosine Similarity for kMeans Reduced Distance Norm") 
#Looks like 3 to 5 

#K-means attempt 1 with cosine: 
set.seed(10)
reduced_cosine1 <- kmeans(reduced_dist, 4, nstart = 50)
reduced_cosine1
fviz_cluster(reduced_cosine1, data = reduced_dist, main = 'Cluster Plot for Dist k = 4 Reduced')
#K-means clustering with 4 clusters of sizes 248, 181, 58, 254
#comparing results 
table(norm_everything_kMeans_label, reduced_cosine1$cluster)
plotcluster(reduced_norm_everything_kMeans, reduced_cosine1$cluster, main = "Plot Cluster of Cosine Distance k = 4 Reduced")

#K-means attempt 2 with cosine: 
set.seed(10)
reduced_cosine2 <- kmeans(reduced_dist, 5, nstart = 50)
reduced_cosine2
fviz_cluster(reduced_cosine2, data = reduced_dist, main = "fviz Visualization of Cosine Distance k = 5 Reduced")
#Created 6 clusters of sizes 312, 128, 135, 127, 131, 156
#comparing results 
table(norm_everything_kMeans_label, reduced_cosine2$cluster)
#Does not look like to clustered by genre 

plotcluster(norm_everything_kMeans, cosine2$cluster, main = "Plot Cluster of Cosine Distance k = 5 Reduced")

#K-means attempt 3 with cosine: 
set.seed(10)
reduced_cosine3 <- kmeans(reduced_dist, 6, nstart = 50)
reduced_cosine3
fviz_cluster(reduced_cosine3, data = reduced_dist, main = "fviz Visualization of Cosine Distance k = 6 Reduced")
#Created 6 clusters of sizes 312, 128, 135, 127, 131, 156
#comparing results 
table(norm_everything_kMeans_label, reduced_cosine3$cluster)
#Does not look like to clustered by genre 

plotcluster(norm_everything_kMeans, cosine3$cluster, main = "Plot Cluster of Cosine Distance k = 6 Reduced")

#K-means attempt 4 with cosine: 
set.seed(10)
reduced_cosine4 <- kmeans(reduced_dist, 10, nstart = 50)
reduced_cosine4
fviz_cluster(reduced_cosine4, data = reduced_dist, main = "fviz Visualization of Cosine Distance k = 7 Reduced")
#Created 6 clusters of sizes 312, 128, 135, 127, 131, 156
#comparing results 
table(norm_everything_kMeans_label, reduced_cosine4$cluster)
#Does not look like to clustered by genre 

plotcluster(norm_everything_kMeans, cosine3$cluster, main = "Plot Cluster of Cosine Distance k = 6 Reduced")


wss <- (nrow(reduced_norm_everything_kMeans)- 1)*sum(apply(reduced_norm_everything_kMeans, 2, var))
for (i in 2:20) wss [i] <- sum(kmeans(reduced_norm_everything_kMeans, centers = i)$withinss)
plot(1:20, wss, type ="b", xlab="Number of Clusters", ylab="Within group SS", main = "WSS for kMeans Norm Reduced")
#looks 3 - 7 clusters might be the right amount 


#K-means attempt 1 without distance measure 
set.seed(10)
kMeans1 <- kmeans(reduced_norm_everything_kMeans, 4, nstart = 50)
kMeans1
#Created 5 clusters of sizes 320, 74, 294, 145, 156
fviz_cluster(kMeans1, data = reduced_norm_everything_kMeans, main = "fviz Visualization of kMeans Norm k = 4 Reduced")
#comparing results 
table(norm_everything_kMeans_label, kMeans1$cluster)

#K-means attempt 2 without distance measure 
set.seed(10)
kMeans2 <- kmeans(reduced_norm_everything_kMeans, 5, nstart = 50)
kMeans2
#Created 5 clusters of sizes 320, 74, 294, 145, 156
fviz_cluster(kMeans2, data = reduced_norm_everything_kMeans, main = "fviz Visualization of kMeans Norm k = 5 Reduced")
#comparing results 
table(norm_everything_kMeans_label, kMeans2$cluster)

#K-means attempt 3 without distance measure 
set.seed(10)
kMeans3 <- kmeans(reduced_norm_everything_kMeans, 6, nstart = 50)
kMeans3
#Created 5 clusters of sizes 320, 74, 294, 145, 156
fviz_cluster(kMeans3, data = reduced_norm_everything_kMeans, main = "fviz Visualization of kMeans Norm k = 6 Reduced")
#comparing results 
table(norm_everything_kMeans_label, kMeans3$cluster)

#############################################################################################################################################
#########################################     HClust                                            #############################################
#############################################################################################################################################
set.seed(10)

hc1 <- hclust(reduced_dist, method = "average")
plot(hc1)
cut4 <- cutree(hc1, 4)
table(norm_everything_kMeans_label, cut4)
rect.hclust(hc1, k = 4,  border=3:4)

cut5 <- cutree(hc1, 5)
table(norm_everything_kMeans_label, cut5)
rect.hclust(hc1, k = 5,  border=3:4)

cut10 <- cutree(hc1, 10)
table(norm_everything_kMeans_label, cut10)
rect.hclust(hc1, k = 6,  border=3:4)


##################################################
#
# kNN
#
####################################################

#kNN MODEL 1
library(class)
#Need to remove the label for the number_train df 

#***************************************************
# kNN requires Numeric Data Only
# Remove the label from the training data 
# Save Label in a train_label vector 
#***************************************************
library(ggplot2)
#Setting working directory to my computer IST 707 Team Project
#Reading in the Movies Spreadsheet 
everything_kNN_train_score <- read.csv("everything_train_score.csv", header = TRUE)
everything_kNN_test_score <- read.csv("everything_test_score.csv", header= TRUE)

#Removing all columns that are factors: director, genre, name, rating, star, writer
everything_kNN_train_score <- everything_kNN_train_score[,!colnames(everything_kNN_train_score) %in% c('director', 'genre', 'name', 'rating', 'star', 'writer', 'directorGender', 'starGender')]
everything_kNN_test_score <- everything_kNN_test_score[,!colnames(everything_kNN_test_score) %in% c('director', 'genre', 'name', 'rating', 'star', 'writer', 'directorGender', 'starGender')]

everything_kNN_train_with_label <- everything_kNN_train_score[,!colnames(everything_kNN_train_score) %in% c('director', 'genre', 'name', 'rating', 'star', 'writer', 'directorGender', 'starGender')]

#Removing the classification label from BOTH the Train and Test dfs and storing it 
everything_kNN_train_score_label <- everything_kNN_train_score[,colnames(everything_kNN_train_score) %in% ('score')]
everything_kNN_train_score <- everything_kNN_train_score[,!colnames(everything_kNN_train_score) %in% ('score')]

everything_kNN_test_score_label <- everything_kNN_test_score[,colnames(everything_kNN_test_score) %in% ('score')]
everything_kNN_test_score <- everything_kNN_test_score[,!colnames(everything_kNN_test_score) %in% ('score')]

#Chaning everything to numeric from int 
everything_kNN_train_score <- everything_kNN_train_score %>% mutate_if(is.integer, as.numeric)
everything_kNN_test_score <- everything_kNN_test_score %>% mutate_if(is.integer, as.numeric)

# Setting k as the sqrt of the number of rows of the dataset 
(k <- round(sqrt(741))) # k = 27
set.seed(1)

everything_kNN <- class::knn(train = everything_kNN_train_score, test = everything_kNN_test_score, 
                             cl = everything_kNN_train_score_label, k = k, prob = TRUE)


(everything_kNN_table <- table(everything_kNN, everything_kNN_test_score_label))
#Accuracy - Average - 43%, High 47%, Low - 45%
(miscalculation_rate <- 1 - sum(diag(everything_kNN_table))/sum(everything_kNN_table))
(accuracy_rate <- sum(diag(everything_kNN_table))/sum(everything_kNN_table))
#The model's overall accuracy is 45% 

score <- c('Average', 'High', 'Low')
model <- replicate(3, "kNN k = 27 - everything")
accuracy <- c(43, 47, 45)
everything_kNN_accuracy_k_27 <- data.frame(score, model, accuracy)
(everything_kNN_accuracy_k_27_plot <- ggplot(everything_kNN_accuracy_k_27, aes(x = score, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c('Low', 'Average', 'High')))
(everything_kNN_accuracy_k_27_plot <- everything_kNN_accuracy_k_27_plot + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Accuracy Percentage for kNN k = 27 for everything MoviesUSA")+ ylim(0, 100))

#*************************************************************************************
#To determine the best k values kNN was run using the caret package 
#*************************************************************************************

#kNN with caret
library(caret)
#tuneLength tells is to include 20 differnt possible k values 
#trainControl sets up a 5-fold cross validation 
set.seed(1)
everything_model_kNN <- train(score~., data = everything_kNN_train_with_label, method = "knn", 
                              trControl = trainControl("cv", number = 10), 
                              tuneLength = 20)



plot(everything_model_kNN, main = 'Chart of Best K Values for kNN everything MoviesUSA for Score')
everything_model_kNN$bestTune
#It shows that my best K is 23... 
k <- 23
set.seed(1)
everything_kNN_model2 <- class::knn(train = everything_kNN_train_score, test = everything_kNN_test_score, cl = everything_kNN_train_score_label, k = k, prob = TRUE)
(everything_kNN_table_model2 <- table(everything_kNN_model2, everything_kNN_test_score_label))
#Accuracy - average - 42%, high = 45%, low - 53%
(miscalculation_rate <- 1 - sum(diag(everything_kNN_table_model2))/sum(everything_kNN_table_model2))
(accuracy_rate <- sum(diag(everything_kNN_table_model2))/sum(everything_kNN_table_model2))
#The model's overall accuracy is 46% 

score <- c('Average', 'High', 'Low')
model <- replicate(3, "kNN k = 23 - everything")
accuracy <- c(42, 45, 53)
everything_kNN_accuracy_k_23 <- data.frame(score, model, accuracy)
(everything_kNN_accuracy_k_23_plot <- ggplot(everything_kNN_accuracy_k_23, aes(x = score, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c('Low', 'Average', 'High')))
(everything_kNN_accuracy_k_23_plot <- everything_kNN_accuracy_k_23_plot + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Accuracy Percentage for kNN k = 23 for everything MoviesUSA")+ ylim(0, 100))

# Reducing 
#Trying it the attributes showed best Votes and R 'votes', 'runtime', 'percProf', 'directorPopularity', 'score'
everything_kNN_score_train_cl_model1_with_label <- everything_kNN_train_with_label[,colnames(everything_kNN_train_with_label) %in% c('votes', 'runtime', 'percProf', 'directorPopularity', 'score')]

#Finding the best k value 
#set.seed(1)
set.seed(1)
everything_model_kNN_cl_model1 <- train(score~., data = everything_kNN_score_train_cl_model1_with_label, method = "knn", trControl = trainControl("cv", number = 10), 
                                        tuneLength = 20)

plot(everything_model_kNN_cl_model1, main = 'Chart of Best K Values for kNN everything MoviesUSA CL Model 1')
everything_model_kNN_cl_model1$bestTune
#It shows that my best K is 43... 

#Creating train and test sets
everything_kNN_train_cl_model1 <- everything_kNN_train_score[,colnames(everything_kNN_train_score) %in% c('votes', 'runtime', 'percProf', 'directorPopularity')]
everything_kNN_test_cl_model1 <- everything_kNN_test_score[,colnames(everything_kNN_test_score) %in% c('votes', 'runtime', 'percProf', 'directorPopularity')]

k <- 43
set.seed(1)
everything_kNN_cl_model1 <- class::knn(train = everything_kNN_train_cl_model1, test = everything_kNN_test_cl_model1, cl = everything_kNN_train_score_label, k = k, prob = TRUE)
(everything_kNN_table_cl_model1 <- table(everything_kNN_cl_model1, everything_kNN_test_score_label))
#Accuracy - average - 16%, high - 77%, low - 84%
(miscalculation_rate <- 1 - sum(diag(everything_kNN_table_cl_model1))/sum(everything_kNN_table_cl_model1))
(accuracy_rate <- sum(diag(everything_kNN_table_cl_model1))/sum(everything_kNN_table_cl_model1))
#The model's overall accuracy is 59% 

score <- c('Average', 'High', 'Low')
model <- replicate(3, "kNN k = 43 CL Model1")
accuracy <- c(16, 77, 84)
everything_kNN_accuracy_k_43_cl_model1 <- data.frame(score, model, accuracy)
(everything_kNN_accuracy_plot_k_43_cl_model1 <- ggplot(everything_kNN_accuracy_k_43_cl_model1, aes(x = score, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c('Low', 'Average', 'High')))
(everything_kNN_accuracy_plot_k_43_cl_model1 <- everything_kNN_accuracy_plot_k_43_cl_model1 + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Accuracy Percentage for kNN k = 43 for everything MoviesUSA CL Model1")+ ylim(0, 100))

# CL Model 2 
# Reducing 
#Trying it the attributes showed best my InfGain, Gini and MDL --- Votes and Runtime 
everything_kNN_train_cl_model2 <- everything_kNN_train_score[,colnames(everything_kNN_train_score) %in% c('votes', 'runtime', 'percProf', 'directorPopularity', 'profit', 'gross')]
everything_kNN_test_cl_model2 <- everything_kNN_test_score[,colnames(everything_kNN_test_score) %in% c('votes', 'runtime', 'percProf', 'directorPopularity', 'profit', 'gross')]

#Finding the best k value 
#set.seed(1)
everything_kNN_train_with_label_cl_model2 <- everything_kNN_train_with_label[, colnames(everything_kNN_train_with_label) %in% c('votes', 'runtime', 'percProf', 'directorPopularity', 'profit', 'score', 'gross')]

set.seed(1)
everything_model_kNN_cl_model2 <- train(score~., data = everything_kNN_train_with_label_cl_model2, method = "knn", trControl = trainControl("cv", number = 10), 
                                        tuneLength = 20)

plot(everything_model_kNN_cl_model2, main = 'Chart of Best K Values for kNN everything MoviesUSA CL Model 2')
everything_model_kNN_cl_model2$bestTune
#It shows that my best K is 17... 
k <- 17
set.seed(1)
everything_kNN_cl_model2 <- class::knn(train = everything_kNN_train_cl_model2, test = everything_kNN_test_cl_model2, cl = everything_kNN_train_score_label, k = k, prob = TRUE)
(everything_kNN_table_cl_model2 <- table(everything_kNN_cl_model2, everything_kNN_test_score_label))
#Accuracy - Average - 38%, 30%m, 32%
(miscalculation_rate <- 1 - sum(diag(everything_kNN_table_cl_model2))/sum(everything_kNN_table_cl_model2))
(accuracy_rate <- sum(diag(everything_kNN_table_cl_model2))/sum(everything_kNN_table_cl_model2))
#The model's overall accuracy is 43% 

score <- c('Average', 'High', 'Low')
model <- replicate(3, "kNN k = 17 CL Model2")
accuracy <- c(38, 30, 32)
everything_kNN_accuracy_k_17_cl_model2 <- data.frame(score, model, accuracy)
(everything_kNN_accuracy_plot_k_17_cl_model2 <- ggplot(everything_kNN_accuracy_k_17_cl_model2, aes(x = score, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c('Low', 'Average', 'High')))
(everything_kNN_accuracy_plot_k_17_cl_model2 <- everything_kNN_accuracy_plot_k_17_cl_model2 + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Accuracy Percentage for kNN k = 17 for everything MoviesUSA CL Model2")+ ylim(0, 100))


# CL Model 3 
# Reducing 
#Trying it the attributes showed best my InfGain, Gini and MDL --- Votes and Runtime 
everything_kNN_train_cl_model3 <- everything_kNN_train_score[,colnames(everything_kNN_train_score) %in% c('votes', 'runtime', 'percProf', 'directorAge', 'gross', 'prof')]
everything_kNN_test_cl_model3 <- everything_kNN_test_score[,colnames(everything_kNN_test_score) %in% c('votes', 'runtime', 'percProf', 'directorAge', 'gross', 'prof')]

#Finding the best k value 
#set.seed(1)
everything_kNN_train_with_label_cl_model3 <- everything_kNN_train_with_label[, colnames(everything_kNN_train_with_label) %in% c('votes', 'runtime', 'percProf', 'directorAge', 'gross', 'prof', 'score')]

set.seed(1)
everything_model_kNN_cl_model3 <- train(score~., data = everything_kNN_train_with_label_cl_model3, method = "knn", trControl = trainControl("cv", number = 10), 
                                        tuneLength = 20)

plot(everything_model_kNN_cl_model3, main = 'Chart of Best K Values for kNN everything MoviesUSA CL Model 3')
everything_model_kNN_cl_model3$bestTune
#It shows that my best K is 31... 
k <- 31
set.seed(1)
everything_kNN_cl_model3 <- class::knn(train = everything_kNN_train_cl_model3, test = everything_kNN_test_cl_model3, cl = everything_kNN_train_score_label, k = k, prob = TRUE)
(everything_kNN_table_cl_model3 <- table(everything_kNN_cl_model3, everything_kNN_test_score_label))
#Accuracy - Average - 35. high - 35, low 45
(miscalculation_rate <- 1 - sum(diag(everything_kNN_table_cl_model3))/sum(everything_kNN_table_cl_model3))
(accuracy_rate <- sum(diag(everything_kNN_table_cl_model3))/sum(everything_kNN_table_cl_model3))
#The model's overall accuracy is 38% 

score <- c('Average', 'High', 'Low')
model <- replicate(3, "kNN k = 31 CL Model3")
accuracy <- c(35, 35, 45)
everything_kNN_accuracy_k_31_cl_model3 <- data.frame(score, model, accuracy)
(everything_kNN_accuracy_plot_k_31_cl_model3 <- ggplot(everything_kNN_accuracy_k_31_cl_model3, aes(x = score, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c('Low', 'Average', 'High')))
(everything_kNN_accuracy_plot_k_31_cl_model3 <- everything_kNN_accuracy_plot_k_31_cl_model3 + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Accuracy Percentage for kNN k = 31 for everything MoviesUSA CL Model3")+ ylim(0, 100))

#Comparison of all models 
everything_all_kNN_score_models <- rbind(everything_kNN_accuracy_k_27, everything_kNN_accuracy_k_23, everything_kNN_accuracy_k_43_cl_model1)
(everything_all_kNN_score_models_plot <- ggplot(everything_all_kNN_score_models, aes(fill = model, y = accuracy, x = score)) + geom_bar(stat = "identity", position = "dodge") + scale_x_discrete(limit = c('Low', 'Average', 'High')))
(everything_all_kNN_score_models_plot <- everything_all_kNN_score_models_plot + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Comparison of Accuracy Percentage for All everything MoviesUSA Score kNN") + ylim(0, 100))

#Comparison of overall Accuracy 
overall_accuracy <- replicate(6, "Overall Accuracy")
model <- c("kNN k = 27", "kNN k = 23", "kNN-CL Model 1  k = 43 ", "kNN-CL Model 2 k = 17", "kNN-CL Model 3 k = 31")
accuracy <- c(45, 46, 58, 43, 38)
everything_overall_accuracy_kNN <- data.frame(overall_accuracy, model, accuracy)
(everything_overall_accuracy_score_models_plot_kNN <- ggplot(everything_overall_accuracy_kNN, aes(fill = model, y = accuracy, x = overall_accuracy)) + geom_bar(stat = "identity", position = "dodge"))
(everything_all_nb_models_plot_kNN <- everything_overall_accuracy_score_models_plot_kNN + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Comparison of Overall Accuracy Percentage for All everything MoviesUSA Score kNN") + ylim(0, 100))


###################################
#
# Naive Bayes Score
#
#####################################


#******************************************************
# Trying to predict Score for everything_moviesUSA df
#******************************************************
library(ggplot2)

#Reading in the Movies Spreadsheet 
everything_nb_train_score <- read.csv("everything_train_score.csv", header = TRUE)
everything_nb_test_score <- read.csv("everything_test_score.csv", header= TRUE)

#Removing the score label from test_score and saving it 
everything_nb_test_label_score <- everything_nb_test_score[,colnames(everything_nb_test_score) %in% 'score']
everything_nb_test_score <- everything_nb_test_score[,!colnames(everything_nb_test_score) %in% 'score']

#*****************************************
#Naive Bayes Only Wants Numeric Data 
#*****************************************

#Removing everything with a factor! 
everything_nb_train_score <- everything_nb_train_score[,!colnames(everything_nb_train_score) %in% c('director', 'star', 'directorGender', 'genre', 'name', 'rating', 'starGender')]
everything_nb_test_score <- everything_nb_test_score[,!colnames(everything_nb_test_score) %in% c('director', 'star', 'directorGender', 'genre', 'name', 'rating', 'starGender')]
#Changing all integers to numeric 
everything_nb_train_score <- everything_nb_train_score %>% mutate_if(is.integer, as.numeric)
everything_nb_test_score <- everything_nb_test_score %>% mutate_if(is.integer, as.numeric)

## ********************************************************************
## USING NAIVE BAYES TO PREDICT SCORE for the everything_MoviesUSA df
## ********************************************************************

#Naive Bayes 
library(naivebayes)
score_nb <- naive_bayes(score ~., everything_nb_train_score)
prediction = predict(score_nb, everything_nb_test_score, type = c("class"))
(naive_bayes_table_score <- table(prediction, everything_nb_test_label_score))
#42% Average, 49% High, 80% Low Accuracy  
(miscalculation_rate <- 1 - sum(diag(naive_bayes_table_score))/sum(naive_bayes_table_score))
(accuracy_rate <- sum(diag(naive_bayes_table_score))/sum(naive_bayes_table_score))
#58% accuracy Overall Accuracy 

score <- c("low", 'average', 'high')
model <- replicate(3, "Naive Bayes")
accuracy <- c(80, 42, 49)
everything_nb_accuracy <- data.frame(score, model, accuracy)
(everything_nb_accuracy_plot <- ggplot(everything_nb_accuracy, aes(x = score, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c('low', 'average', 'high')))
(everything_nb_accuracy_plot <- everything_nb_accuracy_plot + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Accuracy Percentage for Score everything MoviesUSA Naive Bayes") + ylim(0, 100))

#************************************************************************************************************
# Using Method CORElearn attrEval to see which are the best variables to use
#************************************************************************************************************

#TO figure out the attributes that are best to include we are running the attrEval from CORElearn 
library(CORElearn)
Method.CORElearn <- CORElearn::attrEval(score ~ ., data=everything_nb_train_score,  
                                        estimator = "InfGain")

(Method.CORElearn)
#Shows that votes, runtime, percProf, directorPopularity,  are the best to use 
Method.CORElearn2 <- CORElearn::attrEval(score ~ ., data=everything_nb_train_score,  estimator = "Gini")
(Method.CORElearn2)
#Shows that votes, runtime, directorPopularity, gross, profit, and percProf are the best to use 
Method.CORElearn3 <- CORElearn::attrEval(score ~ ., data=everything_nb_train_score,  estimator = "GainRatio")
(Method.CORElearn3)
#SHows votes, runtime, gross, directorAge, prof, percProf are the best to use 
Method.CORElearn4 <- CORElearn::attrEval(score ~ ., data=everything_nb_train_score,  estimator = "MDL")
(Method.CORElearn4)
#votes, runtime, directorPopularity, percProf are the best to use -- Same as Inf Gain 

#Trying it the attributes showed best my InfGain --- votes, runtime, percProf, directorPopularity,  
everything_score_train_cl_model1 <- everything_nb_train_score[,colnames(everything_nb_train_score) %in% c('votes', 'runtime', 'percProf', 'directorPopularity',  'score')]
everything_score_test_cl_model1 <- everything_nb_test_score[,colnames(everything_nb_test_score) %in% c('votes', 'runtime', 'percProf', 'directorPopularity')]

everything_score_cl_model1 <- CoreModel(score ~., everything_score_train_cl_model1,
                                        model = 'bayes')



everything_nb_pred_score_cl_model1 <- predict(everything_score_cl_model1, everything_score_test_cl_model1, type = c("class"))
(everything_score_nb_table_cl_model1 <- table(everything_nb_pred_score_cl_model1, everything_nb_test_label_score))
#29% Average, 76% High, 73% low 
(miscalculation_rate <- 1 - sum(diag(everything_score_nb_table_cl_model1))/sum(everything_score_nb_table_cl_model1))
(accuracy_rate <- sum(diag(everything_score_nb_table_cl_model1))/sum(everything_score_nb_table_cl_model1))
#59% accuracy with votes, runtime, percProf, directorPopularity,      _____________________   Best one yet 

score <- c("low", 'average', 'high')
model <- replicate(3, "Naive Bayes-CL Model 1")
accuracy <- c(73, 29, 76)
everything_nb_accuracy_cl_model1 <- data.frame(score, model, accuracy)
(everything_nb_accuracy_plot_cl_model1 <- ggplot(everything_nb_accuracy_cl_model1, aes(x = score, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c('low', 'average', 'high')))
(everything_nb_accuracy_plot_cl_model1 <- everything_nb_accuracy_plot_cl_model1 + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Accuracy Percentage for Score everything MoviesUSA NB CoreLearn - Model 1") + ylim(0, 100))


#Trying it the attributes showed best my Gini --- votes, runtime, directorPopularity, gross, profit, and percProf
everything_score_train_cl_model2 <- everything_nb_train_score[,colnames(everything_nb_train_score) %in% c('votes', 'runtime', 'percProf', 'directorPopularity', 'profit', 'score', 'gross')]
everything_score_test_cl_model2 <- everything_nb_test_score[,colnames(everything_nb_test_score) %in% c('votes', 'runtime', 'percProf', 'directorPopularity', 'profit', 'gross')]

everything_score_cl_model2 <- CoreModel(score ~., everything_score_train_cl_model2, model = 'bayes')
everything_nb_pred_score_cl_model2 <- predict(everything_score_cl_model2, everything_score_test_cl_model2, type = c("class"))
(everything_score_nb_table_cl_model2 <- table(everything_nb_pred_score_cl_model2, everything_nb_test_label_score))
#average = 23%, high - 77%, low - 74%
(miscalculation_rate <- 1 - sum(diag(everything_score_nb_table_cl_model2))/sum(everything_score_nb_table_cl_model2))
(accuracy_rate <- sum(diag(everything_score_nb_table_cl_model2))/sum(everything_score_nb_table_cl_model2))
#58% accuracy with votes, runtime, directorPopularity, gross, profit, and percProf      _____________________   Less than above 

score <- c("low", 'average', 'high')
model <- replicate(3, "Naive Bayes-CL Model 2")
accuracy <- c(74, 23, 77)
everything_nb_accuracy_cl_model2 <- data.frame(score, model, accuracy)
(everything_nb_accuracy_plot_cl_model2 <- ggplot(everything_nb_accuracy_cl_model2, aes(x = score, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c('low', 'average', 'high')))
(everything_nb_accuracy_plot_cl_model2 <- everything_nb_accuracy_plot_cl_model2 + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Accuracy Percentage for Score everything MoviesUSA NB CoreLearn - Model 2") + ylim(0, 100))



#Trying it the attributes showed best my GainRatio --- votes, runtime, gross, directorAge, , percProf 
everything_score_train_cl_model3 <- everything_nb_train_score[,colnames(everything_nb_train_score) %in% c('votes', 'runtime', 'percProf', 'directorAge', 'gross', 'score')]
everything_score_test_cl_model3 <- everything_nb_test_score[,colnames(everything_nb_test_score) %in% c('votes', 'runtime', 'percProf', 'directorAge', 'gross' )]

everything_score_cl_model3 <- CoreModel(score ~., everything_score_train_cl_model3, model = 'bayes')
everything_nb_pred_score_cl_model3 <- predict(everything_score_cl_model3, everything_score_test_cl_model3, type = c("class"))
(everything_score_nb_table_cl_model3 <- table(everything_nb_pred_score_cl_model3, everything_nb_test_label_score))
#average - 32%, high - 78%, low - 70%
(miscalculation_rate <- 1 - sum(diag(everything_score_nb_table_cl_model3))/sum(everything_score_nb_table_cl_model3))
(accuracy_rate <- sum(diag(everything_score_nb_table_cl_model3))/sum(everything_score_nb_table_cl_model3))
#60% accuracy with votes, runtime, gross, directorAge, , percProf      _____________________   Best one yet 


score <- c("low", 'average', 'high')
model <- replicate(3, "Naive Bayes-CL Model 3")
accuracy <- c(70, 32, 78)
everything_nb_accuracy_cl_model3 <- data.frame(score, model, accuracy)
(everything_nb_accuracy_plot_cl_model3 <- ggplot(everything_nb_accuracy_cl_model3, aes(x = score, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c('low', 'average', 'high')))
(everything_nb_accuracy_plot_cl_model3 <- everything_nb_accuracy_plot_cl_model3 + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Accuracy Percentage for Score everything MoviesUSA NB CoreLearn - Model 3") + ylim(0, 100))


# Trying it with the attributes showed best by MDL votes, runtime, directorPopularity, percProf are the best to use 
everything_score_train_cl_model4 <- everything_nb_train_score[,colnames(everything_nb_train_score) %in% c('votes', 'runtime', 'percProf', 'directorPopularity', 'score')]
everything_score_test_cl_model4 <- everything_nb_test_score[,colnames(everything_nb_test_score) %in% c('votes', 'runtime', 'percProf', 'directorPopularity', 'profit')]

everything_score_cl_model4 <- CoreModel(score ~., everything_score_train_cl_model4, model = 'bayes')
everything_nb_pred_score_cl_model4 <- predict(everything_score_cl_model4, everything_score_test_cl_model4, type = c("class"))
(everything_score_nb_table_cl_model4 <- table(everything_nb_pred_score_cl_model4, everything_nb_test_label_score))
#average - 30%, high - 76%, low - 73%
(miscalculation_rate <- 1 - sum(diag(everything_score_nb_table_cl_model4))/sum(everything_score_nb_table_cl_model4))
(accuracy_rate <- sum(diag(everything_score_nb_table_cl_model4))/sum(everything_score_nb_table_cl_model4))
#59% accuracy with votes, runtime, directorPopularity, percProf     _____________________   Same as above 

score <- c("low", 'average', 'high')
model <- replicate(3, "Naive Bayes-CL Model 4")
accuracy <- c(73, 30, 76)
everything_nb_accuracy_cl_model4 <- data.frame(score, model, accuracy)
(everything_nb_accuracy_plot_cl_model4 <- ggplot(everything_nb_accuracy_cl_model4, aes(x = score, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c('low', 'average', 'high')))
(everything_nb_accuracy_plot_cl_model4 <- everything_nb_accuracy_plot_cl_model4 + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Accuracy Percentage for Score everything MoviesUSA NB CoreLearn - Model 4") + ylim(0, 100))

#Comparison of all models 
all_nb_score_everything_models <- rbind(everything_nb_accuracy, everything_nb_accuracy_cl_model1, everything_nb_accuracy_cl_model3)
(all_nb_score_everything_models_plot <- ggplot(all_nb_score_everything_models, aes(fill = model, y = accuracy, x = score)) + geom_bar(stat = "identity", position = "dodge") + scale_x_discrete(limit = c('low', 'average', 'high')))
(all_nb_score_everything_models_plot <- all_nb_score_everything_models_plot + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Comparison of Accuracy Percentage for All everything MoviesUSA Score Naive Bayes") + ylim(0, 100))

#COmparison of overall Accuracy 
overall_accuracy <- replicate(3, "Overall Accuracy")
model <- c("Naive Bayes", "Naive Bayes-CL Model 1", "Naive Bayes-CL Model 3")
accuracy <- c(58, 59, 60)
overall_accuracy_everything_nb <- data.frame(overall_accuracy, model, accuracy)
(overall_accuracy_score_everything_models_plot <- ggplot(overall_accuracy_everything_nb, aes(fill = model, y = accuracy, x = overall_accuracy)) + geom_bar(stat = "identity", position = "dodge"))
(all_nb_score_everything_models_plot <- overall_accuracy_score_everything_models_plot + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Comparison of Overall Accuracy Percentage for All everything MoviesUSA Score Naive Bayes") + ylim(0, 100))




#******************************************************************************************************
# the model with the attributes determined by GainRatio was the best at 60%
#******************************************************************************************************

##########################################################
#
# Random Forest 
#
############################################################

#************************************************************
# RANDOM FOREST 
#************************************************************

#Using Discretized Data for my Random Forest 

everything_discretized_train_score <- read.csv("everything_discretized_train_score.csv", header = TRUE)
everything_discretized_test_score <- read.csv("everything_discretized_test_score.csv", header = TRUE)

#Need to change released to an ordered factor 
rf_discretized_train_score <- everything_discretized_train_score
rf_discretized_test_score <- everything_discretized_test_score

rf_discretized_train_score$released = as.ordered(rf_discretized_train_score$released)
rf_discretized_test_score$released = as.ordered(rf_discretized_test_score$released)

#Removing title, star and director 
rf_discretized_train_score <- rf_discretized_train_score[,!colnames(rf_discretized_train_score) %in% c('title', 'star', 'director', 'released', 'genre')]
rf_discretized_test_score <- rf_discretized_test_score[,!colnames(rf_discretized_test_score) %in% c('title', 'star', 'director', 'released', 'genre')]

#Removing the score label from the test set and saving to a vector 
rf_discretized_test_score_label <- rf_discretized_test_score[,colnames(rf_discretized_test_score) %in% ('score')]
rf_discretized_test_score <- rf_discretized_test_score[,!colnames(rf_discretized_test_score) %in% ('score')]


str(rf_discretized_test_score)
str(rf_discretized_train_score)
#Running Random Forest 
#******************************************************************
#Random Forest with cvCoreModel
#******************************************************************

#more appropriate for large data sets one can specify just the target variable
#Predicts with 20 trees and a 10-fold cross validation 
modelRF <- cvCoreModel("score", rf_discretized_train_score, model="rf", rfNoTrees = 20, fold = 10, stratified = TRUE, returnModel = TRUE, maxThreads = 1)
modelRF$avgs
print(modelRF)
pred <- predict(modelRF, rf_discretized_test_score, type = "class")
(table_model_RF <- table(rf_discretized_test_score_label, pred))
#Accuracy Avg - 35%, High - 77%, Low - 70%
(miscalculation_rate <- 1 - sum(diag(table_model_RF))/sum(table_model_RF))
(accuracy_rate <- sum(diag(table_model_RF))/sum(table_model_RF))
#Increased to 61%
plot(modelRF, rf_discretized_train_score, rfGraphType=c("attrEval"), clustering = NULL)

score <- c('Average', 'High', 'Low')
model <- replicate(3, "Random Forest - CV Model 1")
accuracy <- c(33, 77, 70)
random_Forest_accuracy_cv_model1 <- data.frame(score, model, accuracy)
(random_Forest_accuracy_plot_cv_model1 <- ggplot(random_Forest_accuracy_cv_model1, aes(x = score, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c('Low', 'Average', 'High')))
(random_Forest_accuracy_plot_cv_model1 <- random_Forest_accuracy_plot_cv_model1 + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Accuracy Percentage for Random Forest for Score CV Model 1") + ylim(0, 100))



#Running it with the randomForest package
set.seed(173)
(random_forest_model <- randomForest(score ~., data = rf_discretized_train_score))
random_forest_model_pred <- predict(random_forest_model, rf_discretized_test_score)
(random_forest_pred_table <- table(random_forest_model_pred, rf_discretized_test_score_label))
#Accuracy Avg - 47%, High - 76%, Low - 68%
(miscalculation_rate <- 1 - sum(diag(random_forest_pred_table))/sum(random_forest_pred_table))
(accuracy_rate <- sum(diag(random_forest_pred_table))/sum(random_forest_pred_table))
#This model has the highest at 64%

score <- c('Average', 'High', 'Low')
model <- replicate(3, "Random Forest - Model 1")
accuracy <- c(47, 76, 68)
random_Forest_accuracy <- data.frame(score, model, accuracy)
(random_Forest_accuracy_plot <- ggplot(random_Forest_accuracy, aes(x = score, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c('Low', 'Average', 'High')))
(random_Forest_accuracy_plot <- random_Forest_accuracy_plot + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Accuracy Percentage for Random Forest for Score Model 1") + ylim(0, 100))


#Running Random Forest with only votes, runtime, budget, directorPopularity to predict score 
rf_discretized_train_score_reduced <- rf_discretized_train_score[,colnames(rf_discretized_train_score) %in% c('votes', 'runtime', 'budget', 'directorPopularity', 'score')]
rf_discretized_test_score_reduced <- rf_discretized_test_score[,colnames(rf_discretized_test_score) %in% c('votes', 'runtime', 'budget', 'directorPopularity')]

#Running it with the randoForest package 
set.seed(173)
(reduced_random_forest_model <- randomForest(score ~., data = rf_discretized_train_score_reduced))
reduced_random_forest_model_pred <- predict(reduced_random_forest_model, rf_discretized_test_score_reduced)
(reduced_random_forest_pred_table <- table(reduced_random_forest_model_pred, rf_discretized_test_score_label))
#Accuracy Avg - 27%, High - 76%, Low - 66%
(miscalculation_rate <- 1 - sum(diag(reduced_random_forest_pred_table))/sum(reduced_random_forest_pred_table))
(accuracy_rate <- sum(diag(reduced_random_forest_pred_table))/sum(reduced_random_forest_pred_table))
#This model has the highest at 56%

score <- c('Average', 'High', 'Low')
model <- replicate(3, "Random Forest - Model 2")
accuracy <- c(20, 76, 66)
reduced_random_Forest_accuracy <- data.frame(score, model, accuracy)
(reduced_random_Forest_accuracy_plot <- ggplot(reduced_random_Forest_accuracy, aes(x = score, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c('Low', 'Average', 'High')))
(reduced_random_Forest_accuracy_plot <- reduced_random_Forest_accuracy_plot + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Accuracy Percentage for Random Forest for Score Model 2") + ylim(0, 100))

#Combining all Models 

#Comparison of all models 
all_rf_score_models <- rbind(random_Forest_accuracy_cv_model1, random_Forest_accuracy, reduced_random_Forest_accuracy)
(all_rf_score_models_plot <- ggplot(all_rf_score_models, aes(fill = model, y = accuracy, x = score)) + geom_bar(stat = "identity", position = "dodge") + scale_x_discrete(limit = c('Low', 'Average', 'High')))
(all_rf_score_models_plot <- all_rf_score_models_plot + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Comparison of Accuracy Percentage for All everything MoviesUSA Score Random Forest") + ylim(0, 100))

#Comparison of overall Accuracy 
overall_accuracy <- replicate(3, "Overall Accuracy")
model <- c("Random Forest - CV Model 1", "Random Forest - Model 1", "Random Forest - Model 2")
accuracy <- c(61, 64, 56)
everything_overall_accuracy_rf <- data.frame(overall_accuracy, model, accuracy)
(everything_overall_accuracy_score_models_plot_rf <- ggplot(everything_overall_accuracy_rf, aes(fill = model, y = accuracy, x = overall_accuracy)) + geom_bar(stat = "identity", position = "dodge"))
(everything_all_nb_models_plot_rf <- everything_overall_accuracy_score_models_plot_rf + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Comparison of Overall Accuracy Percentage for All everything MoviesUSA Score Random Forest") + ylim(0, 100))

###########################
#*****************
#SVM
#*****************
##############################

#******************************************************
# Trying to predict Score for everything_moviesUSA df
#******************************************************
library(ggplot2)
#Setting working directory to my computer IST 707 Team Project

#SVM Model Normalized 
#Reading in the Movies Spreadsheet 
norm_everything_svm_train_score <- read.csv("norm_everything_train_score.csv", header = TRUE)
norm_everything_svm_test_score <- read.csv("norm_everything_test_score.csv", header= TRUE)

#Removing the score label from test_score and saving it 
norm_everything_svm_test_label_score <- norm_everything_svm_test_score[,colnames(norm_everything_svm_test_score) %in% 'score']
norm_everything_svm_test_score <- norm_everything_svm_test_score[,!colnames(norm_everything_svm_test_score) %in% 'score']

#*****************************************
#SVM Only Wants Numeric Data 
#*****************************************
#SVM model 1
norm_svm_train_radial <- svm(score ~., data = norm_everything_svm_train_score, kernel = "radial", cost = .1, scale = FALSE)
norm_svm_train_radial_pred <- predict(norm_svm_train_radial, norm_everything_svm_test_score, type = "class")
(norm_svm_radial_table <- table(norm_everything_svm_test_label_score, norm_svm_train_radial_pred))
(miscalculation_rate <- 1 - sum(diag(norm_svm_radial_table))/sum(norm_svm_radial_table))
(accuracy_rate <- sum(diag(norm_svm_radial_table))/sum(norm_svm_radial_table))
#The model's overall accuracy is 51%, 
# Accuracy average = 80, high 16, low 57 
score <- c('Average', 'High', 'Low')
model <- replicate(3, "svm_radial")
accuracy <- c(80, 16, 57)
svm_radial_accuracy <- data.frame(score, model, accuracy)
(svm_radial_plot <- ggplot(svm_radial_accuracy, aes(x = score, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c("Low", 'Average', 'High')))
(svm_radial_plot <- svm_radial_plot + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Accuracy Percentage for SVM Radial Model for Score") + ylim(0, 100))

#SVM model 2
norm_svm_train_polynomial <- svm(score ~., data = norm_everything_svm_train_score, kernel = "polynomial", cost = .1, scale = FALSE)
norm_svm_train_polynomial_pred <- predict(norm_svm_train_polynomial, norm_everything_svm_test_score, type = "class")
(norm_svm_polynomial_table <- table(norm_everything_svm_test_label_score, norm_svm_train_polynomial_pred))
(miscalculation_rate <- 1 - sum(diag(norm_svm_polynomial_table))/sum(norm_svm_polynomial_table))
(accuracy_rate <- sum(diag(norm_svm_polynomial_table))/sum(norm_svm_polynomial_table))
#The model's overall accuracy is 42%, 
# Accuracy average = 39, high 7, low 80 
score <- c('Average', 'High', 'Low')
model <- replicate(3, "svm_polynomial")
accuracy <- c(39, 7, 80)
svm_polynomial_accuracy <- data.frame(score, model, accuracy)
(svm_polynomial_plot <- ggplot(svm_polynomial_accuracy, aes(x = score, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c("Low", 'Average', 'High')))
(svm_polynomial_plot <- svm_polynomial_plot + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Accuracy Percentage for SVM Polynomial Model for Score") + ylim(0, 100))

#SVM model 3
norm_svm_train_linear <- svm(score ~., data = norm_everything_svm_train_score, kernel = "linear", cost = .1, scale = FALSE)
norm_svm_train_linear_pred <- predict(norm_svm_train_linear, norm_everything_svm_test_score, type = "class")
(norm_svm_linear_table <- table(norm_everything_svm_test_label_score, norm_svm_train_linear_pred))
(miscalculation_rate <- 1 - sum(diag(norm_svm_linear_table))/sum(norm_svm_linear_table))
(accuracy_rate <- sum(diag(norm_svm_linear_table))/sum(norm_svm_linear_table))
#The model's overall accuracy is 54%, 
# Accuracy average = 80, high 27, low 55 
score <- c('Average', 'High', 'Low')
model <- replicate(3, "svm_linear")
accuracy <- c(80, 27, 55)
svm_linear_accuracy <- data.frame(score, model, accuracy)
(svm_linear_plot <- ggplot(svm_linear_accuracy, aes(x = score, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c("Low", 'Average', 'High')))
(svm_linear_plot <- svm_linear_plot + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Accuracy Percentage for SVM Linear Model for Score") + ylim(0, 100))

#Comparison of all models 
all_svm_score_everything_models <- rbind(svm_radial_accuracy, svm_polynomial_accuracy, svm_linear_accuracy)
(all_svm_score_everything_models_plot <- ggplot(all_svm_score_everything_models, aes(fill = model, y = accuracy, x = score)) + geom_bar(stat = "identity", position = "dodge") + scale_x_discrete(limit = c('Low', 'Average', 'High')))
(all_svm_score_everything_models_plot <- all_svm_score_everything_models_plot + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Comparison of Accuracy Percentage for All everything MoviesUSA Score SVM") + ylim(0, 100))

#COmparison of overall Accuracy 
overall_accuracy <- replicate(3, "Overall Accuracy")
model <- c('svm_radial', 'svm_polynomial', 'svm_linear')
accuracy <- c(51, 42, 54)
overall_accuracy_everything_svm <- data.frame(overall_accuracy, model, accuracy)
(overall_accuracy_score_everything_models_plot <- ggplot(overall_accuracy_everything_svm, aes(fill = model, y = accuracy, x = overall_accuracy)) + geom_bar(stat = "identity", position = "dodge"))
(all_nb_score_everything_models_plot <- overall_accuracy_score_everything_models_plot + ylab("Accuracy Percentage") + xlab("Score") + ggtitle("Comparison of Overall Accuracy Percentage for All everything MoviesUSA Score SVM") + ylim(0, 100))


## ***************************************
## CREATING powerfulDF
## ***************************************
## ************************************
## DATA PREP: Creating POWERFUL_DF
## ************************************
## This DF collects a bunch of numeric stats for stars & directors
## Based on both their movie(s) scores & movie(s) profit

## ====================================
## STEP 1: LOAD THE DATA
## ====================================
library(dplyr)

everything_MoviesUSA="everything_MoviesUSA.csv"
everything_MoviesUSADiscretized="everything_MoviesUSADiscretized.csv"
MoviesFileDF <- read.csv(everything_MoviesUSA, header = TRUE)
MoviesFileDFDiscretized <- read.csv(everything_MoviesUSADiscretized, header = TRUE)
df <- MoviesFileDF

## ====================================
## STEP 2: AGGREGATE & MATH THE DATA
## ====================================
## FOR STARS **************************
## & SCORES ***************************
starAvgScore <- aggregate(df$score, by=list(star=df$star), FUN=mean)
starMaxScore <- aggregate(df$score, by=list(star=df$star), FUN=max)
starMinScore <- aggregate(df$score, by=list(star=df$star), FUN=min)
starFrequency <- aggregate(df$score, by=list(star=df$star), FUN=length)
starPower <- cbind(starAvgScore, starMaxScore[,2], starMinScore[,2], starFrequency[,2])

## & PercPROF **************************
starAvgPercProf <- aggregate(df$percProf, by=list(star=df$star), FUN=mean)
starMaxPercProf <- aggregate(df$percProf, by=list(star=df$star), FUN=max)
starMinPercProf <- aggregate(df$percProf, by=list(star=df$star), FUN=min)

## combining & renaming
starPower <- cbind(starAvgScore, starMaxScore[,2], starMinScore[,2], starFrequency[,2],
                   starAvgPercProf[,2], starMaxPercProf[,2], starMinPercProf[,2])
colnames(starPower) <- c('star', 'starScoreAvg', 'starScoreMax','starScoreMin', 'starFrequency',
                         'starPPAvg', 'starPPMax', 'starPPMin')

## FOR DIRECTORS ***********************
## & SCORES ****************************
directorAvgScore <- aggregate(df$score, by=list(director=df$director), FUN=mean)
directorMaxScore <- aggregate(df$score, by=list(director=df$director), FUN=max)
directorMinScore <- aggregate(df$score, by=list(director=df$director), FUN=min)
directorFrequency <- aggregate(df$score, by=list(director=df$director), FUN=length)
directorPower <- cbind(directorAvgScore, directorMaxScore[,2], directorMinScore[,2], directorFrequency[,2])

## & PercPROF ***************************
directorAvgPercProf <- aggregate(df$percProf, by=list(director=df$director), FUN=mean)
directorMaxPercProf <- aggregate(df$percProf, by=list(director=df$director), FUN=max)
directorMinPercProf <- aggregate(df$percProf, by=list(director=df$director), FUN=min)

## combining & renaming
directorPower <- cbind(directorAvgScore, directorMaxScore[,2], directorMinScore[,2], directorFrequency[,2],
                       directorAvgPercProf[,2], directorMaxPercProf[,2], directorMinPercProf[,2])
colnames(directorPower) <- cbind('director', 'directorScoreAvg', 'directorScoreMax', 'directorScoreMin', 'directorFrequency',
                                 'directorPPAvg', 'directorPPMax', 'directorPPMin')


# ## FOR writers ***********************
# ## & SCORES ****************************
# writerAvgScore <- aggregate(df$score, by=list(writer=df$writer), FUN=mean)
# writerMaxScore <- aggregate(df$score, by=list(writer=df$writer), FUN=max)
# writerMinScore <- aggregate(df$score, by=list(writer=df$writer), FUN=min)
# writerFrequency <- aggregate(df$score, by=list(writer=df$writer), FUN=length)
# writerPower <- cbind(writerAvgScore, writerMaxScore[,2], writerMinScore[,2], writerFrequency[,2])
# 
# ## & PercPROF ***************************
# writerAvgPercProf <- aggregate(df$percProf, by=list(writer=df$writer), FUN=mean)
# writerMaxPercProf <- aggregate(df$percProf, by=list(writer=df$writer), FUN=max)
# writerMinPercProf <- aggregate(df$percProf, by=list(writer=df$writer), FUN=min)
# 
# ## combining & renaming
# writerPower <- cbind(writerAvgScore, writerMaxScore[,2], writerMinScore[,2], writerFrequency[,2],
#                      writerAvgPercProf[,2], writerMaxPercProf[,2], writerMinPercProf[,2])
# colnames(writerPower) <- cbind('writer', 'writerScoreAvg', 'writerScoreMax', 'writerScoreMin', 'writerFrequency',
#                                'writerPPAvg', 'writerPPMax', 'writerPPMin')
# 
# 

## ====================================
## STEP 3: PUT IT ALL TOGETHER & SAVE
## ====================================
powerfulDF <- MoviesFileDF[,c('name', 'director', 'directorPopularity', 'budget', 'star', 'percProf', 'profit','gross', 'score' )]
powerfulDF <- starPower %>% full_join(powerfulDF)
powerfulDF <- directorPower %>% full_join(powerfulDF)
# powerfulDF <- directorPower %>% full_join(powerfulDF)
str(powerfulDF)
head(powerfulDF)

write.csv(powerfulDF, 'powerfulDF.csv')

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## ################################################################################################################
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## *************************************************
## MODELING: ASSOCIATION RULE MINING TO GIVE RECS
## *************************************************
## ================================================
## STEP 1: LOAD THE DATA & LIBRARIES
## ================================================

library(arules)
#setwd("/Users/kosburn 1/syracuse/IST707/project/FINAL")

# moviesUSADiscretized <- read.csv("everything_moviesUSADiscretized.csv", header = TRUE)
moviesUSADiscretized <- read.csv("moviesUSADiscretized_2.csv", header = TRUE)
if(colnames(moviesUSADiscretized)[1] == 'X') {
  moviesUSADiscretized <- moviesUSADiscretized[,-1]  
}

#removing variables I don't want 
#colstoremove <- c('starAge', 'starYearBorn', 'starGender','directorGender', 'directorYearBorn', 'directorAge', 'released', 'year' )
colstoremove <- c('profit','starAge', 'starYearBorn', 'starGender','directorGender', 'directorYearBorn', 'directorAge', 'released', 'year' )
moviesUSADiscretized<-moviesUSADiscretized[,!colnames(moviesUSADiscretized) %in% colstoremove]
suppVar <- 0.01
confVar <- 0.8
## For actors and directors
## confVar <- 0.08
maxlenVar <- 3

budget <- unique(moviesUSADiscretized$budget)
gross <- unique(moviesUSADiscretized$gross)
runtime <- unique(moviesUSADiscretized$runtime)
score <- unique(moviesUSADiscretized$score)
votes <- unique(moviesUSADiscretized$votes)
profit <- unique(moviesUSADiscretized$profit)
genre <- unique(moviesUSADiscretized$genre)
rating <- unique(moviesUSADiscretized$rating)

## FOR ALL VARS
stats <- list(
  "budget"=budget,
  "gross"=gross,
  "runtime"=runtime,
  "score"=score,
  "votes"=votes,
  "profit"=profit,
  "genre"=genre,
  "rating"=rating
)

## FOR STARS
# stats <- unique(moviesUSADiscretized$star)

## FOR DIRECTORS
# stats <- unique(moviesUSADiscretized$director)

## ===========================================================
## THE LOOP
## ===========================================================
rulesDF = data.frame()
spot = 1
for (stat in stats) {
  for (i in stat) {
    ## FOR VARS
    rhsVar <- paste(names(stats)[spot],"=",i,sep = "")
    ## FOR STARS
    #rhsVar <- paste("star",names(stats)[spot],"=",i,sep = "")
    ## FOR DIRECTORS
    # rhsVar <- paste("director",names(stats)[spot],"=",i,sep = "")
    rulesRight <- apriori(moviesUSADiscretized, parameter = list(supp = suppVar, conf = confVar, maxlen = maxlenVar), 
                          appearance = list (default = "lhs", rhs=rhsVar),control=list(verbose=F))
    
    options(digits=2)
    if(length(rulesRight) > 0){
      miniruledf = data.frame(
        lhs = labels(lhs(rulesRight)),
        rhs = labels(rhs(rulesRight)), 
        rulesRight@quality)
      rulesDF <- rbind(miniruledf, rulesDF)
    }
  }
  spot <- spot + 1
}
write.csv(rulesDF, file = "ARMvariables.csv")



## ***************************************
## MODELING: NAIVE BAYES TO PREDICT SCORE
## ***************************************
## Getting 81% accuracy to predict score "high" or score "low"
## ======================================
## STEP 1: LOAD THE DATA
## ======================================
library(e1071)
#setwd("/Users/kosburn 1/syracuse/IST707/project/CLEAN")
everything_MoviesUSAcsv="everything_MoviesUSA.csv"
everything_MoviesUSADiscretizedcsv="everything_MoviesUSADiscretized.csv"
powerfulDFcsv="powerfulDF.csv"

everything_MoviesUSA <- read.csv(everything_MoviesUSAcsv, header = TRUE)
everything_MoviesUSADiscretized <- read.csv(everything_MoviesUSADiscretizedcsv, header = TRUE)
powerfulDF <- read.csv(powerfulDFcsv, header = TRUE)

## ======================================
## STEP 2: FORMAT THE WAY YOU WANT
## ======================================
## PUT DF OF CHOICE INTO BRILLIANTLY NAMED VARIABLE
df <- powerfulDF
df <- powerfulDF[,c('directorScoreAvg','starScoreAvg', 'gross', 'score')]

## PUT DISCRETIZED Y VARIABLE INTO THE DATAFRAME 
df$score <- discretize(everything_MoviesUSA$score, method = "fixed", breaks = c(0, 5.9, Inf), labels = c("low", "high"))

## ======================================
## STEP 3: MAKE TEST & TRAIN SET
## ======================================
set.seed(42)
train_set = df[sample(nrow(df), 650),]
test_set = setdiff(df, train_set)

## TRAIN SET: Removing but saving Nominals
nominalsToRemove <- c('director', 'star', 'name')
# train_set_nominals <- train_set[,nominalsToRemove]
train_set <- train_set[,!colnames(train_set) %in% nominalsToRemove]

## TEST SET: Removing but saving Nominals AND Labels
test_label <- c('score')
# test_set_nominals <- test_set[,nominalsToRemove]
test_set <- test_set[,!colnames(test_set) %in% nominalsToRemove]
test_set_no_label <- test_set[,!colnames(test_set) %in% test_label]

## ======================================
## STEP 4: RUN THE MODEL
## ======================================
set.seed(42)
NB_e1071<-naiveBayes(score~., data=train_set, na.action = na.pass)
NB_e1071_Pred <- predict(NB_e1071, test_set_no_label)
pred_table <- table(NB_e1071_Pred,test_set$score)
correct <- sum(diag(pred_table))
(accuracy <- correct/sum(pred_table))




## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## ################################################################################################################
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## *************************************************
## MODELING: KMEANS TO PREDICT PERCENT PROFIT
## *************************************************
## UNSUPERVISED 
## ================================================
## STEP 1: LOAD THE DATA & LIBRARIES
## ================================================
library(proxy)
library(RColorBrewer)
library(cluster)
library(factoextra)
library(cluster)
library(fpc)

#setwd("/Users/kosburn 1/syracuse/IST707/project/FINAL")
#Trying to figure out the best number of clusters for kMeans
norm_everything_train_percProf <- read.csv('norm_everything_train_percProf.csv', header = TRUE)
norm_everything_test_percProf <- read.csv('norm_everything_test_percProf.csv', header = TRUE)

#Combining everything together because there is no train and test data for this problem, just clustering
norm_everything_kMeans <- rbind(norm_everything_train_percProf, norm_everything_test_percProf)

norm_everything_kMeans <- norm_everything_kMeans[,!colnames(norm_everything_kMeans) %in% c('profit', 'gross')]

norm_everything_kMeans_label <- norm_everything_kMeans[,colnames(norm_everything_kMeans) %in% ('percProf')]
norm_everything_kMeans <- norm_everything_kMeans[,!colnames(norm_everything_kMeans) %in% ('percProf')]
norm_everything_kMeans <- norm_everything_kMeans[,!colnames(norm_everything_kMeans) %in% c('X', 'X.1')]


wss <- (nrow(norm_everything_kMeans)- 1)*sum(apply(norm_everything_kMeans, 2, var))
for (i in 2:20) wss [i] <- sum(kmeans(norm_everything_kMeans, centers = i)$withinss)
plot(1:20, wss, type ="b", xlab="Number of Clusters", ylab="Within group SS", main = "WSS for kMeans for kMeans Scaled")
#looks 5 - 6 clusters might be the right amount

#Creating a distance matrix with cosine similarity
library(proxy)
dist <- dist(norm_everything_kMeans, method="cosine")

wss <- (nrow(dist)- 1)*sum(apply(dist, 2, var))
for (i in 2:20) wss [i] <- sum(kmeans(dist, centers = i)$withinss)
plot(1:20, wss, type ="b", xlab="Number of Clusters", ylab="Within group SS", main = "WSS for Distance Matrix with Cosine Similarity for kMeans Scaled")
#Looks like 5 - 6 clusters might be the bestF

thing<- kmeans(dist, 4, nstart=50)

fviz_cluster(thing, data = dist, main = 'Cluster Plot for Dist k = 4')

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## ################################################################################################################
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## *************************************************
## MODELING: DECISION TREES TO PREDICT PERCENT PROFIT
## *************************************************
## SUPERVISED | LABELS IN TRAIN, NOT IN TEST
## ================================================
## STEP 1: LOAD THE DATA & LIBRARIES
## ================================================
library(rpart)
library(rpart.plot)
# setwd("/Users/kosburn 1/syracuse/IST707/project/FINAL")

DT_train_percProf <- read.csv("everything_discretized_train_perc_profit.csv", header = TRUE)
DT_test_percProf <- read.csv("everything_discretized_test_perc_profit.csv", header= TRUE)

#Removing all columns that are factors: director, genre, name, rating, star, writer
colstoremove <- c('director', 'star', 'title','X.1', 'X' )
# colstoremove <- c('directorAge','released','runtime', 'starAge','year', 'starPopularity','director', 'star', 'name','X.1', 'X', 'starScore', 'directorGender', 'genre', 'rating', 'starGender')
DT_train_percProf <- DT_train_percProf[,!colnames(DT_train_percProf) %in% 
                                         colstoremove]
DT_test_percProf <- DT_test_percProf[,!colnames(DT_test_percProf) %in% 
                                       colstoremove]

## ================================================
## STEP 2: PREP DATA FOR MODEL
## ================================================
DT_train_percProf_dataonly <- DT_train_percProf[,!colnames(DT_train_percProf) %in% ('percProfit')]
DT_test_percProf_dataonly <- DT_test_percProf[,!colnames(DT_test_percProf) %in% ('percProfit')]
# LABELS ONLY
DT_train_percProf_label <- DT_train_percProf[,colnames(DT_train_percProf) %in% ('percProfit')]
DT_test_percProf_label <- DT_test_percProf[,colnames(DT_test_percProf) %in% ('percProfit')]

#Removing gross and profit
DT_train_percProf <- DT_train_percProf[,!colnames(DT_train_percProf) %in% c('gross', 'profit')]
DT_test_percProf <- DT_test_percProf[,!colnames(DT_test_percProf) %in% c('gross', 'profit')]


## ================================================
## STEP 3: RUN MODEL
## ================================================
## ************************************************
## ATTEMPT 1 -- INPUT: ALL THE THINGS -- 53%
## ************************************************

set.seed(42)
fit <- rpart(percProfit ~ ., data = DT_train_percProf, method="class", control=rpart.control(minsplit=50, cp=0))
summary(fit)

predicted= predict(fit, DT_test_percProf, type="class")
(rpart_table_score <- table(DT_test_percProf_label, predicted))
(miscalculation_rate <- 1 - sum(diag(rpart_table_score))/sum(rpart_table_score))
(accuracy_rate <- sum(diag(rpart_table_score))/sum(rpart_table_score))
rpart.plot(fit, main = 'Decision Tree for Percent Profit without Star and Director')


## ************************************************
## ATTEMPT 2 -- NB with Leaves -- 52%
## ************************************************

train_percProf_discretized_dt <- DT_train_percProf
test_percProf_discretized_dt <- DT_test_percProf
test_label_percProf_discretized <- DT_test_percProf_label
# build decision tree with naive Bayes in the leaves
# more appropriate for large data sets one can specify just the target variable
library(CORElearn)
modelDT <- CoreModel("percProfit", train_percProf_discretized_dt, model="tree", modelType=4)
print(modelDT)
pred <- predict(modelDT, test_percProf_discretized_dt, type = "class")
(table_model_DT <- table(test_label_percProf_discretized, pred))
(miscalculation_rate <- 1 - sum(diag(table_model_DT))/sum(table_model_DT))
(accuracy_rate <- sum(diag(table_model_DT))/sum(table_model_DT))

## ************************************************
## ATTEMPT 3 -- Information Gain -- 50%
## ************************************************
fitIG <- rpart(percProfit ~ ., data = train_percProf_discretized_dt, method="class", parms = list(split = 'information'), 
               minsplit = 70, minbucket = 1, cp = -1)
summary(fitIG)
predictedIG= predict(fitIG, test_percProf_discretized_dt, type="class")
(table_ig_percProf <- table(test_label_percProf_discretized, predictedIG))
(miscalculation_rate <- 1 - sum(diag(table_ig_percProf))/sum(table_ig_percProf))
(accuracy_rate <- sum(diag(table_ig_percProf))/sum(table_ig_percProf))
rpart.plot(fitIG, main = 'Decision Tree with Information Gain for Everyting except for Star, Director and Title')
#Looks like the same result as fit 

## ================================================
## STEP 3: VISUALIZE
## ================================================
## ************************************************
## ATTEMPT 1 
## ************************************************
## 53
## 42, 61, 57
percProf <- c('Average', 'High', 'Negative')
model <- replicate(3, "DTattempt1")
accuracy <- c(42, 61, 57)
dt1_accuracy <- data.frame(percProf, model, accuracy)
(dt1_plot <- ggplot(dt1_accuracy, aes(x = percProf, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c("Negative", 'Average', 'High')))
(dt1_plot <- dt1_plot + ylab("Accuracy Percentage") + xlab("Percent Profit") + ggtitle("Accuracy Percentage for Decision Tree Model for Percent Profit (First Attempt)") + ylim(0, 100))

## ************************************************
## ATTEMPT 2 NB+Leaves
## ************************************************
## 53
## 43, 66, 49
percProf <- c('Average', 'High', 'Negative')
model <- replicate(3, "DTattempt2")
accuracy <- c(43, 66, 49)
dt2_accuracy <- data.frame(percProf, model, accuracy)
(dt2_plot <- ggplot(dt2_accuracy, aes(x = percProf, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c("Negative", 'Average', 'High')))
(dt2_plot <- dt2_plot + ylab("Accuracy Percentage") + xlab("Percent Profit") + ggtitle("Accuracy Percentage for Decision Tree Model for Percent Profit (NB+LEAVES)") + ylim(0, 100))


## ************************************************
## ATTEMPT 3 IG
## ************************************************
## 50
## 31, 62, 58
percProf <- c('Average', 'High', 'Negative')
model <- replicate(3, "DTattempt3")
accuracy <- c(31, 62, 58)
dt3_accuracy <- data.frame(percProf, model, accuracy)
(dt3_plot <- ggplot(dt3_accuracy, aes(x = percProf, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c("Negative", 'Average', 'High')))
(dt3_plot <- dt3_plot + ylab("Accuracy Percentage") + xlab("Percent Profit") + ggtitle("Accuracy Percentage for Decision Tree Model for Percent Profit (INFO GAIN)") + ylim(0, 100))

## ************************************************
## ATTEMPT ALL
## ************************************************

#Comparison of all models
all_DF_percProf_everything_models <- rbind(dt1_accuracy, dt2_accuracy, dt3_accuracy)
(all_DF_percProf_everything_models_plot <- ggplot(all_DF_percProf_everything_models, aes(fill = model, y = accuracy, x = percProf)) + geom_bar(stat = "identity", position = "dodge") + scale_x_discrete(limit = c('Negative', 'Average', 'High')))


## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## *************************************************
## MODELING: KNN TO PREDICT PERCENT PROFIT
## *************************************************
## 47% accuracy | DF USED: 'everything_USA' 
## ================================================
## STEP 1: LOAD THE DATA & LIBRARIES
## ================================================
library(ggplot2)
library(class)
library(dplyr)

#Reading in the Movies Spreadsheet 
kNN_train_percProf <- read.csv("everything_train_perc_profit.csv", header = TRUE)
kNN_test_percProf <- read.csv("everything_test_perc_profit.csv", header= TRUE)

df_train <- kNN_train_percProf
df_test <- kNN_test_percProf

## REMOVE ANY POSSIBLE Xs in df_train
for(name in colnames(df_train)){
  if(grepl('X', name)){
    df_train <- df_train[,!colnames(df_train) %in% name]
    print(name)    
  }
}
## REMOVE ANY POSSIBLE Xs in df_test
for(name in colnames(df_test)){
  if(grepl('X', name)){
    df_test <- df_test[,!colnames(df_test) %in% name]
  }
}


## =================================================
## STEP 2: PREP DATA FOR SPECIFIC MODEL
## =================================================
#***************************************************
# kNN requires Numeric Data Only
# Remove the label from the training data 
# Save Label in a train_label vector 
#***************************************************
# #Removing all columns that are factors: director, genre, name, rating, star, writer
# df_train <- df_train[,!colnames(df_train) %in% 
#                                            c('director', 'genre', 'name', 'rating', 'star', 'writer','X.1', 'X', 'directorGender','starGender', 'starPopularity')]
# df_test <- df_test[,!colnames(df_test) %in% 
#                                          c('director', 'genre', 'name', 'rating', 'star', 'writer','X.1', 'X', 'directorGender','starGender', 'starPopularity')]
# 

df_train_label <- df_train[,colnames(df_train) %in% ('percProf')]
df_test_label <- df_test[,colnames(df_test) %in% ('percProf')]


#Removing all columns that are factors
factorColumns <- df_train %>% Filter(f = is.factor) %>% names
df_train <- df_train[,!colnames(df_train) %in% factorColumns]
df_test <- df_test[,!colnames(df_test) %in% factorColumns]

#Removing gross and profit
df_train <- df_train[,!colnames(df_train) %in% c('gross', 'profit')]
df_test <- df_test[,!colnames(df_test) %in% c('gross', 'profit')]

#Changing everything to numeric from int 
df_train <- df_train %>% mutate_if(is.integer, as.numeric)
df_test <- df_test %>% mutate_if(is.integer, as.numeric)

## =================================================
## STEP 3: RUN THE MODEL
## =================================================
# Setting k as the sqrt of the number of rows of the dataset 
(k <- round(sqrt(868)))
kNN <- class::knn(train = df_train, test = df_test, cl = df_train_label, k = k, prob = TRUE)
(table <- table(kNN, df_test_label))

(miscalculation_rate <- 1 - sum(diag(table))/sum(table))
(accuracy_rate <- sum(diag(table))/sum(table))

## =================================================
## STEP 4: MAKE THE VIZ
## =================================================

percProf <- c('Average', 'High', 'Negative')
model <- replicate(3, "vis")
accuracy <- c(diag(table)/74*100)
model_accuracy <- data.frame(percProf, model, accuracy)
(model_plot <- ggplot(model_accuracy, aes(x = percProf, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c("Negative", 'Average', 'High')))
(model_plot <- model_plot + ylab("Accuracy Percentage") + xlab("Percent Profit") + ggtitle("Accuracy Percentage for KNN Model for Percent Profit") + ylim(0, 100))

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## ################################################################################################################
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## *************************************************
## MODELING: SVM TO PREDICT PERCENT PROFIT
## *************************************************
## ================================================
## STEP 1: LOAD THE DATA & LIBRARIES
## ================================================
library(e1071)
library(mlr)
library(caret)
library(naivebayes)
library(datasets)
library(ggplot2)
library(MASS)
library(dplyr)

#Setting working directory 
#setwd("C:\\Users\\ho511\\Desktop\\IST 707\\Team Project\\CSVs")
#setwd("/Users/kosburn 1/syracuse/IST707/project/ALI")

#Reading in the Movies Spreadsheet 
# SVM_train_percProf <- read.csv("everything_train_perc_profit.csv", header = TRUE)
# SVM_test_percProf <- read.csv("everything_test_perc_profit.csv", header= TRUE)

# SVM_train_percProf <- read.csv("train_perc_profit_powerful_negpos.csv", header = TRUE)
# SVM_test_percProf <- read.csv("test_perc_profit_powerful_negpos.csv", header= TRUE)

## THIS IS WITH THE ALI-NORMALIZED DATA
SVM_train_percProf <- read.csv("norm_everything_train_percProf.csv", header = TRUE)
SVM_test_percProf <- read.csv("norm_everything_test_percProf.csv", header= TRUE)

## =================================================
## STEP 2: PREP DATA FOR SPECIFIC MODEL
## =================================================
#***************************************************
# SVM requires Numeric Data Only
# Remove the label from the training data 
# Save Label in a train_label vector 
#***************************************************
#Removing all columns that are factors: director, genre, name, rating, star, writer
colstoremove <- c('director', 'star', 'name','X.1', 'X', 'starScore', 'directorGender', 'genre', 'rating', 'starGender')
# colstoremove <- c('directorAge','released','runtime', 'starAge','year', 'starPopularity','director', 'star', 'name','X.1', 'X', 'starScore', 'directorGender', 'genre', 'rating', 'starGender')
SVM_train_percProf <- SVM_train_percProf[,!colnames(SVM_train_percProf) %in% 
                                           colstoremove]
SVM_test_percProf <- SVM_test_percProf[,!colnames(SVM_test_percProf) %in% 
                                         colstoremove]

#Removing gross and profit
SVM_train_percProf <- SVM_train_percProf[,!colnames(SVM_train_percProf) %in% c('gross', 'profit')]
SVM_test_percProf <- SVM_test_percProf[,!colnames(SVM_test_percProf) %in% c('gross', 'profit')]

#Saving DF with label for later
SVM_with_label <- SVM_train_percProf

#Removing the classification label from BOTH the Train and Test dfs and storing it 
SVM_train_percProf_label <- SVM_train_percProf[,colnames(SVM_train_percProf) %in% ('percProf')]
## YOU KEEP IN SVM
##SVM_train_percProf <- SVM_train_percProf[,!colnames(SVM_train_percProf) %in% ('percProf')]

SVM_test_percProf_label <- SVM_test_percProf[,colnames(SVM_test_percProf) %in% ('percProf')]
SVM_test_percProf <- SVM_test_percProf[,!colnames(SVM_test_percProf) %in% ('percProf')]

#Changing everything to numeric from int 
SVM_train_percProf <- SVM_train_percProf %>% mutate_if(is.integer, as.numeric)
SVM_test_percProf <- SVM_test_percProf %>% mutate_if(is.integer, as.numeric)

## =================================================
## STEP 3: RUN THE MODEL(s)
## =================================================

## **************************************************
## RADIAL KERNEL -- 46%
## **************************************************

SVM_train_radial <- svm(percProf ~., data = SVM_train_percProf, kernel = "radial", cost = .1, scale = FALSE)
SVM_train_radial_pred <- predict(SVM_train_radial, SVM_test_percProf, type = "class")

(SVM_radial_table <- table(SVM_test_percProf_label, SVM_train_radial_pred))
(miscalculation_rate <- 1 - sum(diag(SVM_radial_table))/sum(SVM_radial_table))
(accuracy_rate <- sum(diag(SVM_radial_table))/sum(SVM_radial_table))

## **************************************************
## POLYNOMIAL KERNEL -- 40%
## **************************************************

SVM_train_polynomial <- svm(percProf ~., data = SVM_train_percProf, kernel = "polynomial", cost = .1, scale = FALSE)
SVM_train_polynomial_pred <- predict(SVM_train_polynomial, SVM_test_percProf, type = "class")

(SVM_polynomial_table <- table(SVM_test_percProf_label, SVM_train_polynomial_pred))
(miscalculation_rate <- 1 - sum(diag(SVM_polynomial_table))/sum(SVM_polynomial_table))
(accuracy_rate <- sum(diag(SVM_polynomial_table))/sum(SVM_polynomial_table))

## **************************************************
## LINEAR KERNEL -- 49% 
## **************************************************

SVM_train_linear <- svm(percProf ~., data = SVM_train_percProf, kernel = "linear", cost = .1, scale = FALSE)
SVM_train_linear_pred <- predict(SVM_train_linear, SVM_test_percProf, type = "class")

(SVM_linear_table <- table(SVM_test_percProf_label, SVM_train_linear_pred))
(miscalculation_rate <- 1 - sum(diag(SVM_linear_table))/sum(SVM_linear_table))
(accuracy_rate <- sum(diag(SVM_linear_table))/sum(SVM_linear_table))

## =================================================
## STEP 4: VISUALIZATIONS(s)
## =================================================


## **************************************************
## RADIAL KERNEL -- 46%
## **************************************************
#The model's overall accuracy is 46%,
# Accuracy average = 18, high 58, low 63
percProf <- c('Average', 'High', 'Negative')
model <- replicate(3, "svm_linear")
accuracy <- c(18, 58, 63)
svm_radial_accuracy <- data.frame(percProf, model, accuracy)
(svm_radial_plot <- ggplot(svm_radial_accuracy, aes(x = percProf, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c("Negative", 'Average', 'High')))
(svm_radial_plot <- svm_radial_plot + ylab("Accuracy Percentage") + xlab("Percent Profit") + ggtitle("Accuracy Percentage for SVM radial Model for Percent Profit") + ylim(0, 100))


## **************************************************
## POLYNOMIAL KERNEL -- 40%
## **************************************************
#The model's overall accuracy is 40%,
# Accuracy average = 9, high 83, low 27
percProf <- c('Average', 'High', 'Negative')
model <- replicate(3, "svm_polynomial")
accuracy <- c(9, 83, 27)
svm_polynomial_accuracy <- data.frame(percProf, model, accuracy)
(svm_polynomial_plot <- ggplot(svm_polynomial_accuracy, aes(x = percProf, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c("Negative", 'Average', 'High')))
(svm_polynomial_plot <- svm_polynomial_plot + ylab("Accuracy Percentage") + xlab("Percent Profit") + ggtitle("Accuracy Percentage for SVM polynomial Model for Percent Profit") + ylim(0, 100))


## **************************************************
## LINEAR KERNEL -- 49% 
## **************************************************

#The model's overall accuracy is 49%,
# Accuracy average = 20, high 66, low 60
percProf <- c('Average', 'High', 'Negative')
model <- replicate(3, "svm_linear")
accuracy <- c(20, 66, 60)
svm_linear_accuracy <- data.frame(percProf, model, accuracy)
(svm_linear_plot <- ggplot(svm_linear_accuracy, aes(x = percProf, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c("Negative", 'Average', 'High')))
(svm_linear_plot <- svm_linear_plot + ylab("Accuracy Percentage") + xlab("Percent Profit") + ggtitle("Accuracy Percentage for SVM Linear Model for Percent Profit") + ylim(0, 100))

## **************************************************
## ALL TOGETHER
## **************************************************

#Comparison of all models
all_svm_percProf_everything_models <- rbind(svm_radial_accuracy, svm_polynomial_accuracy, svm_linear_accuracy)
(all_svm_percProf_everything_models_plot <- ggplot(all_svm_percProf_everything_models, aes(fill = model, y = accuracy, x = percProf)) + geom_bar(stat = "identity", position = "dodge") + scale_x_discrete(limit = c('Negative', 'Average', 'High')))
(all_svm_percProf_everything_models_plot <- all_svm_percProf_everything_models_plot + ylab("Accuracy Percentage") + xlab("percProf") + ggtitle("Comparison of Accuracy Percentage for All everything MoviesUSA Percent Profit SVM") + ylim(0, 100))

#Comparison of overall Accuracy
overall_accuracy <- replicate(3, "Overall Accuracy")
model <- c('svm_radial', 'svm_polynomial', 'svm_linear')
accuracy <- c(46, 40, 49)
overall_accuracy_everything_svm <- data.frame(overall_accuracy, model, accuracy)
(overall_accuracy_percProf_everything_models_plot <- ggplot(overall_accuracy_everything_svm, aes(fill = model, y = accuracy, x = overall_accuracy)) + geom_bar(stat = "identity", position = "dodge") + scale_x_discrete(limit = c('Negative', 'Average', 'High')))
(all_nb_percProf_everything_models_plot <- overall_accuracy_percProf_everything_models_plot + ylab("Accuracy Percentage") + xlab("Percent Profit") + ggtitle("Comparison of Overall Accuracy Percentage for All everything MoviesUSA Percent Profit SVM") + ylim(0, 100))

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## ################################################################################################################
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## *************************************************
## MODELING: RANDOM FOREST TO PREDICT PERCENT PROFIT
## *************************************************
## SUPERVISED | LABELS IN THE TRAIN
## ================================================
## STEP 1: LOAD THE DATA & LIBRARIES
## ================================================
modelname <- ("RF")
library(randomForest)
#setwd("/Users/kosburn 1/syracuse/IST707/project/FINAL")

RF_train_percProf <- read.csv("everything_discretized_train_perc_profit.csv", header = TRUE)
RF_test_percProf <- read.csv("everything_discretized_test_perc_profit.csv", header= TRUE)

#Removing all columns that are factors: director, genre, name, rating, star, writer
colstoremove <- c('director', 'star', 'title','X.1', 'X' )
# colstoremove <- c('directorAge','released','runtime', 'starAge','year', 'starPopularity','director', 'star', 'name','X.1', 'X', 'starScore', 'directorGender', 'genre', 'rating', 'starGender')
RF_train_percProf <- RF_train_percProf[,!colnames(RF_train_percProf) %in% 
                                         colstoremove]
RF_test_percProf <- RF_test_percProf[,!colnames(RF_test_percProf) %in% 
                                       colstoremove]

## ================================================
## STEP 2: PREP DATA FOR MODEL
## ================================================
RF_train_percProf_dataonly <- RF_train_percProf[,!colnames(RF_train_percProf) %in% ('percProfit')]
RF_test_percProf_dataonly <- RF_test_percProf[,!colnames(RF_test_percProf) %in% ('percProfit')]
# LABELS ONLY
RF_train_percProf_label <- RF_train_percProf[,colnames(RF_train_percProf) %in% ('percProfit')]
RF_test_percProf_label <- RF_test_percProf[,colnames(RF_test_percProf) %in% ('percProfit')]

#Removing gross and profit
RF_train_percProf <- RF_train_percProf[,!colnames(RF_train_percProf) %in% c('gross', 'profit')]
RF_test_percProf <- RF_test_percProf[,!colnames(RF_test_percProf) %in% c('gross', 'profit')]

## ================================================
## STEP 3: RUN MODEL
## ================================================
## ************************************************
## ATTEMPT 1 -- INPUT: ALL THE THINGS -- 55%
## ************************************************

set.seed(42)
PercProf_fit_RF <- randomForest(percProfit ~ . , data = RF_train_percProf)
print(PercProf_fit_RF)

pred_RF<-predict(PercProf_fit_RF, RF_test_percProf_dataonly) 
(pred_table <- table(pred_RF, RF_test_percProf_label))
(miscalculation_rate <- 1 - sum(diag(pred_table))/sum(pred_table))
(accuracy_rate <- sum(diag(pred_table))/sum(pred_table))

## ************************************************
## ATTEMPT 2 -- INPUT: cvCoreModel -- 53%
## ************************************************
library(CORElearn)
#more appropriate for large data sets one can specify just the target variable
#Predicts with 20 trees and a 10-fold cross validation
modelRF <- cvCoreModel("percProfit", RF_train_percProf, model="rf", rfNoTrees = 20, fold = 10, stratified = TRUE, returnModel = TRUE, maxThreads = 1)
modelRF$avgs
print(modelRF)
pred <- predict(modelRF, RF_test_percProf, type = "class")
(table_model_RF <- table(RF_test_percProf_label, pred))
(miscalculation_rate <- 1 - sum(diag(table_model_RF))/sum(table_model_RF))
(accuracy_rate <- sum(diag(table_model_RF))/sum(table_model_RF))
plot(modelRF, rf_discretized_train_score, rfGraphType=c("attrEval"), clustering = NULL)

## ************************************************
## ATTEMPT 3 -- INPUT: What cvCore suggested above
## ************************************************
## Director Popularity, Votes, Budget


## ================================================
## STEP 4: VISUALIZE
## ================================================
ggfilenameM1 <- paste(modelname, "_M1.png", sep="")
ggfilenameM2 <- paste(modelname, "_M2.png", sep="")

## ************************************************
## ATTEMPT 1 -- INPUT: ALL THE THINGS
## ************************************************
#The model's overall accuracy is 55%,
# Accuracy average = 46, high 65, low 46
percProf <- c('Average', 'High', 'Negative')
model <- replicate(3, "RFattempt1")
accuracy <- c(46, 65, 46)
rf1_accuracy <- data.frame(percProf, model, accuracy)
(rf1_plot <- ggplot(rf1_accuracy, aes(x = percProf, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c("Negative", 'Average', 'High')))
(rf1_plot <- rf1_plot + ylab("Accuracy Percentage") + xlab("Percent Profit") + ggtitle("Accuracy Percentage for Random Forest Model for Percent Profit") + ylim(0, 100))+ggsave(ggfilenameM1, plot = last_plot(), device = NULL)

## ************************************************
## ATTEMPT 2 -- CORElearn
## ************************************************
#The model's overall accuracy is 53%,
# Accuracy average = 39, high 68, low 53
percProf <- c('Average', 'High', 'Negative')
model <- replicate(3, "RFattempt2")
accuracy <- c(39, 68, 53)
rf2_accuracy <- data.frame(percProf, model, accuracy)
(rf2_plot <- ggplot(rf2_accuracy, aes(x = percProf, y = accuracy, fill = rainbow(3))) + geom_bar(stat = "identity") + theme(legend.position ="none") + scale_x_discrete(limit = c("Negative", 'Average', 'High')))
(rf2_plot <- rf2_plot + ylab("Accuracy Percentage") + xlab("Percent Profit") + ggtitle("Accuracy Percentage for Random Forest Model for Percent Profit") + ylim(0, 100))+ggsave(ggfilenameM2, plot = last_plot(), device = NULL)


## ************************************************
## ATTEMPT ALL
## ************************************************
ggfilenameA1 <- paste(modelname, "_modelComparison.png", sep="")
ggfilenameA2 <- paste(modelname, "_modelAccuracyComparison.png", sep="")
#Comparison of all models
all_RF_percProf_everything_models <- rbind(rf1_accuracy, rf2_accuracy)
(all_RF_percProf_everything_models_plot <- ggplot(all_RF_percProf_everything_models, aes(fill = model, y = accuracy, x = percProf)) + geom_bar(stat = "identity", position = "dodge") + scale_x_discrete(limit = c('Negative', 'Average', 'High')))
(all_RF_percProf_everything_models_plot <- all_RF_percProf_everything_models_plot + ylab("Accuracy Percentage") + xlab("percProf") + ggtitle("Comparison of Accuracy Percentage for All everything MoviesUSA Percent Profit RF") + ylim(0, 100))+ggsave(ggfilenameA1, plot = last_plot(), device = NULL)

#Comparison of overall Accuracy
overall_accuracy <- replicate(2, "Overall Accuracy")
model <- c('rf1_accuracy', 'rf2_accuracy')
accuracy <- c(55, 53)
overall_accuracy_everything_rf <- data.frame(overall_accuracy, model, accuracy)
(overall_accuracy_percProf_everything_models_plot <- ggplot(overall_accuracy_everything_rf, aes(fill = model, y = accuracy, x = overall_accuracy)) + geom_bar(stat = "identity", position = "dodge"))
(all_nb_percProf_everything_models_plot <- overall_accuracy_percProf_everything_models_plot + ylab("Accuracy Percentage") + xlab("Percent Profit") + ggtitle("Comparison of Overall Accuracy Percentage for All everything MoviesUSA Percent Profit RF") + ylim(0, 100))+ggsave(ggfilenameA2, plot = last_plot(), device = NULL)

