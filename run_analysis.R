## run_analysis.R

## script presumes the samsung data is in your working directory with same dir/file structure in zip archive
## UCI HAR DATASET
##   -test
##   -train
##   activity_labels.txt
##   features.txt
## etc.....

## needed packages...
library(dplyr)
library(tidyr)


featureVector2 <- vector()

features <- read.table("UCI HAR Dataset/features.txt")
featureVector2 <- features[,2]

## Aggregate training data
Xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
names(Xtrain) <- featureVector2
subjects_train <- scan("UCI HAR Dataset/train/subject_train.txt")
activity <- read.table("UCI HAR Dataset/activity_labels.txt")
ytrain <- scan("UCI HAR Dataset/train/y_train.txt")
Xtrainstd <- Xtrain[,grep("std", colnames(Xtrain))]
Xtrainmean <- Xtrain[,grep("mean", colnames(Xtrain))]
Xtrain <- cbind(Xtrainstd,Xtrainmean)
recode <- c(WALKING=1, WALKING_UPSTAIRS=2, WALKING_DOWNSTAIRS=3, SITTING=4, STANDING=5, LAYING=6)

ytrain <- factor(ytrain,levels = recode, labels = names(recode))
ytrain <- as.vector(ytrain)
Xtrain <- cbind(subjects_train,ytrain,Xtrain)

## Aggregate test data
Xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
names(Xtest) <- featureVector2
subjects_test <- scan("UCI HAR Dataset/test/subject_test.txt")
activity <- read.table("UCI HAR Dataset/activity_labels.txt")
ytest <- scan("UCI HAR Dataset/test/y_test.txt")
Xteststd <- Xtest[,grep("std", colnames(Xtest))] ## select std() columns
Xtestmean <- Xtest[,grep("mean", colnames(Xtest))] ## select mean columns
Xtest <- cbind(Xteststd,Xtestmean) ## join columns
recode <- c(WALKING=1, WALKING_UPSTAIRS=2, WALKING_DOWNSTAIRS=3, SITTING=4, STANDING=5, LAYING=6)

ytest <- factor(ytest,levels = recode, labels = names(recode))
ytest <- as.vector(ytest)
Xtest <- cbind(subjects_test,ytest,Xtest)

colnames(Xtrain)[1:2] <- c("subject","activity")
colnames(Xtest)[1:2] <- c("subject","activity")

## row bind training and test data
Alldata <- rbind(Xtrain,Xtest)

## temp data to perform avg on all columns for each subject performing each activity
tempGroup1 <- Alldata %>% group_by(subject) %>% arrange(activity)

activities1 <- factor(recode,levels=recode, labels = names(recode)) ## to be able to spin through factors of activities

tidyAllData <- data.frame()
summaryRow <- data.frame()
for (act in activities1){
    for (i in c(1:30)){
        summaryRow <- tempGroup1 %>%
            filter(subject == i & activity == act) %>%
            summarise_each(funs(mean),-subject)
        summaryRow[1,2] <- act
        tidyAllData <- rbind(tidyAllData, summaryRow)
    }
}
## add "AVG to all column names except the first two (subject, activity)
tadCols <- colnames(tidyAllData) 
for(i in c(3:length(tadCols))) tadCols[i] <- paste("AVG",tadCols[i], sep = "")

names(tidyAllData) <- tadCols

## OUTPUT of the script = the tidy data !!
View(tidyAllData)


## commands below allow writing out, reading in of the final data set produced above.

# write.table(tidyAllData,file="tidyAlldata.txt", row.names = FALSE, quote = FALSE)
# importedTidyData <- read.table("tidyAlldata.txt", header = TRUE)
# View(importedTidyData)
