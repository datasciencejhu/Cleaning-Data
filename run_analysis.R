library(data.table)

## Assuming the working directory to be. You can set your own setwd() here
setwd("C:/JHU/Assignments/3/Week4/")

## Reading Activity Labels
activitylabels <- read.table("./UCI-HAR-Dataset/activity_labels.txt")
activitylabels <- activitylabels[,2]

## Reading Features
features <- read.table("./UCI-HAR-Dataset/features.txt")
features <- features[,2]

## Extract Measurements
extract_features <- grepl("mean|std", features)

## Read test data
xtest <- read.table("./UCI-HAR-Dataset/test/X_test.txt")
ytest <- read.table("./UCI-HAR-Dataset/test/y_test.txt")
subjectest <- read.table("./UCI-HAR-Dataset/test/subject_test.txt")

names(xtest) = features

xtest <- xtest[,extract_features]

ytest[,2] = activitylabels[ytest[,1]]
names(ytest) = c("ID", "Label")
names(subjectest) = "Subject"

testdata <- cbind(as.data.table(subjectest), ytest, xtest)


# Read train data.
xtrain <- read.table("./UCI-HAR-Dataset/train/X_train.txt")
ytrain <- read.table("./UCI-HAR-Dataset/train/y_train.txt")

subjectrain <- read.table("./UCI-HAR-Dataset/train/subject_train.txt")

names(xtrain) = features

xtrain = xtrain[,extract_features]

ytrain[,2] = activitylabels[ytrain[,1]]
names(ytrain) = c("ID", "Label")
names(subjectrain) = "Subject"

traindata <- cbind(as.data.table(subjectrain), ytrain, xtrain)

mergeddata <- rbind(testdata,traindata)


idlabels <- c("Subject", "ID", "Label")
datalabels <- setdiff(colnames(mergeddata), idlabels)
meltdata <- melt(mergeddata, id = idlabels, measure.vars = datalabels)

# Apply mean function to dataset 
tidydata <- dcast(meltdata, Subject + Label ~ variable, mean)

write.table(tidydata, file = "./tidyDataSet.txt")

##write.table(mergeddata, row.names = FALSE, file = "./UCI-HAR-Dataset/Cleaning-data/tidyDataSet.txt")