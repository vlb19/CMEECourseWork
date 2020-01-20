#!/usr/bin/env Rscript
rm(list=ls()) #Clear global environment
#Set working directory
#setwd("CMEECourseWork/MiniProject/code")

## Required packages
require("minpack.lm")

###############################################
### Load in data ### 
###############################################

#Load in modified data
data <- read.csv('../data/FunResData.csv')
# Visualise data as a reminder
head(data)

###############################################
### Run NLLS on single ID ###
###############################################

# Make a subset of the data for one ID as a test
Data2Fit <- subset(data, ID == 39982) #One curve

# Plot data points on scatter plot to visualise data
plot(Data2Fit$ResDensity, Data2Fit$N_TraitValue, xlab = "Resource Density", ylab = "Consumer Biomass Consumption Rate")

# Get dimensions of curve
dim(Data2Fit) 

###############################################
### Holling type II functional response
###############################################

#Transform the Holling type II fuctional response into a function
  # x = resource density
  # h = handling time 
  # a = search rate 
powMod <- function(a, h, x) {
  return( (a*x ) / (1+ (h*a*x)))
}

#This is basically cutting the last points of the graph off
# Because a needs to fit to just the slope
h <- max(Data2Fit$N_TraitValue)
a.line <- subset(Data2Fit, N_TraitValue < h)
plot(a.line$ResDensity, a.line$N_TraitValue)
#plot slope/ linear regressopn of cut slope
lm <- summary(lm(N_TraitValue ~ ResDensity, a.line))

# Extracts slope value
a <- lm$coefficients[2]
# h parameter is the maximum of the slope so you take the biggest value
#Not sure this is the best way?
h <- max(Data2Fit$N_TraitValue)

# This was based on the example but values substituted
PowFit <- nlsLM(N_TraitValue ~ powMod(ResDensity, a, h), data = Data2Fit, start = list(a=a, h=h))# optimising a and h values
Lengths <- seq(min(Data2Fit$ResDensity),max(Data2Fit$ResDensity))
coef(PowFit)["a"]
coef(PowFit)["h"]#Apply function on length

Predic2PlotPow <- powMod(Lengths,coef(PowFit)["a"],coef(PowFit)["h"])
plot(Data2Fit$ResDensity, Data2Fit$N_TraitValue)
lines(Lengths, Predic2PlotPow, col = 'blue', lwd = 2.5)# Phenomenological quadratic model

QuaFit <- lm(N_TraitValue ~ poly(ResDensity,2), data = Data2Fit)
Predic2PlotQua <- predict.lm(QuaFit, data.frame(ResDensity = Lengths))
plot(Data2Fit$ResDensity, Data2Fit$N_TraitValue)
lines(Lengths, Predic2PlotPow, col = 'blue', lwd = 2.5)
lines(Lengths, Predic2PlotQua, col = 'red', lwd = 2.5)

AIC(PowFit) - AIC(QuaFit)
#Generalised functional response model
GenMod <- function(x, a, h, q) {return( (a*x^q+1 ) / (1+ (h*a*x^q+1)))}

q = 0.25

GenFit <- nlsLM(N_TraitValue ~ GenMod(ResDensity, a, h, q), data = Data2Fit, start = list(a=a, h=h, q=q))
Predic2PlotPow <- GenMod(Lengths,coef(GenFit)["a"],coef(GenFit)["h"], coef(GenFit)["q"])
plot(Data2Fit$ResDensity, Data2Fit$N_TraitValue)
lines(Lengths, Predic2PlotPow, col = 'red', lwd = 2.5)