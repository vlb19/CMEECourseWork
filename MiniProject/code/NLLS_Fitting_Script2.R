#!/usr/bin/env Rscript

rm(list=ls()) #Clear global environment

#Set working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

###############################################
### Import Packages ###
###############################################

# For Levenberg-Marquardt nlls fitting
require("minpack.lm") 

# For data wrangling
library("dplyr") 
library("tidyr")

###############################################
### Write models as functions ###
###############################################

### Mechanistic Holling Type II model
HollingII <- function(a, h, x) {
  return( (a * x) / (1 + (h*a*x)))
}   # x = resource density
    # h = handling time 
    # a = search rate 

### Generalised functional response model
GenMod <- function(x, a, h, q) {
  return((a*x^(q+1)) / (1 + (h*a*x^(q+1))))
  } # x = resource density
    # h = handling time 
    # a = search rate 
    # q is a shape paramater that allows the shape 
    # of the response to be more flexible/variable

###############################################
### Write NLLS as functions ###
###############################################

### Phenomenological quadratic model
QuaFit <- function(data) {lm(N_TraitValue ~ poly(ResDensity,2), data = data)}

### Cubic polynomial model 
CubFit <- function(data) {lm(N_TraitValue ~ poly(ResDensity,3), data = data)}

### Holling II model
HolFit <- function(data, a, h) {nlsLM(N_TraitValue ~ HollingII(ResDensity, a, h), data = data, start = list(a=a, h=h))}

### Generalised Holling model
# Set a value for q
q = 0.25
GenFit <- function(data, a, h, q) {nlsLM(N_TraitValue ~ GenMod(ResDensity, a, h, q), data = data, start = list(a=a, h=h))}


###############################################
### Get starting values for h and a ###
###############################################

StartingValues <- function(data2fit) {
  
  ### Store the peak handling time in a variable (h)
  # Create empty variable 
  h <- list()
  # Store maximum y value
  h <- max(data2fit$N_TraitValue)
  
  ### Remove points after this value in order to fit models to the growth period
  # Store x value for corresponding peak y value
  removeddata <- data2fit$ResDensity[which.max(data2fit$N_TraitValue)]
  
  # Subset the data to contain only x values lower than this point
  CurveData <- subset(data2fit, ResDensity < removeddata)
  
  ### Calculate the linear regression of the cut slope
  lm <- summary(lm(N_TraitValue ~ ResDensity, CurveData))
  
  ### Store the search rate
  # Create empty variable 
  a <- list()
  # Store the value for the gradient
  a <- lm$coefficients[2]
  
  ### Store a and h values
  ah <- c(a, h)
  return(ah)
}


###############################################
### Load in data ### 
###############################################

#Load in modified data
data <- read.csv('../data/FunResData.csv')

# Remove additional X column added in the transformation
data <- data[,-1]

# Nest data by ID
NestedData <- data %>% nest(data = -ID)

###############################################
### Obtain Starting Values ###
###############################################

# Create new data frame to store values
StartValueTable <- data.frame("ID" = NestedData$ID, "a_value" = rep(NA, length(NestedData$ID)), "h_value"= rep(NA, length(NestedData$ID)))

# For each ID obtain starting values and store in data frame
for (id in 1: length(NestedData[[1]])){
  avalue = StartingValues(NestedData$data[[id]])[1]
  if (is.nan(avalue)){}
  else {
    StartValueTable[id, "a_value"] <- StartingValues(NestedData$data[[id]])[1]
    StartValueTable[id, "h_value"] <- StartingValues(NestedData$data[[id]])[2]
  }
}

# Remove IDs where a could not be calculated from start value table
is.na(StartValueTable)
StartValueTable <- na.omit(StartValueTable)

# Remove IDs with no a value from data frame
#compare start value table id
#remove unique values from nested data

###############################################
### Run NLLS Fitting ###
###############################################

# Create new data frame to store values
FitValues <- data.frame("Model" = c("QuaFit", "CubFit", "HolFit", "GenFit"), "AIC" = rep(NA,4), "BIC" =rep(NA,4), stringsAsFactors = FALSE)

ModelFits <- data.frame("ID" = StartValueTable[1], "a_value" = StartValueTable[2], "h_value" = StartValueTable[3], "Best_Model" = rep(NA, length(StartValueTable[1])), "AIC"= rep(NA, length(StartValueTable[1])), "BIC" = rep(NA, length(StartValueTable[1])))

# Create counter to run through with 
counter = 0

