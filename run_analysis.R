setwd("C:/Users/Jack/Documents/R/cleaning assignment/UCI HAR Dataset/")

#pulls the features for variable names later
features <- read.table("features.txt")

setwd("C:/Users/Jack/Documents/R/cleaning assignment/UCI HAR Dataset/test/")

#takes out the data and corresponding subject & activity for TEST
test_subject <- read.table("subject_test.txt")
test_x <- read.table("X_test.txt", col.names = features[,2])
test_y <- read.table("y_test.txt")

#merges them all into one DF
test <- cbind(test_subject,test_y)
test <- `colnames<-`(test, c("subject","activity"))
test <- cbind(test,test_x)

setwd("C:/Users/Jack/Documents/R/cleaning assignment/UCI HAR Dataset/train/")

#takes out the data and correspoonding subject & activity for TRAIN
train_subject <- read.table("subject_train.txt")
train_x <- read.table("X_train.txt", col.names = features[,2])
train_y <- read.table("y_train.txt")

#merges them all into one DF
train <- cbind(train_subject,train_y)
train <- `colnames<-`(train, c("subject","activity"))
train <- cbind(train,train_x)

#creates one DF for test and train
merged <- rbind(test,train)

#finds mean & std measurements
library(dplyr)
mean <- select(merged,contains("mean"))
std <- select(merged,contains("std"))

#slims it down to only activity, subject, mean & std measurements
slim <- merged[,1:2]
slim <- cbind(slim,mean)
slim <- cbind(slim,std)

#labels activities 
setwd("C:/Users/Jack/Documents/R/cleaning assignment/UCI HAR Dataset")
activities <- read.table("activity_labels.txt",col.names = c("match","replace"))
slim$activity <- sapply(slim$activity, function(x) x <- activities[x,2])

#groups by subject and activity, averages each obvservation
grouped_data <- slim %>% group_by(activity,subject) %>% summarize_all(funs(mean))

#writes out grouped_data to an external file
write.table(grouped_data,file = "tidy_dancer.txt", sep = " ")
