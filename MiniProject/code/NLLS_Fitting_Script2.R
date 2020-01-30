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
### Load in modified data ### 
###############################################

#Load in modified data
data <- read.csv('../data/FunResData.csv')

# Remove additional X column added in the transformation
data <- data[,-1]

# Nest data by ID
NestedData <- data %>% nest(data = -ID)

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
GenFit <- function(data, a, h, q) {nlsLM(N_TraitValue ~ GenMod(ResDensity, a, h, q), data = data, start = list(a=a, h=h))}


###############################################
### Get starting values for h and a ###
###############################################

StartingValues <- function(data2fit) {
  
  ### Store the peak handling time in a variable (h)
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
  # Store the value for the gradient
  a <- lm$coefficients[2]
  
  ### Store a and h values
  ah <- c(a, h)
  return(ah)
}


###############################################
### Obtain Starting Values ###
###############################################

# Create new data frame to store values
StartValueTable <- data.frame("ID" = NestedData$ID, 
                              "a_value" = rep(NA, length(NestedData$ID)), 
                              "h_value"= rep(NA, length(NestedData$ID)))

# For each ID obtain starting values and store in data frame
for (id in 1: length(NestedData[[1]])){
    StartValueTable[id, "a_value"] <- StartingValues(NestedData$data[[id]])[1]
    StartValueTable[id, "h_value"] <- StartingValues(NestedData$data[[id]])[2]
}

# Remove IDs where a could not be calculated from start value table
#StartValueTable <- na.omit(StartValueTable)


####################################################
### Run NLLS Fitting and measure goodness of fit ###
####################################################

# Create new data frame to store AIC and BIC values for each model
FitValues <- data.frame("Model" = c("QuaFit", "CubFit", "HolFit", "GenFit"), 
                        "AIC" = rep(NA,4), 
                        "BIC" =rep(NA,4), 
                        stringsAsFactors = FALSE)

# Create a new data frame to store best models, starting values
# and model fits for each ID
ModelFits <- data.frame("ID" = StartValueTable[1], 
                        "a_value" = StartValueTable[2], 
                        "h_value" = StartValueTable[3], 
                        "Best_Model" = rep(NA, length(StartValueTable[1])), 
                        "AIC"= rep(NA, length(StartValueTable[1])), 
                        "BIC" = rep(NA, length(StartValueTable[1])), 
                        stringsAsFactors = FALSE)

# Run models for each ID
for (i in 1:length(StartValueTable[, 1])){
  
  # Generate starting values for the Holling models
  a <- StartValueTable[i,2]
  h <- StartValueTable[i, 3]
  q = -1
  
  # Subset the data for a single ID
  datatry <- NestedData$data[[i]]
  
  ### Fit models 
  # Phenomenological quadratic model
  QuaFit <- try(lm(N_TraitValue  ~ poly(ResDensity,2), 
                  data = datatry), silent = T)
  
  # Cubic polynomial model 
  CubFit <- try(lm(N_TraitValue ~ poly(ResDensity,3), 
                   data = datatry), silent = T)
  
  # Holling II model
  HolFit <- try(nlsLM(N_TraitValue ~ HollingII(ResDensity, a, h), 
                  data = datatry, start = list(a=a, h=h)), 
                  silent = T)

  # Generalised Holling model
  GenFit <- try(nlsLM(N_TraitValue ~ GenMod(ResDensity, a, h, q), 
                  data = datatry, start = list(a=a, h=h)), 
                  silent = T)

  ### Store AICs into a table for each model
  
    # Phenomenological quadratic model
      FitValues[1, 2] <- ifelse(class(QuaFit) == "try-error", rep(NA,1), AIC(QuaFit))
    # Cubic polynomial model 
      FitValues[2, 2] <- ifelse(class(CubFit) == "try-error", rep(NA,1), AIC(CubFit))
    # Holling II model
      FitValues[3, 2] <- ifelse(class(HolFit) == "try-error", rep(NA,1), AIC(HolFit))
    # Generalised Holling model
      FitValues[4, 2] <- ifelse(class(GenFit) == "try-error", rep(NA,1), AIC(GenFit))
      
      
  # Store the smallest value for AIC as a variable
  MinimumAIC <- min(FitValues[2], na.rm = TRUE)
  
  
  ### Store BICs into a table for each model
      
    # Phenomenological quadratic model
      FitValues[1, 3] <- ifelse(class(QuaFit) == "try-error", rep(NA,1), BIC(QuaFit))
    # Cubic polynomial model 
      FitValues[2, 3] <- ifelse(class(CubFit) == "try-error", rep(NA,1), BIC(CubFit))
    # Holling II model
      FitValues[3, 3] <- ifelse(class(HolFit) == "try-error", rep(NA,1), BIC(HolFit))
    # Generalised Holling model
      FitValues[4, 3] <- ifelse(class(GenFit) == "try-error", rep(NA,1), BIC(GenFit))
  
  # Store the smallest value for BIC as a variable
  MinimumAIC <- min(FitValues[3], na.rm = TRUE)
  
  # 
  tryCatch( ModelFits[i, 4:6] <- FitValues[which(FitValues[2:3] == MinimumAICorBIC),],
            warning=function(c) print(paste("warning on id", ModelFits[i, 1]))
  ) 
  
}

 
  # Copy th
  #ModelFits[id, 4:6] <- FitValues[which(FitValues[2:3] == MinimumAICorBIC),] 
 # ad <- c(ID, AIC, BIC, MODEL , kdjs)
#  nameofdataframe <- rbind(nameofdataframe, ad)

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

