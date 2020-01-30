library(ggplot2)
library(dplyr)

##-----STEP 1--make sure data is where I can access it
##-----STEP 2--read & print the data

##import csv
MathCourseTest <- read.csv("/Users/kosburn/Desktop/data-storyteller.csv", na.string = c(""))

##print the data
(head(MathCourseTest, n=5))

##-----STEP 3--Look at the structure
(str(MathCourseTest))
##change section to factor
##before
(str(MathCourseTest$Section))
MathCourseTest$Section <- factor(MathCourseTest$Section)
##after
(str(MathCourseTest$Section))
##yay! Factors!
##let's see what the section distribution is...
table(MathCourseTest$Section)
##hmm not that interesting.
##let's check to see how many sections per school
table(MathCourseTest$School)

##-----STEP 4--Dealing with Data Cleaning
##Checking for missing values...
##wow a whole column with no values. Maybe a mistake?
##no way we can "fill in" this data... but it is probably pretty similar to "completed" 
##given how far along in the semester these classes are
##SOLUTION: Remove "Very Ahead"
##using a test first
test <- MathCourseTest
test <- test[,-3]
##great! it works. Now doing it FO REAL, YO
##hopefully all my fans out there are enjoying this riveting comentary 
##ok actually deleting now
MathCourseTest <- MathCourseTest[,-3]
(freq=table(MathCourseTest$School))
##just confirming I didn't muck things up too bad
##I should definitely add a "total students per section" column
##testing
testAdd <- cbind(MathCourseTest$Middling..0 + 
                   MathCourseTest$Behind..1.5 + 
                   MathCourseTest$More.Behind..6.10 + 
                   MathCourseTest$Very.Behind..11 + 
                   MathCourseTest$Completed)
##IT'S WORKING!! Cats are also excited!!
##Testing one more time bc I still don't trust myself
MathCourseTestTemp <- MathCourseTest
MathCourseTestTemp$TotalStudents <- testAdd
##OH HECKIN' YES!! And THAT, ladies and gentlement, is why you use R
##Readding it to OG Dataframe 
MathCourseTest <- testAdd
## LOL THAT RUINED EVERYTHING
## FORGOT TO ALSO ADD COLUMN AND INSTEAD JUST REPLACED MY MAIN DF LOL
## THANK GOODNESS I HAD A TEMP
## FIXING THINGS
MathCourseTest <- MathCourseTestTemp
## OK continuing. Because there is such a wide range of numbers of students per section
## The only meaningful way we'll get any good data or visualizations is if we
## Convert to percentages.
## More test dataframes incoming!! 
tv <- MathCourseTest$TotalStudents
testAddPercents <- cbind(MathCourseTest$Middling/tv, 
                         MathCourseTest$Behind..1.5/tv,
                         MathCourseTest$More.Behind..6.10/tv,
                         MathCourseTest$Very.Behind..11/tv,
                         MathCourseTest$Completed/tv
                         )
