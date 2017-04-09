## run_analysis.R for Course Project

### This script reads data from the Human Activity from smart phone data set
### which was specified for the project. The data is originally separated into
### test and training data sets with feature and activity information also
### provided. After loading the test, train, feature, and activity data, the test
### and train data is merged into one data set using only data involving mean and 
### standard deviation. Finally, the merged data is turned into a tidy data table
### with means calculated for by each subject and activity and is output to a 
### text file.

#############################################################

## Set working directory to test data set location
# setwd("Type your working directory here")
# setwd("C:/Users/AG ITX 1/Desktop/GetAndCleanDataProject") # my directory
list.files() #To view files in working directory

## Read and inspect data from subject test file
subtest <- read.table(file = "subject_test.txt")
head(subtest)
str(subtest)
unique(subtest)

## Read and inspect data from X test file
xtest <- read.table(file = "X_test.txt")
head(xtest)[1:10]

## Read and inspect data from Y test file
ytest <- read.table(file = "y_test.txt")
head(ytest)
str(ytest)
unique(ytest)

## Set working directory to training data set location
# setwd("Type your working directory here")
list.files() #To view files in working directory

## Read and inspect data from subject train file
subtrain <- read.table(file = "subject_train.txt")
head(subtrain)
str(subtrain)
unique(subtrain)

## Read and inspect data from X train file
xtrain <- read.table(file = "X_train.txt")
head(xtrain)[1:10]

## Read and inspect data from Y train file
ytrain <- read.table(file = "y_train.txt")
head(ytrain)
str(ytrain)
unique(ytrain)

## Set working directory to data detail information files
# setwd("Type your working directory here")
list.files()

## Read and inspect data from features file
feat <- read.table(file = "features.txt")
head(feat)
feat[] <- lapply(feat, as.character) # Convert character to us as column names 
                                     # in later data set

## Clean out non letter or numeric characters from 2nd columns of features
feat$V2 <- gsub("\\(", "", feat$V2)
feat$V2 <- gsub("\\)", "", feat$V2)
feat$V2 <- gsub(",", "", feat$V2)
feat$V2 <- gsub("-", "", feat$V2)

## Assign meaningful variable names to test and train data
names(subtest) <- "subject"
names(subtrain) <- "subject"

names(xtest)[grep("mean", feat$V2)] <- feat$V2[grep("mean", feat$V2)]
names(xtest)[grep("std", feat$V2)] <- feat$V2[grep("std", feat$V2)]

names(xtrain)[grep("mean", feat$V2)] <- feat$V2[grep("mean", feat$V2)]
names(xtrain)[grep("std", feat$V2)] <- feat$V2[grep("std", feat$V2)]

## Read and inspect data from activity labels file
activ <- read.table(file = "activity_labels.txt")
head(activ)
activ$V2 <- tolower(activ$V2) #change letters to lower case in 2nd column

## Assign meaningful variable names to test and train data
names(ytest) <- "activity"
names(ytrain) <- "activity"

## Column bind test data from the test data folder adding in an
## "observation" variable to specify that the data came from the test data set
testdata <- cbind(subtest, ytest, observation = rep("test", 2947), xtest)
head(testdata)[1:7]
tail(testdata)[1:7]

## Column bind train data from the train data folder adding in an
## "observation" variable to specify that the data came from the train data set
traindata <- cbind(subtrain, ytrain, observation = rep("train", 7352), xtrain)
head(traindata)[1:7]
tail(traindata)[1:7]

## Merge the test and train data into a single data frame with row bind
testtrain <- rbind(testdata, traindata)
head(testtrain)[1:7]
tail(testtrain)[1:7]

## Apply meaningful activity names to the activity variable
for(i in 1:length(activ$V2)){
      testtrain$activity[which(testtrain$activity == as.numeric(i))] <- activ$V2[i]
}

## Load libraries
library(dplyr)
library(tidyr)

## Converted merged test and train data frame into a table data frame for use
## with the dplyr and tidyr packages
combdata <- tbl_df(testtrain)  # Could have left the object name as testtrain
                               # but wanted the reference back to the data frame available

## Create a tidy data frame of means of subject and activity using dplyr, tidyr,
## and chaining
tidydatameans <- combdata %>%
      select(matches('subjec|activity|observation|mean|std')) %>%
      #group_by(activity)
      group_by_(.dots = c("subject", "activity")) %>%
      summarise_if(.predicate = function(x) is.numeric(x), .funs = funs("mean"))

## Preview tidydatameans
tidydatameans
tail(tidydatameans)  

## Write the tidy data to a .txt file.
getwd()
write.table(tidydatameans, file = "tidy_data_means.txt", row.names = FALSE)