# Readme

Peer Project for Getting and Cleaning Data (9)

### Installation

Download the file **run_analysis.R** from this repository to the R working directory.

**Requires** **R**, and these R packages: **data.frame** and **dplyr** (the packages will be downloaded, installed and loaded into R if not locally available).



### Analysis

To execute analysis, source the **run_analysis.R** file and run `analyze()` in the R console

Function `analyze()` returns wide tidy data in two places:
- To a file 'getdata-project-ph.txt' in the working directory
- To the R console (run `data <- analyze()` to store result in a variable).

To write 'data' to a file:
    `write.table(data,'./getdata-project-ph.txt', row.name=F)`




Function `read_files()` returns raw tables from the source data as global variables.
Function `combine()` returns tidy data from the source material.

Functions `analyze(rd)` and `combine(rd)` accept a value for variable 'rd'
- If no value for 'rd' is set, files are read (*default behavior*)
- If 'rd' == 1 the source files are read into global variables
- If 'rd' != 1 files are not read (*for debugging speed: uses pre-set globals*)

### Credits

Link to source data, thanks, etc.
