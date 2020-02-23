#!/usr/bin/env Rscript

# Author: Victoria Blanchard vlb19@ic.ac.uk
# Script: NLLS_Fitting_Script.R
# Desc: Fit different NLLS models to functional response data
# Input: 'FunResData.csv'
# Output: csv file with best model fits for each ID
# Arguments: 0
# Date: January 2020

##############################################
### Prepare R environment ###
##############################################

#Clear global environment
rm(list=ls()) 

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

data2nest <- data[1:3]

# Nest data by ID
NestedData <- data2nest %>% nest(data = -ID)



###############################################
### Save covariates in separate table by ID ###
###############################################

Covariates <- data[!duplicated(data$ID),]

###############################################
### Write models as functions ###
###############################################

# xr = resource density
# h = handling time 
# a = search rate 
# q is a shape paramater that allows the shape 
# of the response to be more flexible/variable

### Mechanistic Holling Type II model
HollingII <- function(xr, a, h) {
  return( (a * xr) / (1 + (h * a * xr)) )
} 

### Generalised functional response model
GenMod <- function(xr, a, h, q) {
  return( (a * xr ^ (q+1)) / (1 + (h * a * xr ^ (q+1))) )
} 

###############################################
### Get starting values for h and a ###
###############################################

StartingValues <- function(data2fit) {
  
  ### Store the peak handling time in a variable (h)
  # Store maximum y value
  h <- max(data2fit$N_TraitValue)
  
  ### Remove points after this value in order to fit models to the growth period
  # Find mean y value
  meanTraitValue <- mean(data2fit$N_TraitValue)
  # Find max y value
  maxTraitValue <- max(data2fit$N_TraitValue)
  
  # Subset the data to contain only x values lower than these point
  DataBelowMean <- subset(data2fit, N_TraitValue < meanTraitValue)
  DataBelowMax <- subset(data2fit, N_TraitValue < maxTraitValue)
  
  ### Calculate the linear regression of the cut slopes 
  lmMean <- summary(lm(N_TraitValue ~ ResDensity, DataBelowMean))
  lmMax <- summary(lm(N_TraitValue ~ ResDensity, DataBelowMax))
  
  
  ### Store the search rate
  # Store the best value for the gradient
  if (lmMean$r.squared >= lmMax$r.squared){
    a <- lmMean$coefficients[2]
  } else {a <- lmMax$coefficients[2]}
  
  ### Store a and h values in a list to return 
  ah <- c(a, h)
  
  ### Return the a and h values
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
for (id in 1:nrow(NestedData)){
  StartValueTable[id, "a_value"] <- StartingValues(NestedData$data[[id]])[1]
  StartValueTable[id, "h_value"] <- StartingValues(NestedData$data[[id]])[2]
}


####################################################
### Run NLLS Fitting ###
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
                        "Best_AIC_Model" = rep(NA, nrow(StartValueTable[1])), 
                        "AIC"= rep(NA, nrow(StartValueTable[1])), 
                        "Best_BIC_Model" = rep(NA, nrow(StartValueTable[1])), 
                        "BIC" = rep(NA, nrow(StartValueTable[1])), 
                        stringsAsFactors = FALSE)

# Merge the nested data with the start value table by matching IDs 
NestedData <- merge(NestedData, StartValueTable, by = "ID")

# Suppress the warnings for the very bad fits 
suppressWarnings(
  
### Run each model on every ID                        
for (i in 1:length(StartValueTable[, 1])){
  
  # Generate starting values for the Holling models
  a <- StartValueTable[i,2]
  h <- StartValueTable[i, 3]
  q = 0.78 # from the literature
  
  # Subset data for a particular ID
  datatry <- NestedData$data[[i]]
  
  ### Fit models 
  # Phenomenological quadratic model
  QuaFit <- try(lm(N_TraitValue  ~ poly(ResDensity,2), 
                   data = datatry), silent=T)
  
  # Cubic polynomial model 
  CubFit <- try(lm(N_TraitValue ~ poly(ResDensity,3), 
                   data = datatry), silent=T)
  
  # Holling II model
  HolFit <- try(nlsLM(N_TraitValue ~ HollingII(datatry$ResDensity, a, h), 
                      data = datatry, start = list(a=a, h=h)), silent=T)
  
  # Generalised Holling model
  GenFit <- try(nlsLM(N_TraitValue ~ GenMod(datatry$ResDensity, a, h, q), 
                data = datatry, start = list(a=a, h=h)), silent=T)
  
  
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
  MinimumBIC <- min(FitValues[3], na.rm = TRUE)
  
  # Store the model with the best AIC in the final table 
  ModelFits[i, 4:5] <- FitValues[which(FitValues[2] == MinimumAIC),1:2]
  
  # Store the model with the best BIC in the final table
  ModelFits[i, 6:7] <- FitValues[which(FitValues[3] == MinimumBIC),c(1,3)]
}
)

##########################################
### Optimise Starting Values ###
##########################################

