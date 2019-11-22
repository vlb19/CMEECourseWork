rm(list=ls()) #Clear global environment 
#Set working directory
setwd("/Users/emmadeeks/Desktop/CMEECourseWork/week8/data")

# Get thee required packages
require('minpack.lm')
library('dplyr')


######################################## PREPARES DATA ###################
#Explore the data 
data <- read.csv('modified_CRat.csv')


#Subset data with a nice looking curve to model with 
Data2Fit <- subset(data, ID == 39982) #One curve
# Plot the curve 
plot(Data2Fit$ResDensity, Data2Fit$N_TraitValue)


###################################### OBTAINING STARTING VALUES ###############

#This is basically cutting the last points of the graph off 
# After the highest point 
# Because a needs to fit to just the slope
a.line <- subset(Data2Fit, ResDensity <= max(data$N_TraitValue), N_TraitValue <= max(data$N_TraitValue))
plot(a.line$ResDensity, a.line$N_TraitValue)

#plot slope/ linear regressopn of cut slope 
lm <- summary(lm(N_TraitValue ~ ResDensity, a.line))
# Extracts slope value
a <- lm$coefficients[2]
# h parameter is the maximum of the slope so you take the biggest value 
h <- max(Data2Fit$N_TraitValue)

q = -1 

################################# OPTIMISING STARTING VALUES ##################

paraopt = as.data.frame(matrix(nrow = 1, ncol = 4))

for(i in 1:100){
  anew = rnorm(1, mean = a, sd=1)
  hnew = rnorm(1, mean = h, sd=1)
  PowFit <- nlsLM(N_TraitValue ~ powMod(ResDensity, a, h), data = Data2Fit, start = list(a= anew, h= hnew))
  AIC = AIC(PowFit)
  p <- c(i, anew, hnew, AIC)
  paraopt = rbind(paraopt, p)
}

min_values <- paraopt[which.min(paraopt$V4), ]
hN <- min_values$V3
aN <- min_values$V2

####################################### DEFINING FUNCTIONS OF MODELS ##############

#Holling type II functional response
#This is making a function of the second model we looked at 
powMod <- function(x, a, h) { #These are parameters
  return( (a*x ) / (1+ (h*a*x))) # This is the equation
}

# Phenomenological quadratic model 
Predic2PlotPow <- powMod(Lengths,coef(PowFit)["a"],coef(PowFit)["h"])

#Generalised functional response model

GenMod <- function(x, a, h, q) { #These are parameters
  return( (a* x^(q+1) ) / (1+ (h*a*x^(q+1))))
}


################################### FITTING MODELS #############################

PowFit <- nlsLM(N_TraitValue ~ powMod(ResDensity, a, h), data = Data2Fit, start = list(a=a, h=h))

QuaFit <- lm(N_TraitValue ~ poly(ResDensity,2), data = Data2Fit)

GenFit <- nlsLM(N_TraitValue ~ GenMod(ResDensity, a, h, q), data = Data2Fit, start = list(a=a, h=h, q= q))

############################## PLOTTING MODELS ###################################

Lengths <- seq(min(Data2Fit$ResDensity),max(Data2Fit$ResDensity))
coef(PowFit)["a"]
coef(PowFit)["h"]

Predic2PlotPow <- powMod(Lengths,coef(PowFit)["a"],coef(PowFit)["h"])
Predic2PlotQua <- predict.lm(QuaFit, data.frame(ResDensity = Lengths))
Predic2PlotGen <- GenMod(Lengths,coef(GenFit)["a"],coef(GenFit)["h"], coef(GenFit)["q"])


plot(Data2Fit$ResDensity, Data2Fit$N_TraitValue)
lines(Lengths, Predic2PlotGen, col = 'green', lwd = 2.5)
lines(Lengths, Predic2PlotPow, col = 'blue', lwd = 2.5)
lines(Lengths, Predic2PlotQua, col = 'red', lwd = 2.5)

########################## LOOPING FUNCTIONS ############



# distinct
 alldata <- data %>% 
  distinct(ID, .keep_all = T)

alldata <- subset(data, data$ID)

for (id in unique.id){
  curr_data <- subset(data, ID== id)
  print(paste())
}





















