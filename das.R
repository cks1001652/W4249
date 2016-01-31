library(repmis)
library(dplyr)
library(data.table)


########
#'
#'Read in Dataset 
#'@par:
#'colsToKeep : vector of strings / parameters to be kept
#'reRead     : Boolean / TRUE if reread in raw data needed
#'pathA      : string / path of "ss13pusa.csv"
#'pathB      : string / path of "ss13pusb.csv"
#'

readIn = function(reRead, colsToKeep, pathA, pathB){
  if(reRead == TRUE){
    popDataA = fread(pathA, select = colsToKeep)
    popDataB = fread(pathB, select = colsToKeep)
    popData = rbind(popDataA, popDataB)
    rm(popDataA, popDataB)
    save(popData, file = "popData.RData")
  }else{
    load("popData.RData")
  }
  return(popData)
}

data1 <- readIn(T,c("ST","FES","HHT","FINCP","HINCP","BLD"),"/Users/cheeseloveicecream/Documents/columbia/W4249/ss13husa.csv","/Users/cheeseloveicecream/Documents/columbia/W4249/ss13husb.csv")
dim(data1)

# matrix format data

pathA <- "/Users/cheeseloveicecream/Documents/columbia/W4249/ss13husa.csv"
pathB <- "/Users/cheeseloveicecream/Documents/columbia/W4249/ss13husb.csv"
colsToKeep <- c("ST","FES","HHT","FINCP","HINCP","BLD")
data2a<-fread(pathA, select = colsToKeep)
data2b<-fread(pathB, select = colsToKeep)
data2 <- rbind(data2a,data2b)
rm(data2a,data2b)
ls(data2)
summary(data2)
data2$ST <- as.factor(data2$ST)
data2$FES <- as.factor(data2$FES)
data2$HHT <- as.factor(data2$HHT)
data2$BLD <- as.factor(data2$BLD)
is.na(data2)
data22 <- as.data.frame(data2)
houseincome <- cbind(data22[,1],data22[,6])
houseincome <- na.omit(houseincome)

colnames(houseincome) <- c("ST","HINCP")
houseincome[1,]

ST.anno <- read.csv("/Users/cheeseloveicecream/Documents/columbia/W4249/statenames.csv")
houseincome <- left_join(houseincome, ST.anno, by = c("ST" = "code"))
select(sample_n(homeincome, 5), ST, name, abbr)


houseincome1 <- data.frame(seq(1,56),NA)
colnames(houseincome1) <- c("State","Average Household Income")
for(i in 1:56){
	houseincome1[i,2] <- mean(houseincome[houseincome[,1]==i,2])
}	
plot(houseincome1[,1],houseincome1[,2],xlab='States',ylab='Average Household Income')

houseincome1 <- cbind(state[1:56,3],houseincome1)


# # #'
# #'preProcess the data
# #'@par:
# #'populData  : Dataset
# #'filter    : Boolean / TRUE if filtering needed
# #'PARF      : vector / parameter to filter by
# #'criteria  : vector / Only for PARF %in% criteria will remain
# #'group     : Boolean / TRUE if grouping needed
# #'PARG      : vector / parameter to group by
# #'

# preProcess = function(populData, filter, PARF, criteria, group, PARG){
  # populData = tbl_df(populData)
  # ds = populData %>%
    # na.omit()
  # if(filter){
    # filter(ds, PARF %in% criteria)
  # }
  # if(group){
    # group_by(ds, PARG)
  # }
  # return(ds)
# }

# data1$ST <- as.factor(data1$ST)
# data1$FES <- as.factor(data1$FES)
# data1$HHT <- as.factor(data1$HHT)
# data1$BLD <- as.factor(data1$BLD)

# plot(data1$ST,data1$HINCP)

# levels(data1$ST)

# trail1 <- matrix(0,nrow=56,ncol=2)
# trail1[,1] <- as.factor(seq(1,56))
