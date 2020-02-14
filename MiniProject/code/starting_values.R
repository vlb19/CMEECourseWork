

iters = 10
maxiters = 21

OptStartValueTable <- data.frame("ID" = NestedData$ID, 
                              "a_value" = rep(NA), 
                              "h_value"= rep(NA))

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

    GenFit <- suppressWarnings(try(nlsLM(N_TraitValue ~ GenMod(data2try$ResDensity, a, h, q), 
                data = data2try, start = list(a = GenStarta, h = GenStarth)), silent = T))
  
  
    # add test values to table
    TestOptimum[k,1:3] <- c(GenStarta, GenStarth, ifelse(class(GenFit) == "try-error", rep(NA,1), AIC(GenFit)))
  }
  
  # Find the minimum AIC for the table
  minAIC <- min(TestOptimum[,3], na.rm = T)

  # Append a and h values to the table of optimised starting values
  OptStartValueTable[i,1:3] <- c(data2fit$ID[1], TestOptimum[which(TestOptimum[3] == minAIC),1], TestOptimum[which(TestOptimum[3] == minAIC),2])
  #OptStartValues[i,] <- c(data2fit$ID[1], TestOptimum[which(TestOptimum[3] == minAIC),1], TestOptimum[which(TestOptimum[3] == minAIC),2])

}


