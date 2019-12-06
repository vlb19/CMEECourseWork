#!/usr/bin/env python3

""" Runs the stochastic Ricker equation with gaussian fluctuations """

__appname__ = '[Vectorize2.py]'
__author__ = 'Victoria Blanchard (vlb19@ic.ac.uk)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

#####################################################
# Imports
#####################################################

import numpy as np
import random
import time

#####################################################
# Runs loopy stochastic Ricker model
#####################################################

def stochrick():
    # generate a list of random numbers between 0.5 and 1.5 1000 times
    p0 = []
    for i in range(0,1000):
        nextvalue = random.uniform(0.5,1.5)
        p0.append(nextvalue)
    # define other variables in stochastic ricker model
    r = 1.2 
    K = 1
    sigma = 0.2
    numyears = 100

    # generate a matrix of zeros with numyears number of rows and len(p0) number of columns
    N = np.zeros((numyears,len(p0))) 
    N[0] = p0

    # loop through each row in the matrix
    for pop in range (0, len(p0)): 
        # loop through column in the matrix
        for yr in range(1, numyears):
            # Run the equation for the stochastic Ricker Model
            N[yr,pop] = N[yr-1,pop]* np.exp(r* (1 - N[yr - 1, pop] / K) + np.random.normal(0.5,sigma))

    return(N)

##################################################
### Vectorised stochastic Ricker Model
##################################################

def stochrickvect():
    p0 = []
    for i in range(0,1000):
        nextvalue = random.uniform(0.5,1.5)
        p0.append(nextvalue)

    r = 1.2 
    K = 1
    sigma = 0.2
    numyears = 100
    N = np.zeros((numyears,len(p0))) 
    N[0] = p0
    for yr in range (1,numyears): # each column is a vector now, apply the function to each vector not each element = faster
        N[yr,] = N[yr-1,]* np.exp(r* (1 - N[yr - 1,] / K) + np.random.normal(0.5,sigma))
    return(N)


start_time = time.time() #store the current time as a variable
stochrick() #run the function
runningtime = time.time() - start_time #running time = time now - time before running the script
print("Loopy Stochastic Ricker takes:", runningtime)

start_time = time.time()
stochrickvect()
runningtime = time.time() - start_time
print("Vectorized Stochastic Ricker takes:", runningtime)