## Checking that all of these are correct by confirming each row adds to one
testAddPercentsTotal <- cbind(testAddPercents[,1] + 
                                testAddPercents[,2] +
                                testAddPercents[,3] +
                                testAddPercents[,4] + testAddPercents [,5]
)
##ALSO WORKING!! Litterally did a fist bump. OK, two fist bumps.
##OK I need to add headings to our new Percent DF
testAddPercentsTemp <- data.frame(testAddPercents)
testAddPercentsTemp$School <- MathCourseTest$School
## But I want to rearrange things so I might just start a fresh data frame
testAddPercentsTemp <- data.frame(testAddPercents)
testAddPercentsTemp$School <- MathCourseTest$School
testAddPercentsTemp$Section <- MathCourseTest$Section
testAddPercentsTemp <- testAddPercentsTemp[, colnames(testAddPercentsTemp[
  c("School", "Section", "X1", "X2", "X3", "X4", "X5")
])]
##now to rename
nameHolder <- colnames(MathCourseTest[1:7])
colnames(testAddPercentsTemp) <- nameHolder
##Not exactly sure why I made a variable there
##Thank goodness for house music
mcPercents <- testAddPercentsTemp
##And now mcPercents is our working data frame and testAddPercentsTemp is a backup!!
hist(mcPercents$Completed)
## HOW ARE THEY NO LONGER NUMERIC!?!
## Convert to numeric 
## Testing again first
mcPercentsTemp <- mcPercents
mcPercentsTemp$Completed <- as.numeric(mcPercentsTemp$Completed)
hist(mcPercentsTemp$Completed)
## OK great that worked but still wtf is this histogram trying to tell me
## And see HERE is where I'd like that loop!!
##for(column in mcPercentsTemp[3:7]){
## mcPercentsTemp[[column]] <- as.numeric(mcPercentsTemp[[column]])
##}
## WHY DOES THAT GIVE ME AN ERROR?! 
mcPercentsTemp$Middling..0 <- as.numeric(mcPercentsTemp$Middling..0)
mcPercentsTemp$Behind..1.5 <- as.numeric(mcPercentsTemp$Behind..1.5)
mcPercentsTemp$More.Behind..6.10 <- as.numeric(mcPercentsTemp$More.Behind..6.10)
mcPercentsTemp$Very.Behind..11 <- as.numeric(mcPercentsTemp$Very.Behind..11)
## OK Now all are numeric
## HISTOGRAM PARTY!!
hist(mcPercentsTemp$Middling..0)
## Still not a userful visualization -- What is it telling us?!
boxplot(mcPercentsTemp$Completed)
## This fixed our outlier issue. Still not clear what this is telling us
pie(table(mcPercentsTemp$Completed))
## Also not useful
pie(table(mcPercentsTemp$School))
## Slightly more useful
plot(mcPercentsTemp$School,mcPercentsTemp$Completed)
## Finally something semi-useful
plot(mcPercentsTemp$School,(mcPercentsTemp$Completed + mcPercentsTemp$Middling..0))
## OK This is much more useful
## I've combined Completed and Middling to get "Not Behind"
plot(mcPercentsTemp$School,mcPercentsTemp$Very.Behind..11)
plot(mcPercentsTemp$School,mcPercentsTemp$Very.Behind..11 + mcPercentsTemp$Behind..1.5 + mcPercentsTemp$More.Behind..6.10)
## trying to get more data about each school individually
schoolA <- filter(mcPercentsTemp, mcPercentsTemp$School == "A")
schoolB <- filter(mcPercentsTemp, mcPercentsTemp$School == "B")
## oh great, amother plot I can't really understand
pie(table(mcPercentsTemp$School))
## Thankfully this makes more sense but does it tell the whole story?
## I should actually try to get the sum of students
totalStudents <- aggregate(MathCourseTest$TotalStudents, by=list(MathCourseTest$School), FUN=sum)
pie(table(totalStudents$V1))
## This obviously doesn't give me the data that I want lol
## Need to get the total students and divide all by that num
totalStudents$percent <- cbind(totalStudents$V1/sum(totalStudents$V1))
pie(totalStudents$percent, labels = totalStudents$Group.1)
## OK This looks a little choppy and I think it would be best to 
## combine C, D and E into O for Other
## step one create yet another variable I'm going to forget
## turn that test variable into a dataframe 
totalStudentsTest <- data.frame(totalStudents)
## Just realized that I wouldn't be manipulating our original dataframe and only our mini table
aggregate(x = totalSt$Match, by = list(df$Year), FUN = sum)
schoolATotals <- rbind(
  "A",
  "1",
  sum(schoolA$Middling..0),
  sum(schoolA$Behind..1.5),
  sum(schoolA$More.Behind..6.10),
  sum(schoolA$Very.Behind..11),
  sum(schoolA$Completed)
)
##Add that new 'totals' row to the DF
schoolA[nrow(schoolA) + 1,] = schoolATotals
##LOL NOPE. I forgot this was our percents DB lol
##UNDO
schoolA <- schoolA[-c(14),]
## OK pretty surprised that worked 
## Going back to non percents 
## Actually going to take this time to clean our variables. 
## If you're wondering why I'm not just overwriting and fixing inline instead,
## It's because I want to be able to run this file at anytime and get when I'm 
## Currently getting 
mcThreeSchools <- MathCourseTestTemp
## HOLY COW THAT TOOK A LONG TIME
## Note to future self -- gsub is god
## Also watch out for factors?!
mcThreeSchools$School <- as.character(mcThreeSchools$School)
mcThreeSchools$School <- gsub("C", "O", mcThreeSchools$School)
mcThreeSchools$School <- gsub("D", "O", mcThreeSchools$School)
mcThreeSchools$School <- gsub("E", "O", mcThreeSchools$School)

