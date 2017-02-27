#read in Human development
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

#read in Gender inequality
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

structure(hd)
structure(gii)
dim(hd)
dim(gii)
colnames(hd)
#gii has 195 observations of 10 variables while hd has 195 observations of 8 variables. These variables include, Country, HDI Rank, HDI, Life Expectancy at Birth, GNI, GII, Maternal Morality Ration, Adolescent Birth Rate, etc.

#rename metadata
#install.packages("plyr")
#install.packages("dplyr")
library(plyr)
library(dplyr)
colnames(hd)[3] <- "HDI"
colnames(hd)[4] <- "LifeInd"
colnames(hd)[5] <- "ExpKnowInd"
colnames(hd)[6] <- "MeanKnowInd"
colnames(hd)[7] <- "GNI"
colnames(hd)[8] <- "GNI-HDI.Rank"

colnames(gii)[3] <- "GII"
colnames(gii)[4] <- "MatMor"
colnames(gii)[5] <- "AdoBR"
colnames(gii)[6] <- "PerParl"
colnames(gii)[7] <- "edu2F"
colnames(gii)[8] <- "edu2M"
colnames(gii)[9] <- "labF"
colnames(gii)[10] <- "labM"

#Mutate the “Gender inequality” data
gii <- mutate(gii, edu2.ratio = (edu2F / edu2M))
gii <- mutate(gii, lab.ratio = (labF / labM))

#Join together data
human <- inner_join(gii, hd, by = "Country")
dim(human)
head(human)

#### Beginning of Final Data Wrangling Assignment 5
library(stringr)
library(plyr)
library(dplyr)

#mutation of Human GNI to numeric

human$GNI <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric

head(human)


#Exclude unneeded variables: keep only:  "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F"
keep <- c("Country", "edu2F", "labF", "LifeInd", "ExpKnowInd", "GNI", "MatMor", "AdoBR", "PerParl")
human <- select(human, one_of(keep))


#Remove rows with missing values
complete.cases(human)
data.frame(human[-1], comp = complete.cases(human))
human <- filter(human, complete.cases(human))

#Remove the observations which relate to regions instead of countries (the last seven entries)
last <- nrow(human) - 7
human <- human[1:last, ]

#Define the row names of the data by the country names and remove the country name column from the data. The data should now have 155 observations and 8 variables. Save the human data in your data folder including the row names. 
rownames(human) <- human$Country
human <- select(human, -Country)
dim(human)
write.csv(human, file = "~/Documents/IODS-project/data/human.csv")
