
# To execute analysis, source this file and run 'analyze()' in the R console

# Function 'analyze()' returns the tidy data in two places:
#     To a file 'getdata-project-ph.txt' in the working directory
#     To the R console (run 'data <- analyze()' to store result in a variable).

# To write 'data' to a file:
#     write.table(data,'./getdata-project-ph.txt', row.name=F)




# Function 'read_files()' returns raw tables from the source data as global variables.
# Function 'combine()' returns tidy data from the source material.

# Functions 'analyze(rd)' and 'combine(rd)' accept a value for variable 'rd'
# If no value for 'rd' is set, it is set to 1 by default
#     If 'rd' == 1 the source files are read into variables
#     If 'rd' == 0 (or any value other than one) files are not read
#     (this feature is useful when iterating on code.)

# Variables:
#    Subject(Int-UserID),
#    Activity(Char-ActivityLabel),
#    ... calculations (limited to mean() and std() measurements)
#       tBodyAcc.mean...X,tBodyAcc.mean...Y,tBodyAcc.mean...Z,
#       tGravityAcc.mean...X,tGravityAcc.mean...Y,tGravityAcc.mean...Z,
#       tBodyAccJerk.mean...X,tBodyAccJerk.mean...Y,tBodyAccJerk.mean...Z,
#       tBodyGyro.mean...X,tBodyGyro.mean...Y,tBodyGyro.mean...Z,
#       tBodyGyroJerk.mean...X,tBodyGyroJerk.mean...Y,tBodyGyroJerk.mean...Z,
#       tBodyAccMag.mean..,tGravityAccMag.mean..,tBodyAccJerkMag.mean..,
#       tBodyGyroMag.mean..,tBodyGyroJerkMag.mean..,fBodyAcc.mean...X,
#       fBodyAcc.mean...Y,fBodyAcc.mean...Z,fBodyAccJerk.mean...X,
#       fBodyAccJerk.mean...Y,fBodyAccJerk.mean...Z,fBodyGyro.mean...X,
#       fBodyGyro.mean...Y,fBodyGyro.mean...Z,fBodyAccMag.mean..,
#       fBodyBodyAccJerkMag.mean..,fBodyBodyGyroMag.mean..,
#       fBodyBodyGyroJerkMag.mean..,tBodyAcc.std...X,tBodyAcc.std...Y,
#       tBodyAcc.std...Z,tGravityAcc.std...X,tGravityAcc.std...Y,
#       tGravityAcc.std...Z,tBodyAccJerk.std...X,tBodyAccJerk.std...Y,
#       tBodyAccJerk.std...Z,tBodyGyro.std...X,tBodyGyro.std...Y,
#       tBodyGyro.std...Z,tBodyGyroJerk.std...X,tBodyGyroJerk.std...Y,
#       tBodyGyroJerk.std...Z,tBodyAccMag.std..,tGravityAccMag.std..,
#       tBodyAccJerkMag.std..,tBodyGyroMag.std..,tBodyGyroJerkMag.std..,
#       fBodyAcc.std...X,fBodyAcc.std...Y,fBodyAcc.std...Z,fBodyAccJerk.std...X,
#       fBodyAccJerk.std...Y,fBodyAccJerk.std...Z,fBodyGyro.std...X,
#       fBodyGyro.std...Y,fBodyGyro.std...Z,fBodyAccMag.std..,
#       fBodyBodyAccJerkMag.std..,fBodyBodyGyroMag.std..,fBodyBodyGyroJerkMag.std..


# We require two packages. If not available, they will be downloaded
# and added to the library when this file is sourced

if(!require('data.table')){
    install.packages('data.table')
    require('data.table')
    print('`data.table` loaded...')
}
if(!require('dplyr')){
    install.packages('dplyr')
    require('dplyr')
    print('`dplyr` loaded...')
}

print('run `analyze()` to execute script...')