## Put back as factor
mcThreeSchools$School <- as.factor(mcThreeSchools$School)
## And now converting all of that back into percents!
## Great practice!!
t3v <- mcThreeSchools$TotalStudents
mcThreeSchoolsPercents <- cbind(mcThreeSchools$Middling/tv, 
                         mcThreeSchools$Behind..1.5/tv,
                         mcThreeSchools$More.Behind..6.10/tv,
                         mcThreeSchools$Very.Behind..11/tv,
                         mcThreeSchools$Completed/tv
)
## and turning that into a dataframe
mcThreeSchoolsPercents <- data.frame(mcThreeSchoolsPercents)
mcThreeSchoolsPercents$School <-  mcThreeSchools$School
mcThreeSchoolsPercents$Section <-  mcThreeSchools$Section
## rearrange those columns
mcThreeSchoolsPercents <- mcThreeSchoolsPercents[, colnames(mcThreeSchoolsPercents[
  c("School", "Section", "X1", "X2", "X3", "X4", "X5")
  ])]
## rename that first  row
## without an additional unnecessary variable this time!! GROWTH!!
colnames(mcThreeSchoolsPercents) <- colnames(mcThreeSchools[1:7])
pie(table(mcThreeSchoolsPercents$School))
## Still not super useful. I can't remember why I did that
totalStudents3 <- aggregate(mcThreeSchools$TotalStudents, by=list(mcThreeSchools$School), FUN=sum)
totalStudents3 <- data.frame(totalStudents3)
totalStudents3$Middling..0 <- aggregate(mcThreeSchools$Middling..0, by=list(mcThreeSchools$School), FUN=sum)
totalStudents3$Behind..1.5 <- aggregate(mcThreeSchools$Behind..1.5, by=list(mcThreeSchools$School), FUN=sum)
totalStudents3$More.Behind..6.10 <- aggregate(mcThreeSchools$More.Behind..6.10, by=list(mcThreeSchools$School), FUN=sum)
totalStudents3$Very.Behind..11 <- aggregate(mcThreeSchools$Very.Behind..11, by=list(mcThreeSchools$School), FUN=sum)
totalStudents3$Completed <- aggregate(mcThreeSchools$Completed, by=list(mcThreeSchools$School), FUN=sum)
## OK wow I just did waaaaay too much and got not at all what I wanted
## UNDO!
totalStudents3 <- NULL
totalStudents3 <- aggregate(mcThreeSchools$TotalStudents, by=list(mcThreeSchools$School), FUN=sum)
totalStudents3$Middling..0 <- aggregate(mcThreeSchools$Middling..0, by=list(mcThreeSchools$School), FUN=sum)
totalStudents3$Behind..1.5 <- aggregate(mcThreeSchools$Behind..1.5, by=list(mcThreeSchools$School), FUN=sum)
totalStudents3$More.Behind..6.10 <- aggregate(mcThreeSchools$More.Behind..6.10, by=list(mcThreeSchools$School), FUN=sum)
totalStudents3$Very.Behind..11 <- aggregate(mcThreeSchools$Very.Behind..11, by=list(mcThreeSchools$School), FUN=sum)
totalStudents3$Completed <- aggregate(mcThreeSchools$Completed, by=list(mcThreeSchools$School), FUN=sum)
## OK Unclear why I did that as well... 
## I'm going to (1) Make a DF for each school 
## Sum all the rows
## Put those rows into a new DF
mcThreeSchoolsA <- filter(mcThreeSchools, mcThreeSchools$School == "A")
## This gives a weird error, have to call rlang::last_error()
mcThreeSchools$TotalStudents <- as.integer(mcThreeSchools$TotalStudents)
## now trying again
mcThreeSchoolsA <- filter(mcThreeSchools, mcThreeSchools$School == "A")
mcThreeSchoolsA <- cbind(
  "A",
  "1",
  sum(mcThreeSchoolsA$Middling..0),
  sum(mcThreeSchoolsA$Behind..1.5),
  sum(mcThreeSchoolsA$More.Behind..6.10),
  sum(mcThreeSchoolsA$Very.Behind..11),
  sum(mcThreeSchoolsA$Completed),
  sum(mcThreeSchoolsA$TotalStudents)
)
## And now we'll do that for school B and school Other
## Ideally, I'd use a loop here but I keep messing up my R loops and spending
## WAAY too long trying to debug
mcThreeSchoolsA <- filter(mcThreeSchools, mcThreeSchools$School == "A")
mcThreeSchoolsA <- cbind(
  "A",
  sum(mcThreeSchoolsA$Middling..0),
  sum(mcThreeSchoolsA$Behind..1.5),
  sum(mcThreeSchoolsA$More.Behind..6.10),
  sum(mcThreeSchoolsA$Very.Behind..11),
  sum(mcThreeSchoolsA$Completed),
  sum(mcThreeSchoolsA$TotalStudents)
)
mcThreeSchoolsB <- filter(mcThreeSchools, mcThreeSchools$School == "B")
mcThreeSchoolsB <- cbind(
  "B",
  sum(mcThreeSchoolsB$Middling..0),
  sum(mcThreeSchoolsB$Behind..1.5),
  sum(mcThreeSchoolsB$More.Behind..6.10),
  sum(mcThreeSchoolsB$Very.Behind..11),
  sum(mcThreeSchoolsB$Completed),
  sum(mcThreeSchoolsB$TotalStudents)
)
mcThreeSchoolsO <- filter(mcThreeSchools, mcThreeSchools$School == "O")
mcThreeSchoolsO <- cbind(
  "O",
  sum(mcThreeSchoolsO$Middling..0),
  sum(mcThreeSchoolsO$Behind..1.5),
  sum(mcThreeSchoolsO$More.Behind..6.10),
  sum(mcThreeSchoolsO$Very.Behind..11),
  sum(mcThreeSchoolsO$Completed),
  sum(mcThreeSchoolsO$TotalStudents)
)
all <- c(mcThreeSchoolsA, mcThreeSchoolsB, mcThreeSchoolsO)
## that is not what I want
all <- NULL
all <- rbind(mcThreeSchoolsA, mcThreeSchoolsB, mcThreeSchoolsO)
finalAllTable <- all
allPercents <- data.frame(all)
allPercents <- rbind(as.numeric(mcThreeSchoolsA)/allPercents$X7,
                     mcThreeSchoolsB/allPercents$X7,
                     mcThreeSchoolsO/allPercents$X7
                     )
