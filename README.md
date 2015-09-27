
The script run_analysis.R assumes that you have folder DATA in your working directory. The folder data contains the Samsung data.

In the script there is a number of functions that are used by function main, which returns the tidy data set required by this project.

In the script there is a number of functions that are used by function main, which returns the tidy data set required by this project.

Functions:

* merge_sets() - reads the X_test and X_train files and merges them into one data frame 
* get_colnames() - reads the features.txt file to use its contents as descriptive column descriptions for the data set 
* extract() - extracts mean and std columns from the original data set 
* activities() - adds activity column to the data set 
* rename() - renames the VX columns with the names found in features.txt 
* subjects() - adds the subject column to the data set
* main() - uses the above functions and generates the final output (mean for activity and subject)

