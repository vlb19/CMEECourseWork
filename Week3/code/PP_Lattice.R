#!/usr/bin/env Rscript

library(lattice)
require(ggplot2)
PPData <- as.data.frame(read.csv("../data/EcolArchives-E089-51-D1.csv"))

pdf("../results/Pred_Lattice.pdf")
densityplot(~log(Predator.mass) | Type.of.feeding.interaction, data = PPData)
dev.off()

pdf("../results/Prey_Lattice.pdf")
densityplot(~log(Prey.mass) | Type.of.feeding.interaction, data = PPData)
dev.off()

pdf("../results/SizeRatio.pdf")
densityplot(~log(Prey.mass/Predator.mass) |Type.of.feeding.interaction, data = PPData)
dev.off()



PredatorPreyMean <- log(tapply(X = PPData$Predator.mass, INDEX = PPData$Type.of.feeding.interaction, FUN = mean))
PredatorPreyMedian <- log(tapply(X = PPData$Predator.mass, INDEX = PPData$Type.of.feeding.interaction, FUN = median))
PredatorPreyAverages <- 
write.csv(PredatorPreyMean, "../results/PP_Results.csv")
