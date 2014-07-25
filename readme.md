### The data analysis code execution:

a. start the R environment

b. change the ""working directory":

	`choose the directory that contains "UCI-HAR-Dataset"`

c. execute:

	`source( "run_analysis.R" )`

d. the code generates the "tidy" dataset in the file:

    `dataset.train.test.tidy.mean.txt`
    
      
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


### The code has two major blocks:

* domain independent functions that follow the SQL paradigm

* domain dependent functions that implement this analysis workflow


### The domain independent functions are:
* SELECT FROM WHERE | UNION | GROUP | ORDER | JOIN | RENAME | ADD_ATTR

* these functions are inspired by the corresponding SQL statements (i.e., the relational algebra operators)


### The domain dependent functions are:

* "buildDatasetHAR" that executes the same procedure both for the "train" and the "test" datasets
 
* and remaining script execution was kept flat (i.e., was not further broken down into functions)


