## Included files:

- `run_analysis.R`, that executes the "data analysis""

- `run_generateCodeBook.R`, that generates the code book with each variable description (extracted from the original code book file)

- `features.tidy.txt`, is the code book generated by the "build_codeBook.R"; there are two additional features (regarding the original code book file) that are the "subject" and "activity"

- `features_info.tidy.txt`, describes the variables and the way they were computed; provides a first paragraph describing the main difference regarding the original "UCI-HAR-Dataset"

*Note: there is a piece of code that is common to both the "run_analysis.R" and "run_generateCodeBook.R" files; such code was not factored (into a different file) in order to keep each file self-contained.*     


## - The "data analysis" execution:

a. start the R environment

b. change the ""working directory":

	choose the directory that contains "UCI-HAR-Dataset"

c. execute:

	source( "run_analysis.R" )

d. the code generates the "tidy" dataset in the file:

    dataset.train.test.tidy.mean.txt
    
      
### The "run_analysis.R" steps:

1. get the feature names
2. get the 'activity' feature labels
3. get the 'train' 'X' & 'y' & 'subject' data
4. build the 'train' dataset (with descriptive 'activity' labels)
5. get the 'test' 'X' & 'y' & 'subject' data
6. build the 'train' dataset (with descriptive 'activity' labels)
7. build the union of 'train and 'test' dataset
8. extract the 'mean' and 'std' features
9. build the tidy dataset (mean grouped by 'activity & 'subject')
10. write the tidy dataset to file:
    `dataset.train.test.tidy.mean.txt`

***The "coding conventions" are described in the initial comments of "run_analysis.R" file.***


### The "run_analysis.R" two major blocks:

* domain independent functions that follow the SQL paradigm

* domain dependent functions that implement this "data analysis"" workflow


##### >> The domain independent functions are:
* SELECT FROM WHERE | UNION | GROUP | ORDER | JOIN | RENAME | ADD_ATTR

* these functions are inspired by the corresponding SQL statements (i.e., the relational algebra operators)


##### >> The domain dependent functions are:

* "buildDatasetHAR" that executes the same ""data transform workflow" both for the "train" and the "test" datasets
 
* and remaining script execution was kept flat (i.e., was not further broken down into functions)

* the goal was to keep the code "as simple (readable) as possible"



## - The "code book" generation:

a. start the R environment

b. change the ""working directory":

	choose the directory that contains "UCI-HAR-Dataset"

c. execute:

	source( "build_codeBook.R" )

d. the code generates the "tidy" code book in the file:

    features.tidy.txt


### The "build_codeBook.R" steps:

1. get the feature names
2. extract the 'mean' and 'std' features
3. append the 'subject' and 'activity' features
4. write the tidy features to file:
    `features.tidy.txt`


##### The "tidy" dataset main differences (regarding the original "UCI-HAR-Dataset") are:

a. this "tidy" dataset only includes features about measurements on the mean and standard deviation for each measurement

b. this "tidy" dataset two additional features: 'subject' and 'activity'

c. all those "measurements features" (cf. item a) are aggregated by 'subject' and 'activity' (cf. item b) and the average (of each group) is represented as an example (row) of the dataset


#### *Additional information:*
* the code comments describe all the details needed to understand the approach
