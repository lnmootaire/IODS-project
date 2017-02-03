# Ellen Mutter, February 3rd 2017, This file contains a dataset with the variables gender, age, attitude, deep, stra, surf, and points

learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep = "\t", header = TRUE)

# dim(learning2014)
# This data has dimensions of 183 rows and 60 columns 
#str(learning2014)
# The structure of this data currently has 183 observations of 60 variables
#install.packages("dplyr")
library(dplyr)

#questions related to deep, surface, and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(learning2014, one_of(deep_questions))
learning2014$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(learning2014, one_of(surface_questions))
learning2014$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(learning2014, one_of(strategic_questions))
learning2014$stra <- rowMeans(strategic_columns)

# changing attitude to be scaled 
learning2014$attitude <- learning2014$Attitude / 10

# choose a handful of columns to keep
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset
learning2014_keep <- select(learning2014, one_of(keep_columns))

# select rows where points is greater than zero
learning2014_keep <- filter(learning2014_keep, Points > 0)

#check the structure of the new dataset
str(learning2014_keep)

#write to file
setwd("~/IODS-project/data")
write.csv(learning2014_keep, file = "learning2014.csv")

#read in file
read_learning <- read.csv("learning2014.csv")
str(read_learning)
head(read_learning)
