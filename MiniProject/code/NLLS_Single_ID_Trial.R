# Subset the data for a single ID
datatry <- NestedData$data[[i]]

avalues <- c(a,rnorm(10, a, 1))
hvalues <- c(h,rnorm(10, h, 1))

TempTable <- data.frame("a_value" = rep(NA, length(avalues)), 
                        "h_value"= rep(NA, length(hvalues)), 
                        "AIC" = rep(NA, length(avalues)))

for (i in 1:length(avalues)){
  ### Fit models 
  anew <- avalues[i]
  hnew <- hvalues[i]
  
  TempTable[i,1] <- anew
  TempTable[i,2] <- hnew
  
  # Holling II model
  HolFit <- try(nlsLM(N_TraitValue ~ HollingII(ResDensity, TempTable[i,1], TempTable[i,2]), 
                      data = datatry, start = list(anew=a, hnew=h)), silent = T)
  
  #print(c(anew, AIC(HolFit)))
  # Holling II model
  TempTable[i, 3] <- ifelse(class(HolFit) == "try-error", rep(NA,1), AIC(HolFit))
  
  # Store the smallest value for AIC as a variable
  MinimumOptAIC <- min(TempTable[,3], na.rm = TRUE)
}

OptStartValueTable[i,2:3] <- TempTable[which(TempTable[3] == MinimumOptAIC),1:2]

a <- OptStartValueTable[i,2]
h <- OptStartValueTable[i, 3]
