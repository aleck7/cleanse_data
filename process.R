library(plyr)
# load data
# training set
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")
# test set
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# build output data set
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# we need only mean & stddev
features <- read.table("features.txt")
mean_stddev_features <- grep("-(mean|std)\\(\\)", features[, 2])
x_data <- x_data[, mean_stddev_features]
# change column name
names(x_data) <- features[mean_stddev_features, 2]

# activities
activities <- read.table("activity_labels.txt")
y_data[, 1] <- activities[y_data[, 1], 2]
names(y_data) <- "activity"

# build resulting data set
names(subject_data) <- "subject"
all_data <- cbind(x_data, y_data, subject_data)

# do averages & output it
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(averages_data, "averages_data.txt", row.name=FALSE)