# Run models for each ID
for (id in StartValueTable[, 1]){
  counter = counter+1
  a <- StartValueTable[counter,2]
  h <- StartValueTable[counter, 3]
  q = 0.25
  FinalQuaFit <- try(QuaFit(NestedData$data[[counter]]), silent = T)
  FinalCubFit <- try(CubFit(NestedData$data[[counter]]), silent = T)
  FinalHolFit <- try(HolFit(NestedData$data[[counter]], a, h), silent = T)
  FinalGenFit <- try(GenFitAIC(NestedData$data[[counter]], a, h, q), silent = T)
  
  FitValues[1, 2] <- ifelse(class(FinalQuaFit) == "try-error", rep(NA,1), AIC(FinalQuaFit))
  FitValues[1, 3] <- ifelse(class(FinalQuaFit) == "try-error", rep(NA,1), BIC(FinalQuaFit))
  
  FitValues[2, 2] <- ifelse(class(FinalCubFit) == "try-error", rep(NA,1), AIC(FinalCubFit))
  FitValues[2, 3] <- ifelse(class(FinalCubFit) == "try-error", rep(NA,1), BIC(FinalCubFit))
  
  FitValues[3, 2] <- ifelse(class(FinalHolFit) == "try-error", rep(NA,1), AIC(FinalHolFit))
  FitValues[3, 3] <- ifelse(class(FinalHolFit) == "try-error", rep(NA,1), BIC(FinalHolFit))
  
  FitValues[4, 2] <- ifelse(class(FinalGenFit) == "try-error", rep(NA,1), AIC(FinalGenFit))
  FitValues[4, 3] <- ifelse(class(FinalGenFit) == "try-error", rep(NA,1), BIC(FinalGenFit))
  
  # Store the smallest value for AIC or BIC as a variable
  MinimumAICorBIC <- min(FitValues[2:3], na.rm = TRUE)

  
  tryCatch( ModelFits[counter, 4:6] <- FitValues[which(FitValues[2:3] == MinimumAICorBIC),],
            warning=function(c) print(paste("warning on id", ModelFits[counter, 1]))
  ) 
  
  # Copy th
  ModelFits[id, 4:6] <- FitValues[which(FitValues[2:3] == MinimumAICorBIC),]
  }



###############################################
### Calculate statistical measures of the models ###
###############################################


###################################################
### Plot fitted models
###################################################
# Generate a vector of resource densities for plotting
ResDensities <- seq(min(data$ResDensity), max(data$ResDensity), len = 200)

# Plot data points  
plot(data$ResDensity, data$N_TraitValue, xlab = "Resource Density", ylab = "Consumption rate (units of mass/time)")

## Calculate the predicted lines using coefficients extracted from the model fit

# Quadratic model 
Predic2PlotQua <- predict.lm(QuaFit, data.frame(ResDensity = ResDensities ))

# Cubic model
Predic2PlotCub <- predict.lm(CubFit, data.frame(ResDensity = ResDensities ))

# Holling II model 
Predic2PlotHolling <- HollingII(ResDensities, coef(HolFit)["a"], coef(HolFit)["h"])

# Generalised model
Predic2PlotGen <- GenMod(ResDensities, coef(GenFit)["a"], coef(GenFit)["h"],q)

## Plot the lines
## Fit Quadratic model line 
lines(ResDensities, Predic2PlotQua, col = 'red', lwd = 2.5)

## Fit Cubic model line
lines(ResDensities, Predic2PlotCub, col = 'blue', lwd = 2.5)

## Plot the data and the fitted Holling II model line
lines(ResDensities, Predic2PlotHolling, col = "green", lwd = 2.5)

## Fit General model line
lines(ResDensities, Predic2PlotGen, col = 'magenta', lwd = 2.5)

## Add legend to graph
legend("topleft", legend = c("Quadratic model", "Cubic Model", "Holling II", "General model"), lty = 1, col = c("red", "blue", "green", "pink"))
#text(300, 0.025, labels = LineEquation )

## Add equation of line to graph
LineEquation = paste("Consumption Rate = ", coef(HolFit)["a"], 'x Resource Density ^', coef(HolFit["h"]))
# Generate a vector of resource densities for plotting
ResDensities <- seq(min(data$ResDensity), max(data$ResDensity), len = 200)

  ## Calculate confidence intervals on the estimated parameters
  
  preds <- predict(QuaFit, newdata = data.frame(ResDensity = ResDensities), 
                   interval = 'confidence')
  polygon(c(rev(ResDensities), ResDensities), c(rev(preds[ ,3]), preds[ ,2]), col = 'grey80', border = NA)
  
  


###############################################
### Optimise values for a and h ###
###############################################

# Generate random numbers following normal distribution around "a"
avalues <- sort(rnorm(10, a, sd=1))

# Generate random numbers following normal distribution around "h"
hvalues <- sort(rnorm(10, h, sd=1))

