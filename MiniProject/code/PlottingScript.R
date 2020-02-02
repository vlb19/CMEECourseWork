#!/usr/bin/env Rscript

rm(list=ls()) #Clear global environment

#Set working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#Source functions from NNLS fitting 
source("NLLS_Fitting_Script2.R")

###############################################
### Import Packages ###
###############################################

# For Levenberg-Marquardt nlls fitting
require("minpack.lm") 

# For plotting 
require("ggplot2")

###############################################
### Load in model data ### 
###############################################




###################################################
### Plot fitted models
###################################################

for (i in 1:length(ModelFits$ID)){
  
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
  Predic2PlotGen <- GenMod(ResDensities, coef(GenFit)["a"], coef(GenFit)["h"], q)

### Plot the lines
  # Quadratic model 
  lines(ResDensities, Predic2PlotQua, col = 'red', lwd = 2.5)

  # Cubic model
  lines(ResDensities, Predic2PlotCub, col = 'blue', lwd = 2.5)

  # Plot the data and the fitted Holling II model line
  lines(ResDensities, Predic2PlotHolling, col = "green", lwd = 2.5)

  # Fit General model line
  lines(ResDensities, Predic2PlotGen, col = 'magenta', lwd = 2.5)

## Add legend to graph
legend("topleft", legend = c("Quadratic model", "Cubic Model", "Holling II", "General model"), lty = 1, col = c("red", "blue", "green", "pink"))
#text(300, 0.025, labels = LineEquation )

## Add equation of line to graph
  LineEquation = paste("Consumption Rate = ", coef(HolFit)["a"], 'x Resource Density ^', coef(HolFit["h"]))
  # Generate a vector of resource densities for plotting
  ResDensities <- seq(min(data$ResDensity), max(data$ResDensity), len = 200)
}


## Calculate confidence intervals on the estimated parameters

preds <- predict(QuaFit, newdata = data.frame(ResDensity = ResDensities), 
                 interval = 'confidence')
polygon(c(rev(ResDensities), ResDensities), c(rev(preds[ ,3]), preds[ ,2]), col = 'grey80', border = NA)


