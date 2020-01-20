#!/usr/bin/env Rscript
rm(list=ls()) #Clear global environment
#Set working directory
#setwd("CMEECourseWork/MiniProject/code")

###############################################
### Import Packages ###
###############################################

require("minpack.lm") # for Levenberg-Marquardt nlls fitting

###############################################
### Write models as functions ###
###############################################

### Power law model 
powMod <- function(x, a, b){
  return(a * x^b)
}

### Phenomenological quadratic model 


### Cubic polynomial model 


### Mechanistic Holling Type II model
HollingII <- function(a, h, x) {
  return( (a*x ) / (1+ (h*a*x)))
}   # x = resource density
    # h = handling time 
    # a = search rate 

### Generalised functional response model
GenMod <- function(x, a, h, q) {
  return( (a*x^q+1 ) / (1+ (h*a*x^q+1)))
  } # x = resource density
    # h = handling time 
    # a = search rate 
    # q is a shape paramater that allows the shape 
    # of the response to be more flexible/variable


###############################################
### Load in data ### 
###############################################

#Load in modified data
data <- read.csv('../data/FunResData.csv')


###############################################
### Run NLLS on single ID ###
###############################################
""" Test script
# Make a subset of the data for one ID as a test
data2fit <- subset(data, ID == 39982) #One curve

# Plot data points on scatter plot to visualise data
plot(data$ResDensity, data$N_TraitValue, xlab = "Resource Density", ylab = "Consumption rate (units of mass/time)")

# Get dimensions of curve
dim(data2fit) 
""" 

###############################################
### Get starting values for h and a ###
###############################################

StartingValues <- function(data2fit) {
### Identify the peak of the curve (This is equal to the peak handling time)
  abline(v=data2fit$ResDensity[which.max(data2fit$N_TraitValue)], col="red")
  
### Store the peak handling time in a variable (h)
  h <- max(data2fit$N_TraitValue)

### Remove points after this value in order to fit models to the growth period
  # Store x value for corresponding peak y value
  removeddata = data2fit$ResDensity[which.max(data2fit$N_TraitValue)]
  
  # Subset the data to contain only x values lower than this point
  CurveData <- subset(data2fit, ResDensity < removeddata)
  
"""
  # Plot the subsetted data 
  plot(CurveData$ResDensity, CurveData$N_TraitValue, xlab = "Resource Density", ylab = "Consumption rate (units of mass/time)")
""" 

### Calculate the linear regression of the cut slope
lm <- summary(lm(N_TraitValue ~ ResDensity, CurveData))

### Extract the value for the gradient, which is equal to the search rate
a <- lm$coefficients[2]
}
###############################################
### Run NLLS Fitting ###
###############################################

### Fit the power law model to the uncropped data using NLLS
PowFit <- nlsLM(N_TraitValue ~ powMod(ResDensity, a, h), data = data, start = list(a=a, h=h))

# View the power law model summary
summary(PowFit)

## Visualise the fit
  # Generate a vector of resource densities for plotting
  ResDensities <- seq(min(data$ResDensity), max(data$ResDensity), len = 200)
  
  ## Calculate the predicted line using coefficients extracted from the model fit
  Predic2PlotPow <- powMod(ResDensities, coef(PowFit)["a"], coef(PowFit)["h"])
  
  ## Plot the data and the fitted model line
  plot(data$ResDensity, data$N_TraitValue, xlab = "Resource Density", ylab = "Consumption rate (units of mass/time)")
  lines(ResDensities, Predic2PlotPow, col = "blue", lwd = 2.5)
  
  ## Add equation of line to graph
  LineEquation = paste("Consumption Rate = ", coef(PowFit)["a"], 'x Resource Density ^', coef(PowFit["h"]))
  text(300, 0.025, labels = LineEquation )

  ## Calculate confidence intervals on the estimated parameters
  confint(PowFit)
  
  
  
  
### Phenomenological quadratic model

QuaFit <- lm(N_TraitValue ~ poly(ResDensity,2), data = data)
Predic2PlotQua <- predict.lm(QuaFit, data.frame(ResDensity = Lengths))
plot(data$ResDensity, data$N_TraitValue)
lines(Lengths, Predic2PlotPow, col = 'blue', lwd = 2.5)
lines(Lengths, Predic2PlotQua, col = 'red', lwd = 2.5)

###############################################
### Calculate statistical measures of the models ###
###############################################

# Subtract AICs 
AIC(PowFit) - AIC(QuaFit)

# Generalised functional response model
GenMod <- function(x, a, h, q) {return( (a*x^q+1 ) / (1+ (h*a*x^q+1)))}

# Set a value for q
q = 0.25

# Fit Generalised Holling Model to the data
GenFit <- nlsLM(N_TraitValue ~ GenMod(ResDensity, a, h, q), data = data, start = list(a=a, h=h, q=q))

# Plot Generalised Holling Model to the data
Predic2PlotPow <- GenMod(Lengths,coef(GenFit)["a"],coef(GenFit)["h"], coef(GenFit)["q"])
plot(data$ResDensity, data$N_TraitValue)
lines(Lengths, Predic2PlotPow, col = 'green', lwd = 2.5)

###############################################
### Optimise values for a and h ###
###############################################

# Generate random numbers following normal distribution around "a"
avalues <- sort(rnorm(10,a,sd=1))

# Generate random numbers following normal distribution around "h"
hvalues <- sort(rnorm(10, h, sd=1))

