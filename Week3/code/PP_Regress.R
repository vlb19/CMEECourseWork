#!/usr/bin/env Rscript

rm(list = ls())

# Packages
library(lattice)
require(ggplot2)

# Read in data
PPData <- as.data.frame(read.csv("../data/EcolArchives-E089-51-D1.csv"))

#View data
View(PPData)

# Open new file to plot graph into 
pdf("../results/PP_Regress_Results.pdf")

# Plot graphs of log prey mass against log predator mass subset by feeding interaction with different coloured lines for different predator life stages
qplot(x= log(Prey.mass), y = log(Predator.mass), facets = Type.of.feeding.interaction ~., data = PPData, 
      colour = Predator.lifestage, shape = I(3)) + geom_smooth(method = "lm",fullrange = TRUE)

# Close graph and save file
dev.off()

# Running linear models for each graph within the plot 
#LinearModelResults <- c()
#M1 = as.data.frame(matrix(nrow=1, ncol=7))
#for (lifestage in unique(PPData$Predator.lifestage)){
 # for (FeedingInteraction in unique(PPData$Type.of.feeding.interaction)){
  #  Datasubset = subset(PPData, PPData$Predator.lifestage == lifestage)
  #  Datasubset = subset(Datasubset, PPData$Predator.Type.of.feeding.interaction == FeedingInteraction)
   # M1 <- lm(Predator.mass ~ Prey.mass, Datasubset)
  #  LinearModelResults <- cbind(lifestage, FeedingInteraction)
   # if(dim(Datasubset)[1] > 0)
    #View(M1)
    #  }
    #}

View(LinearModelResults)
