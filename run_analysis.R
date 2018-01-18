# prerocess original dataset (filtering, column renaming, joining labels, etc.)
tidy_data <- function(){

    #--------------------------------------------------------------------------------
    # setup constants
    DATA_ROOT <- "UCI HAR Dataset"
    
    F_FEATURE_LABELS <- file.path(DATA_ROOT, "features.txt")
    
    F_MEASUREMENTS <- c(file.path(DATA_ROOT, "test", "X_test.txt"),
                        file.path(DATA_ROOT, "train", "X_train.txt"))
    
    F_ACTIVITIES <- c(file.path(DATA_ROOT, "test", "y_test.txt"),
                      file.path(DATA_ROOT, "train", "y_train.txt"))
    
    F_SUBJECTS <- c(file.path(DATA_ROOT, "test", "subject_test.txt"),
                    file.path(DATA_ROOT, "train", "subject_train.txt"))
    
    F_ACTIVITIE_LABELS <- file.path(DATA_ROOT, "activity_labels.txt")
    
    #--------------------------------------------------------------------------------
    # read all source files & merge data
    
    # read files with same data structure and returns merged data frame
    read_data <- function (files){
        result <- data.frame()
        
        for (i in 1:length(files)){
            data <- fread(files[i])
            result <- rbind(result, data) 
        }
        result
    }
    
    measurments <- read_data(F_MEASUREMENTS)
    activities <- read_data(F_ACTIVITIES)
    subjects <- read_data(F_SUBJECTS)
    
    activity_labels <- fread(F_ACTIVITIE_LABELS)
    feature_labels <- fread(F_FEATURE_LABELS)
    
    # remove features mit problematic titles
    feature_labels <- feature_labels[-c(303:344, 382:423, 461:502),]
    measurments <- measurments[,-c(303:344, 382:423, 461:502)]
    
    
    # assing feature labels to measurments
    names(measurments) <- feature_labels$V2
    
    # add subject column and activity column
    measurments$Subject <- subjects$V1
    measurments$Activity <- activities$V1
    
    
    #--------------------------------------------------------------------------------
    # filter the data set
    filtered <- tbl_df(measurments) %>% select(
        Subject,
        Activity,
        contains("-std()"),
        contains("-mean()"))
    
    #--------------------------------------------------------------------------------
    # replace activities with meaningful lables
    for (i in 1:nrow(activity_labels)){
        filtered$Activity[filtered$Activity == activity_labels$V1[i]] <- activity_labels$V2[i]
    }

    #--------------------------------------------------------------------------------
    #rename columns
    col_names <- names(filtered)
    col_names <- gsub("\\-std\\(\\)\\-", "Std", col_names)
    col_names <- gsub("\\-mean\\(\\)\\-", "Mean", col_names)
    col_names <- gsub("\\-std\\(\\)", "Std", col_names)
    col_names <- gsub("\\-mean\\(\\)", "Mean", col_names)

    col_names <- sub("^t", "Time", col_names)
    col_names <- sub("^f", "Fourier", col_names)
    col_names <- sub("Acc", "Accelerometer", col_names)
    col_names <- sub("Gyro", "Gyroscope", col_names)

    names(filtered) <- col_names
    
    #--------------------------------------------------------------------------------
    # return final result
    filtered    
}

#------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------
# create new averaged dataset from tidy source data

# load required libraries
load_lib <- function(name){
    if (!name %in% loadedNamespaces()){
        library(name, character.only = TRUE)
    } 
}
LIBS <- c("data.table", "dplyr")
sapply(LIBS, load_lib)

# get tidy source data
tidy_data <- tbl_df(tidy_data())

# create averaged dataset by calculating the mean of each column (per group: Subject / Activity)
averaged_data <- tidy_data %>% group_by(Subject, Activity) %>% summarise_all(funs(mean))

# save new dataset to file
write.table(averaged_data, "averaged_data.csv")
