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
