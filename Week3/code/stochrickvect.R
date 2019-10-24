# Runs the stochastic Ricker equation with gaussian fluctuations

rm(list=ls()) # clears the workspace

stochrickvect<-function(p0=runif(1000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=100){
#sets p0 to be a population of 1000 individuals of random identity between 0.5 and 1.5
#sets the intrinsic growth rate (r) to be 1.2
#sets the carrying capacity of the population (k) to be 1
#sets the standard deviation for generating stochacity (sigma) to be 0.2
#sets the running period to be 100 iterations

    N<-matrix(NA,numyears,length(p0)) #creates a matrix of NA, numyears (100), and number of arguments in p0 (100)
    N[1,]<-p0 #sets the first column to be the values of p0 (1000 randomly generated numbers between 0.5 and 1.5)
    for (yr in numyears){
        N[yr,] <- N[yr-1,] * exp(r * (1 - N[yr - 1,] / K) + rnorm(length(p0),0,sigma)) #Runs stochastic Ricker model with Gaussian Fluctuations (rnorm...)
    }

    return(N)}


print("Vectorized Stochastic Ricker takes:") 
print(system.time(res2<-stochrickvect()))
