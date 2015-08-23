#This R script does the following. 
#
#1- Merges the training and the test sets to create one data set.
#2-Extracts only the measurements on the mean and standard deviation for each measurement. 
#3-Uses descriptive activity names to name the activities in the data set
#4-Appropriately labels the data set with descriptive variable names. 
#
#5- From the data set in step 4, creates a second, independent tidy data set with the average 
#   of each variable for each activity and each subject.


library(data.table)
library(dplyr)

#Set the working dircetory
setwd("~/Coursera/Getting and Cleaning Data/UCI HAR Dataset")
#Read the matedat of files

feature_Names <- read.table("features.txt")
activity_Labels <- read.table("activity_labels.txt", header = FALSE)

# Read Training dataset
Train_subject <- read.table("subject_train.txt", header = FALSE)
Train_activity <- read.table("y_train.txt", header = FALSE)
Train_feature <- read.table("X_train.txt", header = FALSE)

# Read test dataset
Test_subject <- read.table("subject_test.txt", header = FALSE)
Test_activity <- read.table("y_test.txt", header = FALSE)
Test_feature <- read.table("X_test.txt", header = FALSE)

# Fuse together the training and test datasets

subject <- rbind(Train_subject, Test_subject)
activity <- rbind(Train_activity, Test_activity)
features <- rbind(Train_feature, Test_feature)

#Name the colums appropriately
colnames(features) <- t(feature_Names[2])
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"

# Fuse together the tree types of datasets

Global_dataset <- cbind(features,activity,subject)

# Now Get only the data on mean and std. dev.

# First bring all reference work to the same case

feature_Names[,2] = gsub('-mean', 'Mean', feature_Names[,2])
feature_Names[,2] = gsub('-std', 'Std', feature_Names[,2])

#Second, list only the apropriate colonms

Good_col <- grep(".*Mean.*|.*Std.*", feature_Names[,2])

# Now add the last two columns (subject and activity)

Tidy_Data <- Global_dataset[,Good_col]

#Average of each variable

Mean_Data <- apply(Tidy_Data,2, mean)
