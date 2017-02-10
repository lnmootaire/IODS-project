# Ellen Mutter, February 10th 2017, This file contains a data from the UCI Machine Learning Repository on student alcohol usage using 1044 instances of 32 attributes.

#read in student-mat.csv and student-por.csv
math <- read.csv("~/IODS-project/data/student-mat.csv", sep = ";", header = TRUE)
por <- read.csv("~/IODS-project/data/student-por.csv", sep = ";", header = TRUE)

#explore structure and dimensions. We see that the dimensiosn of the math file are 395x33 meaning 395 observations of 33 variables. For the por file we see dimensions of 649x33 meaning 649 observations of 33 variables. These variables include things such as: "school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet".
dim(math)
structure(math)
dim(por)
structure(por)

library(dplyr)

#join datasets based on specific variables and explore structure and dimensions
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))
glimpse(math_por)
structure(math_por)

#the joined dataset contains 382 observations of 53 variables so the dimension is 382x53. Again the vairables include "school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet" but variables that were not joined now contain the endings .math or .por depending on which csv they came from. For example: failure.math vs failures.por.

#combine duplicated answers
# first: create a new data frame with only the joined columns. Then save the columns in teh datasets which were not used for joining. Then combine 
alc <- select(math_por, one_of(join_by))
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

# Now combine dublicated answers
# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

#Take the average of the answers related to weekday and weekend alcohol consumption to create a new column 'alc_use' to the joined data. Then use 'alc_use' to create a new logical column 'high_use' which is TRUE for students for which 'alc_use' is greater than 2 (and FALSE otherwise).

library(ggplot2)
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = (alc_use > 2) )

#Glimpse at dataset. As expected we see 382 observations of 35 variables. 
glimpse(alc)

#write to file
write.csv(alc, file = "~/IODS-project/data/alc.csv")
write.csv(math_por, file = "~/IODS-project/data/math_por.csv")
