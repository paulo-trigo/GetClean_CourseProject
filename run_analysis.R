##________________________________________________________________________
## Getting—and-Cleaning-Data-course-coursera
## Programming Assignment:
## Wearable Computing
## (peer assessment)
##
## author: Paulo Trigo Silva (PTS)
## JUL-2014
##________________________________________________________________________


##________________________________________________________________________
## :: Adopted Coding Conventions ::
##
## Variable name:
## - do NOT use underscores ( _ ) or hyphens ( - )
## - all lower case letters with words separated with dots, e.g., variable.name
## - double dot prefix for variables, in a closure,
##   is being used from a child environment
## | GOOD: msg.prefix | BAD: msgPrefix | BAD: msg_prefix
## | ..x.inv indicates usage by a child environment (e.g., inner function) 
##
## Function name:
## - camelCase (lower case letters with words separated with capital letter),
## - ALL_CAPITAL_LETTERS (all capital letters separated with underscore)
##   e.g., functionName or FUNCTION_NAME
## | GOOD: makeCacheMatrix | BAD: MakeCacheMatrix | BAD: make_cache_matrix
## | GOOD: ADD_ATTR | BAD: ADDattr | BAD: addATTR
##
## Constants:
## - named like functions but with an initial "k."
##________________________________________________________________________



##________________________________________________________________________
# cleanup
# removes all objects except for functions:
rm( list = setdiff( ls(), lsf.str() ) )
cat( "Getting—and-Cleaning-Data - Programming Assignment\n" )



##________________________________________________________________________
# set the current working directory
work.dir.initial <- getwd()
data.dir <- "UCI-HAR-Dataset"
work.dir <- file.path( work.dir.initial, data.dir )
if( !file.exists ( work.dir ) )
   stop( paste( ">> current directory must contain:", data.dir ) )
setwd( work.dir )


##
##________________________________________________________________________
## additional package install and load
#if( !("plyr" %in% rownames( installed.packages())) ) install.packages( "plyr" )
#library( plyr )
## NOTE:
## - "plyr" is reported to be slow (with large datasets)
## - therefore I decided not to use "plyr"
##________________________________________________________________________


##________________________________________________________________________
# utility functions
##________________________________________________________________________
## return dataset read from the "filename" at "dir"
## assumes a format of values separated by spaces (without header)
## (best read by the "read.table()" function)
getTable <- function( filename, dir, dir.curr=".",
                      filename.ext=".txt", path.sep="/" ) {
   dataset.filename <- paste( dir.curr, path.sep, dir, path.sep,
                              filename, filename.ext, sep="" )
   dataset <- read.table( dataset.filename )
   return( dataset )
}
##________________________________________________________________________


##________________________________________________________________________
##________________________________________________________________________
## ::domain independent functions::
## ::SQL-like statements::
## - functions to support "relational algebra"-like operators approach
## SELECT FROM WHERE | UNION | GROUP | ORDER | JOIN | RENAME | ADD_ATTR
##________________________________________________________________________
##________________________________________________________________________
SELECT <- function( ATTR=c("*"), FROM=data.frame(), WHERE=NULL ) {
   if( length( ATTR )==1 ) if( ATTR=="*" ) ATTR <- names( FROM )
   if( ! is.null( WHERE ) ) result <- FROM[ WHERE, ]
   else result <- FROM
   result <- result[ ATTR ]
   return( result )
}


UNION <- function( T1, T2 ) {
   result <- rbind( T1, T2 )
   return( result )
}


GROUP <- function( ATTR.BY, ATTR.AGGR, FROM, FUN.AGGR ) {
   ## NOTE:
   ## - "plyr" is reported to be slow (with large datasets)
   ## - therefore I decided not to use "plyr"
   ##result <- ddply( FROM, as.quoted( BY ), FUN.AGGR )

   ## formula has the format: LHS ~ RHS
   ## where: LHS are the dependent and RHS are the independent variables
   LHS <- ATTR.AGGR
   if( length( ATTR.AGGR ) > 1 ) LHS <- paste( ATTR.AGGR, collapse="+" )
   RHS <- ATTR.BY
   if( length( ATTR.BY ) > 1 ) RHS <- paste( ATTR.BY, collapse="+" )

   the.formula <- as.formula( paste( LHS, "~", RHS ) )
   result <- aggregate( formula=the.formula, data=FROM, FUN=FUN.AGGR )
   return( result )
}


