setwd("~/R/Coursera/Getting and Cleaning Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")
library(reshape2)
library(lpyr)

## Read data files
# read the train and test data sets
train <- read.table("./train/x_train.txt", header = FALSE)
test <- read.table("./test/x_test.txt", header = FALSE)

# read the subject data sets
train_subj <- read.table("./train/subject_train.txt", header = FALSE)
test_subj <- read.table("./test/subject_test.txt", header = FALSE)

# read the activity data sets
train_act <- read.table("./train/y_train.txt", header = FALSE)
test_act <- read.table("./test/y_test.txt", header = FALSE)

## Combine data files
# combine the train set and test set data
combo <- rbind(train, test)

combo_subj <- rbind(train_subj,test_subj)
colnames(combo_subj) <- c("Subject")

combo_act <- rbind(train_act, test_act)
colnames(combo_act) <- c("Activity")

# read the feature.txt file
features <- read.table("features.txt", header = FALSE)

# original feature names contain illegal characters that could not be
# used as column names, like -, space, ()
# use make.names to make them validcombo_mean <- select(combo, contains("mean"))
valid_features <- make.names(features[,2], unique=TRUE, allow_=TRUE)

# assign features as column names
colnames(combo) <- valid_features

# extra columns that contain names of "mean" and "std"
combo_mean <- select(combo, contains("mean"))
combo_std <- select(combo, contains("std"))

# merge the 4 datasets
combo_ms <- cbind(combo_subj, combo_act, combo_mean, combo_std)

# Melt the combo_ms dataset to prepare for summarization
# Tutorial for doing that: http://www.r-bloggers.com/using-r-quickly-calculating-summary-statistics-from-a-data-frame/
melted <- melt(combo_ms, id.vars = c("Subject", "Activity"))

combo_ms_avg <- ddply(melted, c("Subject", "Activity", "variable"), summarise, average = mean(value))

# write the text file
write.table(combo_ms_avg, file = "run_analysis_out.txt", row.name = FALSE)