iters = 10
maxiters = 21

OptStartValueTable <- data.frame("ID" = NestedData$ID, 
                                 "a_value" = rep(NA), 
                                 "h_value"= rep(NA))

suppressWarnings(
for (i in 1:length(OptStartValueTable$ID)){
  
  # Subset data for a single ID
  data2fit <- NestedData[i,]
  
  # Retrieve initial start value estimates 
  a = data2fit[,3]
  h = data2fit[,4]
  
  # Save data for particular ID into a variable
  data2try <- data2fit$data[[1]]
  
  
  
  # Generate a potential starting values from initial estimates
  avalues <- c(a, rnorm(iters, a, 10), runif(iters, min = -1, max = 1))
  hvalues <- c(h, rnorm(iters, h, 10), runif(iters, min = -1, max = 1))
  
  # Initialise empty data frame to store potential starting values
  TestOptimum <- data.frame("avalues" = rep(NA), 
                            "hvalues" = rep(NA), 
                            "AIC" = rep(NA))
  
  # Sample initial start parameters to find best starting values
  for (k in 1:(maxiters)){
    GenStarta <- avalues[k]
    GenStarth <- sample(hvalues,1)
    
    # try to fit the general functional response model to every
    # starting value in the list 
    
    GenFit <- try(nlsLM(N_TraitValue ~ GenMod(data2try$ResDensity, a, h, q), 
                                         data = data2try, start = list(a = GenStarta, h = GenStarth)), silent = T)
    
    
    # add test values to table
    TestOptimum[k,1:3] <- c(GenStarta, GenStarth, ifelse(class(GenFit) == "try-error", rep(NA,1), AIC(GenFit)))
  }
  
  # Find the minimum AIC for the table
  minAIC <- min(TestOptimum[,3], na.rm = T)
  
  # Append a and h values to the table of optimised starting values
  OptStartValueTable[i,1:3] <- c(data2fit$ID[1], TestOptimum[which(TestOptimum[3] == minAIC),1], TestOptimum[which(TestOptimum[3] == minAIC),2])
  #OptStartValues[i,] <- c(data2fit$ID[1], TestOptimum[which(TestOptimum[3] == minAIC),1], TestOptimum[which(TestOptimum[3] == minAIC),2])
  
}
)
#######################################################
### Re-run NLLS Fitting with optimised start values ###
#######################################################

MergedData <- merge(NestedData,Covariates, by = "ID")

modelvec2<-data.frame("ID "=rep(NA), 
                      "Habitat"=rep(NA),
                      "ResDimension"=rep(NA), 
                      "ConDimension"=rep(NA),
                      "Model"=rep(NA),
                      "AIC"=rep(NA),
                      "BIC"=rep(NA))

# Create a new data frame to store best models, starting values
# and model fits for each ID
OptModelFits <- data.frame("ID" = StartValueTable[1], 
                        "AIC_Qua_Model" = rep(NA), 
                        "AIC_Cub_Model"= rep(NA), 
                        "AIC_Hol_Model"= rep(NA),
                        "AIC_Gen_Model"= rep(NA),
                        stringsAsFactors = FALSE)
                        
OptFitsSummary <- data.frame("ID" = StartValueTable[1], 
                       "a_value" = StartValueTable[2], 
                       "h_value" = StartValueTable[3], 
                        "BestModelAIC" = rep(NA),
                        "BestAIC" = rep(NA),
                        "BestModelBIC" = rep(NA),
                        "BestBIC" = rep(NA),
                        stringsAsFactors = FALSE)