read_files <- function(){
    # variables are set globally (<<-) to allow subsequent analysis
    # without re-reading files (speeds up development/testing).
    
    # to read files: run combine() or analyze() as needed
    # to skip reading files: run combine(0) or analyze(0)
    
    # Read features.txt containing observerations variable names
    features      <<- read.table('./UCI HAR Dataset/features.txt')

    # Read activity_labels.txt containing index of Activities and 
    # Activity Numbers. Assign variable names.
    # 'act_nums' will be merged to bound data by 'Number'
    act_nums      <<- read.table('./UCI HAR Dataset/activity_labels.txt', 
                                 col.names=c('Number','Activity'))

    # Read subject_{train,test}.txt containing ordered Subject numbers
    # to match to observations. Assign variable name.
    # 'subject_{train,test}' ready for binding after reading
    subject_train <<- read.table('./UCI HAR Dataset/train/subject_train.txt', 
                                 col.names=c('Subject'), 
                                 colClasses='integer')
    subject_test  <<- read.table('./UCI HAR Dataset/test/subject_test.txt', 
                                 col.names=c('Subject'), 
                                 colClasses='integer')

    # Read X_{train,test}.txt containing observations. Assign variable
    # names from column 2 of the features table.
    # 'observations_{train,test}' need processing before final binding.
    observations_train     <<- read.table('./UCI HAR Dataset/train/X_train.txt',
                                          col.names=features[,2], 
                                          colClasses='numeric')
    observations_test      <<- read.table('./UCI HAR Dataset/test/X_test.txt',
                                          col.names=features[,2], 
                                          colClasses='numeric')
    
    # Read Y_{train,test}.txt containing ordered Activity Numbers.
    # Assign variable name.
    # 'number_{train,test}' ready for binding after reading
    number_train  <<- read.table('./UCI HAR Dataset/train/Y_train.txt', 
                                 col.names=c('Number'), 
                                 colClasses='integer')
    number_test   <<- read.table('./UCI HAR Dataset/test/Y_test.txt', 
                                 col.names=c('Number'), 
                                 colClasses='integer')
}

combine <- function(rd=1){

    # Does the user want us to read files? (Defaults to yes)
    if( rd == 1 ){ read_files() } 
    
    # Combine test and training observations into raw observations
    r_observations  <- data.table(rbind(observations_train,observations_test))

    # Exclude everything except raw 'mean' and 'std' columns 
    # from observations table 'r_observations' (will include 'meanFreq')
    r_mean_std      <- subset(r_observations,
                              select=c(r_observations[,grep("mean",
                                                            names(r_observations))],
                                       r_observations[,grep('std',
                                                            names(r_observations))]))
    
    # Exclude false-positive 'meanFreq' names from observations table 'r_mean_std'
    # d_mean_std is the final table of observations, ready for binding.
    d_mean_std      <- subset(r_mean_std,
                             select=r_mean_std[,-grep("meanFreq",
                                                      names(r_mean_std))])
    
    # Bind and combine Activity Number, Subject Number
    # and columns from observations table subset MS    
    d_combined      <- data.table(cbind(rbind(number_train,number_test),
                                        rbind(subject_train,subject_test),
                                        d_mean_std))    

    # Merge clean combined table 'd_combined' with activities by Activity Number
    d_merged        <- merge(data.table(act_nums),d_combined,by='Number')
    
    # Remove now-unnecessary Number column from merged data
    d_tidy          <- subset(d_merged,select=d_merged[,2:ncol(d_merged)])
    
    # Return tidy data (of the wide variety)
    return(d_tidy)
}


analyze <- function(rd=1){
    
    # tidy up the data set (and read files unless told not to: analyse(0))
    a_data      <- combine(rd)

    # Group 'a_data' by Subject and Activity and return average of each column
    a_grouped   <- a_data[, lapply(.SD,mean),by=c('Subject','Activity')]
    
    # Sort grouped data 'a_grouped' by Subject and Activity
    a_tidy      <- arrange(a_grouped,Subject,Activity)
    
    # Set output file and write to disk
    output_file <- './getdata-project-ph3.txt'
    write.table(a_tidy,output_file, row.name=F)
    
    # return tidy data (of the wide variety)
    return(a_tidy)
}
