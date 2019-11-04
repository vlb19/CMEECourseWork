library(lattice)
require(ggplot2)

PPData <- as.data.frame(read.csv("../data/EcolArchives-E089-51-D1.csv"))

View(PPData)

p <- ggplot(PPData, aes(x = log(Predator.mass),
                      y = log(Prey.mass),
                      colour = Type.of.feeding.interaction))


pdf("../results/PP_Regress_Results.pdf")
qplot(x= log(Prey.mass), y = log(Predator.mass), facets = Type.of.feeding.interaction ~., data = PPData, 
      colour = Predator.lifestage, shape = I(3)) + geom_smooth(method = "lm",fullrange = TRUE)
dev.off()

