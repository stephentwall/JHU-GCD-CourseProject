# JHU-GCD-CourseProject
Johns Hopkins U Coursera Getting and Cleaning Data course project repository


The run_analysis.R script will manipulate the samsung data found at 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
per the following instructions:

" You should create one R script called run_analysis.R that does the following. 
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. "

the script presumes the samsung data is in your working directory with same dir/file structure in zip archive  
UCI HAR DATASET  
  -test  
  -train  
  activity_labels.txt  
  features.txt  
etc.....  

The script's final command is to View the tidy data...