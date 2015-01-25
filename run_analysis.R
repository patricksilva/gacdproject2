# to run this code, source the file appropriately
# the use the run() command

library(dplyr)
library(reshape2)
pkg.env <- new.env()
pkg.env$dataTrainX <- NULL
pkg.env$dataTrainY <- NULL
pkg.env$dataTestX <- NULL
pkg.env$dataTestY <- NULL
pkg.env$trainData <- NULL
pkg.env$features <- NULL
pkg.env$activityLabels <- NULL
pkg.env$summary <- NULL

downloadData <- function() {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "getdataprojectfilesFUCIDataset.zip")
}

loadData <- function(sFileName){
  data <- read.table(sFileName)
  return(data)
}

run <- function(){
  # Load the features, this file contains the column headers
  pkg.env$features <- loadData("features.txt")
  # load the actual label names
  pkg.env$activityLabels <- loadData("activity_labels.txt")

  # load the training data, this file contains the actual data
  pkg.env$dataTrainX <- loadData("train/X_train.txt")
  # assign the column names from $features above to the headers in dataTrainX
  names(pkg.env$dataTrainX) <- pkg.env$features$V2
  # select only the relevant columns for the assignment
  pkg.env$dataTrainX <- pkg.env$dataTrainX[,grepl("mean|std", names(pkg.env$dataTrainX))]
  # load the column that contains the activity label IDs
  pkg.env$dataTrainY <- loadData("train/Y_train.txt")
  # join the label IDS w/ the activity names
  pkg.env$dataTrainY <- inner_join(x = pkg.env$dataTrainY, y = pkg.env$activityLabels)
  # copy the named labels over to the main training dataset
  pkg.env$dataTrainX$Label <- pkg.env$dataTrainY$V2
  # added a variable that explains where the data was sourced
  pkg.env$dataTrainX$Source <- rep("Training", length(pkg.env$dataTrainX$Label))
  
  # load the test data, this file contains the actual data
  pkg.env$dataTestX <- loadData("test/X_test.txt")
  # assign the column names from $features above to the headers in dataTestX
  names(pkg.env$dataTestX) <- pkg.env$features$V2
  # select only the relevant columns for the assignment
  pkg.env$dataTestX <- pkg.env$dataTestX[,grepl("mean|std", names(pkg.env$dataTestX))]
  # load the column that contains the activity label IDs
  pkg.env$dataTestY <- loadData("test/Y_test.txt")
  # join the label IDS w/ the activity names
  pkg.env$dataTestY <- inner_join(x = pkg.env$dataTestY, y = pkg.env$activityLabels)
  # copy the named labels over to the main training dataset  
  pkg.env$dataTestX$Label <- pkg.env$dataTestY$V2
  # added a variable that explains where the data was sourced
  pkg.env$dataTestX$Source <- rep("Testing", length(pkg.env$dataTestX$Label))

  # bind the two data sets together into a single dataset
  pkg.env$trainData <- rbind(pkg.env$dataTrainX, pkg.env$dataTestX)
  # write the now tidy dataset to disk
  write.table(pkg.env$trainData,file = "tidy-data.txt", row.name = FALSE)

  # create a summary statistics table
  pkg.env$summary <- pkg.env$trainData %>%
                      group_by(Source, Label) %>%
                      summarise_each(funs(mean))   

  write.table(pkg.env$trainData,file = "tidy-data-summary.txt", row.name = FALSE)
}