ORDER <- function( ATTR.BY, FROM ) {
   result <- FROM[ order( ATTR.BY ), ] 
   return( result )
}


JOIN <- function( T1, T2, ON.T1, ON.T2 ) {
   result <- merge( T1, T2, by.x=ON.T1, by.y=ON.T2, all=FALSE )
   return( result )
}


RENAME <- function( ATTR.OLD, ATTR.NEW, FROM ) {
   index <- which( colnames( FROM )==ATTR.OLD )
   colnames( FROM )[ index ] <- ATTR.NEW
   return( FROM )
}


ADD_ATTR <- function( ATTR.NAME, ATTR.DATA, FROM ) {
   FROM[ ATTR.NAME ] <- ATTR.DATA
   return( FROM )
}



##________________________________________________________________________
##________________________________________________________________________
## This R-script performs the following "Getting-and-Cleaning" steps:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the:
##    - mean and standard deviation for each measurement.
## 3. Uses descriptive activity names
##    to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
##
## 5. Creates a second, independent tidy data set with the:
##    - average of each variable for each activity and each subject.
##________________________________________________________________________
##________________________________________________________________________


##________________________________________________________________________
## ::domain dependent function (buildDatasetHAR)::
## the input parameters are:
## - the feature names, X data.frame (df.X) and y (df.y)
## - the y labels and the y feature name
## - an attribute to be added and its corresponding value
##
## the output is a dataset that implements:
## - 3. Uses descriptive activity names
##      to name the activities in the data set
## - 4. Appropriately labels the data set with descriptive variable names
## - extend the dataset to include the "subject" and "activity" features
## 
##________________________________________________________________________
buildDatasetHAR <- function( df.feature.names, df.X, df.y,
                             df.y.labels, attr.name.y,
                             attr.name.add, attr.data.add ) {
   # rename df.y labels with df.y.labels (this gets a factor)
   df.y <- factor( df.y, labels=df.y.labels )

   # transforms df.y back into a data.frame and set its name
   df.y <- data.frame( df.y )
   names( df.y ) <- c( attr.name.y )

   # rename the features of df.X with df.feature.names
   df.X <-
      RENAME(
         ATTR.OLD=names( df.X ),
         ATTR.NEW=df.feature.names,
         FROM=df.X )

   # build df.dataset by extending df.X with:
   # - feature "attr.name.add" having data "attr.data.add", and
   # - feature "attr.name.y" having data "df.y"
   df.dataset <-
      ADD_ATTR(
         ATTR.NAME=c( attr.name.add, attr.name.y ),
         ATTR.DATA=cbind( attr.data.add, df.y ),
         FROM=df.X )

   # filter the complete cases (i.e., not containing NA)
   df.dataset <- df.dataset[ complete.cases( df.dataset ), ]
   return( df.dataset )
}



##________________________________________________________________________
## :: the main body of the script ::
## - assumes that the current directory ("dir.curr") is "UCI-HAR-Dataset"
##________________________________________________________________________
# get the feature names
# - names are guaranteed to be syntactically valid via "make.names"
cat( "- get the feature names\n" )
df.feature.names <- getTable( filename="features", dir="." )
df.feature.names <- make.names( as.character( df.feature.names$V2 ) )


##________________________________________________________________________
# build each dataset (train and test) with:
# - proper feature names, and
# - additional "subject" feature, and
# - "y" feature with "activity" labels
##________________________________________________________________________
cat( "- get the 'activity' feature labels\n" )
attr.name.subject <- "subject"
attr.name.activity <- "activity"
df.activity.labels <- getTable( filename="activity_labels", dir="." )


