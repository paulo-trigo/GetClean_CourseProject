## Included files:

- `run_analysis.R`, that executes the "data analysis""

- `build_codeBook.R`, that generates the code book with each variable description (extracted from the original code book file)

- `features.tidy.txt`, the code book generated by the "build_codeBook.R"

- `features_info.tidy.txt`, describes the variables and the way they were computed.


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
2. get the 'train' 'X' & 'y' & 'subject' data
3. build the 'train' dataset
4. get the 'test' 'X' & 'y' & 'subject' data
5. build the 'test' dataset
6. build the union of 'train and 'test' dataset
7. extract the 'mean' and 'std' features
8. build the tidy dataset
9. write the tidy dataset to file:
    `dataset.train.test.tidy.mean.txt`


### The "run_analysis.R" two major blocks:

* domain independent functions that follow the SQL paradigm

* domain dependent functions that implement this analysis workflow


##### >> The domain independent functions are:
* SELECT FROM WHERE | UNION | GROUP | ORDER | JOIN | RENAME | ADD_ATTR

* these functions are inspired by the corresponding SQL statements (i.e., the relational algebra operators)


##### >> The domain dependent functions are:

* "buildDatasetHAR" that executes the same procedure both for the "train" and the "test" datasets
 
* and remaining script execution was kept flat (i.e., was not further broken down into functions)



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
3. write the tidy features to file:
    `features.tidy.txt`

     
#### *Additional information:*
* the code comments describe all the details needed to understand the approach