## This is also not at all what I want ERRORS -- trying something else 
## regression analysis time!!
## Take total
## Make two new columns NOT BEHIND and BEHIND 
## MAKE third column NOT BEHIND - BEHIND
## Make Fourth Colmn a 0 or a 1 based on if third column is negative
## Run regression analysis
finalWithTotals <- mcThreeSchools
finalWithTotals$NotBehind <- cbind(finalWithTotals$Completed + finalWithTotals$Middling..0)
finalWithTotals$Behind <- cbind(finalWithTotals$Behind..1.5 + finalWithTotals$More.Behind..6.10 + finalWithTotals$Very.Behind..11)
finalWithTotals$Subtract <- cbind(finalWithTotals$NotBehind - finalWithTotals$Behind)
finalWithTotals$Bool <- ifelse(finalWithTotals$Subtract > 0, 1, 0)
finalWithTotals$NotBehind <- as.integer(finalWithTotals$NotBehind)
finalWithTotals$Behind <- as.integer(finalWithTotals$Behind)
finalWithTotals$Bool <- as.factor(finalWithTotals$Bool)
## I had grand plans of running a linear regression before realizing I had no idea
## and absolutely no more time to do this in R
## Thankfully I have the whole semester to learn this!? 
## Thank you for such a fun and challenging assignment
## I'm exhausted but I learned SO. MUCH. SO. FAST. 
## Thank you
