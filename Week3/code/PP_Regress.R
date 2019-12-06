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

