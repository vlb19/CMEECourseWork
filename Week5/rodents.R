## Desc: working in groups, looking at the rodents.csv data.  I look at whether there is any sampling bias due to rain in the data set.
## House keeping ##
rm(list = ls())


##packages###
require(ggplot2)
#require(dplyr)
require(plyr)
###Main###

d <- read.csv("rodents.csv")

length(unique(d$species))
DF <- data.frame(matrix(NA, nrow = length(unique(d$yr)), ncol = length(unique(d$species))))
rownames(DF) <- unique(d$yr)
colnames(DF) <- unique(d$species)

for (i in unique(d$yr)){
    year <- subset(d, d$yr == i)
    speciesCount <- (count(year$species))
    for (s in 1:nrow(speciesCount)){
        
        species <- as.character(speciesCount[s,1])
        print(species)
        countAbund <- speciesCount[s,2]
        DF[as.character(i),species] <- countAbund
            
            
    }    
    
}