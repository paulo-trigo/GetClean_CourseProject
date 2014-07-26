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
## :: the main body of the script ::
## - assumes that the current directory ("dir.curr") is "UCI-HAR-Dataset"
##________________________________________________________________________
# get the feature names
cat( "- get the feature names\n" )
df.feature.names <- getTable( filename="features", dir="." )

cat( "- extract the 'mean' and 'std' features\n" )
regexp <- paste0( "(mean|std)" )
filter <- grep( regexp, df.feature.names$V2, value=FALSE )
df.dataset <- df.feature.names[ filter, ]$V2


##________________________________________________________________________
## write the resulting dataset (mean of each feature in train&test)
filename <- "features.tidy"
file.ext <- ".txt"
filename <- paste0( filename, file.ext )
cat( "- write the tidy features to file: ", '"', filename, '"', "\n", sep="" )
# return to the initial current working directory
setwd( work.dir.initial )

write.table( df.dataset, file=filename )
##________________________________________________________________________





