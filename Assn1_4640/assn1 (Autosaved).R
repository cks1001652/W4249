# problem21
library(foreign)
data <- read.dta("pew_research_center_june_elect_wknd_data.dta")
data1 <- read.csv("2008ElectionResult.csv")
summary(state.abb)
summary(data1)
names(data1)
# replace the abb

data2 <- data1[,-1]
data2[is.na(data2[,6]),6] <- 0
data2[is.na(data2[,5]),5] <- 0

data.frame()
name1 <- state.abb[1:8]
c("")
name2 <- state.abb[9:50]

names(data)
data$age