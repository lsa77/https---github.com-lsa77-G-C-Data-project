##########################################################################################
#the structure of this script file is as follows:
#PART 1 - definitions of functions used 
#PART 2 - function MAIN that executes the main logic in this project
##########################################################################################
###PART 1 START

#merges X_train and X_test into one data frame
merge_sets <-function ( data_path = 'data' ) {
    
    train_x_path<-paste( data_path,"/train/X_train.txt", sep = "")
    test_x_path <-paste( data_path,"/test/X_test.txt"  , sep = "")
    
    train_x<-read.table(train_x_path)
    test_x <-read.table(test_x_path)
    
    merged<-rbind(train_x, test_x)
    return (merged)
    
}


#prepares dataframe containing column names that are std or mean
#   COL_NBR                         COLNAME  COL
#1        1               tBodyAcc-mean()-X   V1
#2        2               tBodyAcc-mean()-Y   V2
#3        3               tBodyAcc-mean()-Z   V3
#4        4                tBodyAcc-std()-X   V4
#5        5                tBodyAcc-std()-Y   V5
#etc
get_colnames <- function( data_path = "data") {
    
    features_path<-paste(data_path, "/features.txt", sep = "")
    colnames_tab<-read.table(features_path, col.names = c('COL_NBR', "COLNAME"))
    
    std_mean<-filter(colnames_tab, grepl('std|mean', COLNAME))
    col_nbr<-paste("V", std_mean$COL_NBR, sep = "")
    std_mean$COL<-col_nbr
    return(std_mean)
}

extract <- function(data_set, colnames){
    extr<-select(data_set,  colnames$COL_NBR )
    return(extr)
}

activities<-function( data_path = "data", data_set){
    library("dplyr")
    activity_labels_path<-paste(data_path, "/activity_labels.txt", sep = "")
    activity_labels<-read.table(activity_labels_path, col.names = c('ACT', "ACTIVITY"))

    train_y_path<-paste( data_path,"/train/Y_train.txt", sep = "")
    test_y_path <-paste( data_path,"/test/Y_test.txt"  , sep = "")
    
    train_y<-read.table(train_y_path)
    test_y <-read.table(test_y_path)

    activity<-rbind(train_y, test_y)
    data_set$ACT<-activity[,1]
    
    data_set_descr <- inner_join(data_set, activity_labels)
    
    data_set_descr <- select(data_set_descr, -ACT)
    return (data_set_descr)
}

subjects<-function( data_path = "data", data_set){
    library("dplyr")

    subj_train_path<-paste( data_path,"/train/subject_train.txt", sep = "")
    subj_test_path <-paste( data_path,"/test/subject_test.txt"  , sep = "")
    
    strain<-read.table(subj_train_path)
    stest <-read.table(subj_test_path)
    
    subject<-rbind(strain, stest)
    data_set$SUBJECT<-subject[,1]
    
    return (data_set)
}


rename <- function( data_set, colnames) {
    act_names = names(data_set)
    for (i in 1:length(act_names)) {
        if (!is.na(colnames[i,2])){
            long_name = as.character(colnames[i,2]) 
            act_names[i] = long_name
        }
    }
    names(data_set)<-act_names
    return(data_set)
}

###PART 1 END
##########################################################################################
###PART 2 START
main<-function(data_path = "data") {
    library("dplyr")
    
    #1.	Merges the training and the test sets to create one data set.
        merged<-merge_sets(data_path = data_path)

    #2. Extracts only the measurements on the mean and standard deviation for each measurement. 
        col_names  <- get_colnames( data_path = data_path)
        std_mean   <- extract( merged, col_names )
    #3. Uses descriptive activity names to name the activities in the data set
        data_set <- activities( data_path = data_path, data_set = std_mean)
    
    #4.	Appropriately labels the data set with descriptive variable names.
        data_set <- rename(data_set, col_names)
    
    #5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
    #for each activity and each subject.
        #this function adds subject column to the main data set
        data_set <- subjects(data_path = data_path, data_set)
    
    output <- data_set %>% group_by(ACTIVITY, SUBJECT) %>% summarise_each(funs(mean))
    write.table( output, file = "avg_act_subj.txt", row.names = FALSE )
    #write.csv( output, file = "avg_act_subj.csv", row.names = FALSE ) #JUST FOR A QUICK TEST
    return(output)
}
###PART 2 END