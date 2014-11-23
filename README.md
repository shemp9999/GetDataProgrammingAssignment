## Course Project
*Getting and Cleaning Data (getdata-009)*

### Installation

Download the file **run_analysis.R** from this repository to the R working directory.

Download the [**Human Activity Recognition Using Smartphones dataset**](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 'download dataset zip file') and expand into your working directory. A folder 'UCI HAR Dataset' will be created. More information about this dataset can be found [**here**](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 'dataset description - opens remote web page').

**Requires** **R**, and these R packages: **data.frame** and **dplyr** (packages will be downloaded, installed and loaded into R if not locally available, *network required*).



### Analysis

To execute analysis, source the **run_analysis.R** file and run `analyze()` in the R console

Function `analyze()` returns wide tidy data in two places:
- To a file 'getdata-project-ph.txt' in the working directory
- To the R console (run `data <- analyze()` to store result in a variable).

To write `data` to a file:
    `write.table(data,'./getdata-project-ph.txt', row.name=F)`

Function `read_files()` returns raw tables from the source data as global variables.

Function `combine()` returns tidy data from the source material.

Functions `analyze(rd)` and `combine(rd)` accept a value for variable 'rd'
- If `rd == 1`, source files are read into global variables (*default behavior*)
- If `rd == 0` files are not read (*for debugging speed: uses pre-set globals*)

