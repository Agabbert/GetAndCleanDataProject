## readme.md for run_analysis.R script

### Summary
The run_anlysis.R script reads and cleans data from the Human Activity from smart phone 
data set which was specified for the project. Specific details on this data
is outlined in an accompanied README.txt within the original data folder.

### This repo contains the following files:
* 'run_analysis.R': Merges test/training data and outputs tidy data means file
* 'readme.md'
* 'codebook.md'
* 'tidy_data_means.txt': Output from the run_analysis.R file
* Original human activity data folder and supporting info
The data is originally separated into
test and training data sets with feature and activity information also
provided. The script first reads subject, x/y test, and x/y training data and
stores the data as objects in R.

After loading the test, train, feature, and activity data, the test
and train data is merged into one data set using only data involving mean and 
standard deviation. Finally, the merged data is turned into a tidy data table
with means calculated for by each subject and activity and is output to a 
text file. Then the same is done for the features data. At this point some 
characters that made the features titles difficult to read are cleaned up. This 
included removing symbols such as "()", ",", "-".  Also meaningful variable names are
applied to subject, x/y test, and x/y training data.

Data from the "activity_labels.txt" file are read and stored as an object in R.
By line 87 there are objects containing data from that we are interested in
with meaningful names and the script begines merging data into a clean data set.
The next steps combine subject, y data, observation, and x data into two 
data frames. One for test and one for training data. Then the test and training
data are merged into a final clean data set complete with meaningful variable
names.

Next the script takes the merged clean data and performs a mean calculation
based on subject and activity using the dplyr and tidyr packages. To do this
the merged clean data is converted to a data frame table object and then 
undergoes a series of selction and summary functions from dplyr and tidyr
to produce the final tidy data set. The final tidy data set is stored as an
and object in r and written out to a text file called "tidy_data_means.txt".
