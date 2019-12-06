#!/usr/bin/env Rscript

# Computes the correlation coefficients between successive years in KeyWest Data

rm(list=ls()) # clears the workspace

load("../data/KeyWestAnnualMeanTemperature.RData") #load in data
ls()
library("ggplot2") 


Year <- ats$Year 
Temp <- ats$Temp
#plot graph of temperature over time 
ggplot(ats, aes(x = Year, y = Temp)) + theme(axis.text.x = element_text(face = "bold", size = 12), axis.text.y = element_text(face = "bold", size =12)) + geom_point(size=2, shape=23) 


### make new variable for successive years with list of temperatures from original table
ats$sucyear <- ats$Temp 
# create new function to shift column up by one
shift1 <- function(x, n) `length<-`(tail(x, -n), length(x)) 
# create new column with successive year shifted up by one
ats<-transform(ats,sucyear = shift1(sucyear, 1))
# cut the final row off the new table
ats1 <- ats[-nrow(ats),] 


### run a pearson correlation on the original temperatures + successive year
ogcorrelation <- cor(ats1$Temp,ats1$sucyear,method = "pearson")
correlations <- vector() # create a new empty vector
replicates = 10000 #set replicate number 


### Randomly select temperature data and make consecutive year data then run a pearsons correlation and store the Pearson's r to a new variable. Do this a number of times equal to the replicates
for (i in 1:replicates){ 
  randomtemps <- data.frame(matrix(nrow=100, ncol=2)) #create empty data frame for random temperatures
  randomtemps$X1 <- sample(ats$Temp) # add temperatures in a random order from original table
  randomtemps$X2 <- randomtemps$X1 # copy the column to a new column
  randomtemps <- transform(randomtemps,X2 = shift1(X2, 1)) #shift the new column up by one
  randomtemps <- randomtemps[-nrow(randomtemps),] # remove last row from the new table 
  correlations <- append(correlations, cor(randomtemps$X1,randomtemps$X2,method = "pearson")) # run a pearson correlation and save Pearson's r to a correlation variable 
} 


# count number of Pearson's r that are above the original correlation value
count = 0
for (x in correlations) { 
  if (x > ogcorrelation) { 
    count = count+1
  }
}


### Plot all the Pearson's rs 
  plot(correlations) + 
    points(ogcorrelation, col = "red") #highlight the original correlation value as a red point


### calculate the fraction of randomised correlation values that are above the original table's value
fraction <- count/replicates 
print(fraction)