##________________________________________________________________________
# build the "train" dataset
##________________________________________________________________________
cat( "- get the 'train' 'X' & 'y' & 'subject' data\n" )
df.X <- getTable( filename="X_train", dir="train" )
df.y <- getTable( filename="y_train", dir="train" )
df.subject <- getTable( filename="subject_train", dir="train" )

cat( "- build the 'train' dataset (with descriptive 'activity' labels)\n" )
df.dataset.train <-
   buildDatasetHAR(
      df.feature.names=df.feature.names, df.X=df.X, df.y=df.y$V1,
      df.y.labels=df.activity.labels$V2, attr.name.y=attr.name.activity,
      attr.name.add=attr.name.subject,
      attr.data.add=df.subject )

#head( df.dataset.train )
#names( df.dataset.train )


##________________________________________________________________________
# build the "test" dataset
##________________________________________________________________________
cat( "- get the 'test' 'X' & 'y' & 'subject' data\n" )
df.X <- getTable( filename="X_test", dir="test" )
df.y <- getTable( filename="y_test", dir="test" )
df.subject <- getTable( filename="subject_test", dir="test" )

cat( "- build the 'train' dataset (with descriptive 'activity' labels)\n" )
df.dataset.test <-
   buildDatasetHAR(
      df.feature.names=df.feature.names, df.X=df.X, df.y=df.y$V1,
      df.y.labels=df.activity.labels$V2, attr.name.y=attr.name.activity,
      attr.name.add=attr.name.subject,
      attr.data.add=df.subject )
#head( df.dataset.test )
#names( df.dataset.test )


##________________________________________________________________________
# build the UNION of "train" and "test" datasets
##________________________________________________________________________
cat( "- build the union of 'train and 'test' dataset\n" )
df.dataset <-
   UNION( T1=df.dataset.train, T2=df.dataset.test )

#dim( df.dataset )
#[1] 10299   563

#nrow( df.dataset.train ) + nrow( df.dataset.test )
#[1] 10299


##________________________________________________________________________
## extract, from the dataset, only the:
# - "mean" and "std" features, and 
# - also the "subject" and "activity"
##________________________________________________________________________
cat( "- extract the 'mean' and 'std' features\n" )
regexp <- paste0( "(mean|std", "|", 
                  attr.name.subject, "|", 
                  attr.name.activity, ")" )
df.dataset <- df.dataset[ grep( regexp, names( df.dataset ), value=TRUE ) ]

dim( df.dataset )
#[1] 10299   81

#head( df.dataset )
#names( df.dataset )



##________________________________________________________________________
# write the resulting dataset (train&test)
##________________________________________________________________________
#filename <- "dataset.train.test"
#file.ext <- ".txt"
#filename <- paste0( filename, file.ext )
#write.table( df.dataset, file=filename, quote=FALSE )

#file.info( file=filename )$size
#[1] 9907459

#df.dataset <- getTable( filename=filename, dir="." )
##________________________________________________________________________




##________________________________________________________________________
## 5. Creates a second, independent tidy data set with the:
##    - average of each variable for each activity and each subject.
cat( "- build the tidy dataset (mean grouped by 'activity & 'subject')\n" )
df.dataset.tidy.mean <-
   GROUP(
      ATTR.BY=c( attr.name.activity, attr.name.subject ),
      ATTR.AGGR=".",
      FROM=df.dataset,
      FUN.AGGR="mean"
)
dim( df.dataset.tidy.mean )
#[1] 180  81

##________________________________________________________________________
## write the resulting dataset (mean of each feature in train&test)
filename <- "dataset.train.test.tidy.mean"
file.ext <- ".txt"
filename <- paste0( filename, file.ext )
cat( "- write the tidy dataset to file: ", '"', filename, '"', "\n", sep="" )
# return to the initial current working directory
setwd( work.dir.initial )

write.table( df.dataset.tidy.mean, file=filename, quote=FALSE )

file.info( file=filename )$size
#[1] 268630

#df.dataset.tidy.mean <- getTable( filename=filename, dir="." )
##________________________________________________________________________