for (i in 1:length(OptStartValueTable[, 1])){
  # Optimise the starting values
  
  # Generate starting values for the Holling models
  a <- OptStartValueTable[i,2]
  h <- OptStartValueTable[i, 3]
  q = 0.78
  
  # Subset data for a particular ID
  datatry <- MergedData$data[[i]]

  #
  modelvec<-c("PowFit","QuaFit","GenFit", "CubFit")
  modelvec<-data.frame("ID "=rep(NA), 
                       "Habitat"=rep(NA),
                       "ResDimension"=rep(NA), 
                       "ConDimension"=rep(NA),
                       "Model"=modelvec,
                       "AIC"=rep(NA),
                       "BIC"=rep(NA))
  
  modelvec[1:4,1] <- OptStartValueTable[i,1]
  modelvec[1:4,2] <- MergedData$Habitat[[i]]
  modelvec[1:4,3] <- MergedData$Res_MovementDimensionality[[i]]
  modelvec[1:4,4] <- MergedData$Con_MovementDimensionality[[i]]
  
  ### Fit models 
  # Phenomenological quadratic model
  QuaFit <- try(lm(N_TraitValue  ~ poly(ResDensity,2), 
                   data = datatry), silent = T)
  
  # Cubic polynomial model 
  CubFit <- try(lm(N_TraitValue ~ poly(ResDensity,3), 
                   data = datatry), silent = T)
  
  # Holling II model
  HolFit <- try(nlsLM(N_TraitValue ~ HollingII(datatry$ResDensity, a, h), 
                      data = datatry, start = list(a=a, h=h)), 
                silent = T)
  
  # Generalised Holling model
  GenFit <- try(nlsLM(N_TraitValue ~ GenMod(datatry$ResDensity, a, h, q), 
                      data = datatry, start = list(a=a, h=h)), 
                silent = T)
  
  
  ### Store AICs into a table for each model
  # Phenomenological quadratic model
  OptModelFits[i, 2] <- ifelse(class(QuaFit) == "try-error", rep(NA,1), AIC(QuaFit))
  # Cubic polynomial model 
  OptModelFits[i, 3] <- ifelse(class(CubFit) == "try-error", rep(NA,1), AIC(CubFit))
  # Holling II model
  OptModelFits[i, 4] <- ifelse(class(HolFit) == "try-error", rep(NA,1), AIC(HolFit))
  # Generalised Holling model
  OptModelFits[i, 5] <- ifelse(class(GenFit) == "try-error", rep(NA,1), AIC(GenFit))
  
  
  # Phenomenological quadratic model
  modelvec[1, 6] <- ifelse(class(QuaFit) == "try-error", rep(NA,1), AIC(QuaFit))
  # Cubic polynomial model 
  modelvec[2, 6] <- ifelse(class(CubFit) == "try-error", rep(NA,1), AIC(CubFit))
  # Holling II model
  modelvec[3, 6] <- ifelse(class(HolFit) == "try-error", rep(NA,1), AIC(HolFit))
  # Generalised Holling model
  modelvec[4, 6] <- ifelse(class(GenFit) == "try-error", rep(NA,1), AIC(GenFit))
  
  
  modelvec[1, 7] <- ifelse(class(QuaFit) == "try-error", rep(NA,1), BIC(QuaFit))
  # Cubic polynomial model 
  modelvec[2, 7] <- ifelse(class(CubFit) == "try-error", rep(NA,1), BIC(CubFit))
  # Holling II model
  modelvec[3, 7] <- ifelse(class(HolFit) == "try-error", rep(NA,1), BIC(HolFit))
  # Generalised Holling model
  modelvec[4, 7] <- ifelse(class(GenFit) == "try-error", rep(NA,1), BIC(GenFit))
  
  modelvec2 <- bind_rows(modelvec2, modelvec)
  
  # Store the smallest value for AIC as a variable
  MinimumAIC <- min(modelvec[6], na.rm = TRUE)
  
  # Store the model with the best AIC in the summary table 
  OptFitsSummary[i,4:5] <- modelvec[which(modelvec[6] == MinimumAIC), 5:6]
  
  # Store the smallest value for BIC as a variable
  MinimumBIC <- min(modelvec[7], na.rm = TRUE)
  
  # Store the model with the best BIC in the final table
  OptFitsSummary[i, 6:7] <- modelvec[which(modelvec[7] == MinimumBIC),c(1,3)]
}

modelvec2 <- modelvec2[-1,]

##########################################
### Summarise different statistics ### 
##########################################

ModelFits %>% group_by(ModelFits$Best_AIC_Model) %>% summarise(count=n())

OptFitsSummary %>% group_by(OptFitsSummary$BestModelAIC) %>% summarise(count=n())

##########################################
### Plot the data ###
##########################################

# Make a subset of the data for one ID as a test
data2fit <- subset(NestedData, ID == 39982) #One curve
data2fit <- data2fit$data[[1]]
# Plot data points on scatter plot to visualise data
plot(data2fit$ResDensity, data2fit$N_TraitValue, xlab = "Resource Density", ylab = "Consumption rate (units of mass/time)")

# Generate a vector of resource densities for plotting
ResDensities <- seq(min(data$ResDensity), max(data$ResDensity), len = 200)

## Calculate the predicted line using coefficients extracted from the model fit
Predic2PlotHol <- HollingII(ResDensities, coef(HolFit)["a"], coef(HolFit)["h"])
Predic2PlotGen <- GenMod(ResDensities, coef(GenFit)["a"], coef(GenFit)["h"],q)

## Plot the data and the fitted model line
plot(data2fit$ResDensity, data2fit$N_TraitValue, xlab = "Resource Density", ylab = "Consumption rate (units of mass/time)")
lines(ResDensities, Predic2PlotHol, col = "blue", lwd = 2.5)
lines(ResDensities, Predic2PlotGen, col = "blue", lwd = 2.5)

Predic2PlotQua <- predict.lm(QuaFit, data.frame(ResDensity = Lengths))
lines(Lengths, Predic2PlotQua, col = 'red', lwd = 2.5)


###################################################
### Add in covariate data for analysis ### 
###################################################

MergedOptTable <- merge(OptFitsSummary,Covariates)

###################################################
### Export results to csv file ###
###################################################

write.csv(MergedOptTable, file = "../data/OptimisedFitSummary.csv")
write.csv(modelvec2, file = "../data/AnalysisTable.csv")
