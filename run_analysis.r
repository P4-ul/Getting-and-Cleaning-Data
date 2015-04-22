## Step 1
# read in all of the data
setwd("C:/Users/Paul Mathewson/Documents/UCI HAR Dataset")
test.labels <- read.table("test/y_test.txt", col.names="label")
test.subjects <- read.table("test/subject_test.txt", col.names="subject")
test.data <- read.table("test/X_test.txt")
train.labels <- read.table("train/y_train.txt", col.names="label")
train.subjects <- read.table("train/subject_train.txt", col.names="subject")
train.data <- read.table("train/X_train.txt")

# Format in particular order: subjects, labels, everything else
data <- rbind(cbind(test.subjects, test.labels, test.data),
              cbind(train.subjects, train.labels, train.data))

## Step 2
# Read in the features
features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)
# Keep only features of mean and standard deviation
features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

# Select only the means and standard deviations from data source
# Increment by 2 
data.mean.std <- data[, c(1, 2, features.mean.std$V1+2)]

## Step 3
# Read the labels (activities)
labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
# replace labels in data with label names
data.mean.std$label <- labels[data.mean.std$label, 2]

## Step 4
# Make a list of the current column names and feature names
good.colnames <- c("subject", "label", features.mean.std$V2)
# Tidy that list
# Remove every non-alphabetic character and convert to lowercase
good.colnames <- tolower(gsub("[^[:alpha:]]", "", good.colnames))
# then use the list as column names for data
colnames(data.mean.std) <- good.colnames

## Step 5
# Find the mean for each combination of subject and label
aggr.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)],
by=list(subject = data.mean.std$subject, 
label = data.mean.std$label),
mean)

## Write the data to .txt
write.table(format(aggr.data, scientific=T), "tidy2.txt",
