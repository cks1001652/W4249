# Preparation
library("dplyr")
library("data.table")
library("ggplot2")
library("choroplethr")

# Readin data
readIn = function(reRead, colsToKeep, pathA, pathB){
  if(reRead == TRUE){
    popDataA = fread(pathA, select = colsToKeep)
    popDataB = fread(pathB, select = colsToKeep)
    popData1 = rbind(popDataA, popDataB)
    rm(popDataA, popDataB)
    save(popData1, file = "popData1.RData")
  }else{
    load("popData1.RData")
  }
  return(popData1)
}

data1 <- readIn(T,c("ST","FES","FINCP","ADJINC"),"/Users/cheeseloveicecream/Documents/columbia/W4249/ss13husa.csv","/Users/cheeseloveicecream/Documents/columbia/W4249/ss13husb.csv")


# Data Manipulation
data1$FINCP <- data1$FINCP*1.007549
data1 <- tbl_df(data1)
ds <- 	data1	%>%
		na.omit()	%>%
		filter(FES	%in%	c(1,2,3,4))	%>%
		group_by(FES)
rm(data1)

# Visuliazation
fescode <- "FES,MarriedFamilyEmployType
1,Both in Labor Force
2,Husband in Labor Force
3,Wife in Labor Force
4,Neither in Labor Force"
fescodes <- fread(fescode)

fesnumbers <- summarise(ds,count=n())
fesnumbers <- left_join(fesnumbers,fescodes,by.x=c("FES"))
Types <- factor(fesnumbers$MarriedFamilyEmployType,levels=unique(fesnumbers$MarriedFamilyEmployType))

# Exploraring the basic statistics
ggplot(fesnumbers, aes(x= Types , y=fesnumbers$count, fill= Types)) +                        
     geom_bar(stat="identity") + scale_fill_hue(l=50) +
     ylab("Num of People") + 
     xlab("Employment Status") + ggtitle("Comparing Enployment status of Married Family in the US") +
     theme(axis.text.x = element_text(angle = 10, hjust = 0.5),
     panel.background = element_rect(fill = 'white' ))

summary(ds$FINCP)
# the 1st quantile is shown as 45800 dollars. We use this as bench line. We want to see the percentage under each type of family who has family income more than 45800 which is approxiamatly middle class.
medianper <- ds	%>%
			filter(FINCP>=77580)		%>%
			group_by(FES)	%>%
			summarise(count	=	n())		%>%
			mutate(Percent	=	count/fesnumbers$count*100)
			
ggplot(medianper, aes(x= Types , y=medianper$Percent, fill= Types)) +                        
       geom_bar(stat="identity") + scale_fill_hue(l=80) +
       ylab("Percent %") + 
       xlab("Employment Status") + ggtitle("Percentages of different Employment Status")+
       theme(axis.text.x = element_text(angle = 10, hjust = 0.5),
       panel.background = element_rect(fill = 'white' ))

stateCodeCSV = "ST,region
001,alabama
002,alaska
004,arizona
005,arkansas
006,california
008,colorado
009,connecticut
010,delaware
011,district of columbia
012,florida
013,georgia
015,hawaii
016,idaho
017,illinois
018,indiana
019,iowa
020,kansas
021,kentucky
022,louisiana
023,maine
024,maryland
025,massachusetts
026,michigan
027,minnesota
028,mississippi
029,missouri
030,montana
031,nebraska
032,nevada
033,new hampshire
034,new jersey
035,new mexico
036,new york
037,north carolina
038,north dakota
039,ohio
040,oklahoma
041,oregon
042,pennsylvania
044,rhode island
045,south carolina
046,south dakota
047,tennessee
048,texas
049,utah
050,vermont
051,virginia
053,washington
054,west virginia
055,wisconsin
056,wyoming"
stateCodes <- fread(stateCodeCSV)



stateCodes <- fread(stateCodeCSV)     


#Total number of married family with both people in the labor force.

stateTotalBoth <- ds	%>%
				  filter(FES==4)		%>%
				  group_by(ST)	%>%
				  summarise(count=n())
				  

medianBoth <- ds	%>%
				filter(FES==4,FINCP>= 121200)	%>%
				group_by(ST)		%>%
				summarise(count=n())
								  
medianBoth <- right_join(medianBoth,stateCodes,by.x=c("ST"))
medianBoth[is.na(medianBoth)] <- 0
medianBoth <- mutate(medianBoth,value=medianBoth$count/stateTotalBoth$count*100)

state_choropleth(medianBoth,title="Percentage of Neither People in labor earning more than 121200",num_colors=3	)

