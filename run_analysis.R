library(data.table)

## Reading Activity Labels
activitylabels <- read.table("../activity_labels.txt")
activitylabels <- activitylabels[,2]

## Reading Features
features <- read.table("../features.txt")
features <- features[,2]

## Extract Measurements
extractmeasurements <- grepl("mean|std", features)

## Read test data
xtest <- read.table("../test/X_test.txt")
ytest <- read.table("../test/y_test.txt")
subjectest <- read.table("../test/subject_test.txt")

names(xtest) = features

xtest <- xtest[,extractmeasurements]

ytest[,2] = activitylabels[ytest[,1]]
names(ytest) = c("ID", "Label")
names(subjectest) = "Subject"

testdata <- cbind(as.data.table(subjectest), ytest, xtest)


# Read train data.
xtrain <- read.table("../train/X_train.txt")
ytrain <- read.table("../train/y_train.txt")

subjectrain <- read.table("../train/subject_train.txt")

names(xtrain) = features

xtrain = xtrain[,extractmeasurements]

ytrain[,2] = activitylabels[ytrain[,1]]
names(ytrain) = c("ID", "Label")
names(subjectrain) = "Subject"

traindata <- cbind(as.data.table(subjectrain), ytrain, xtrain)

mergeddata <- rbind(testdata,traindata)

write.table(mergeddata, file = "../tidy_data.txt")