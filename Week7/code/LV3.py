#!/usr/bin/env python3

### Plotting in Python
### Numerical integration using scipy
## The Lotka-Volterra model

import scipy as sc
import scipy.linalg
import scipy.integrate as integrate
import sys
import matplotlib.pylab as p
import numpy as np

# Define function 
def DiscreteTime(RC, t=0): 
    R = RC[0]
    C = RC[1]
    RNew = R * ((1 + r * (1 - R/K)- a * C))
    CNew = C * (1 - z + e * a * R)
    return sc.array([RNew, CNew])

# assign parameter values
if len(sys.argv) == 5:

    r = float(sys.argv[1]) #intrinsic growth rate of the resource population
    a = float(sys.argv[2]) #per captita search rate fore the resource (area x time^-1)
    z = float(sys.argv[3]) #mortality rate
    e = float(sys.argv[4]) #consumer efficiency
    K = float(sys.argv[5])
else: 
    r = 1. #intrinsic growth rate of the resource population
    a = 0.1 #per captita search rate fore the resource (area x time^-1)
    z = 1.5 #mortality rate
    e = 0.75 #consumer efficiency
    K = 35

#define time vector integrating from time point 0 to 30 using 1000 sub-divisions of time
timeseries = list(range(1,10))
timeseries = list(sc.linspace(1,15,100))
rows = len(timeseries)+1

#define time vector integrating from time point 0 to 30 using 1000 sub-divisions of time
timeseries = list(range(1,10))# Setting the initial conditions for the two populations (10 resources and 5 consumers per unit area), and convert the two into an array (because our function takes an array as input)R0 = 10
C0 = 5
RC0 = sc.array([R0, C0])RC = np.zeros([rows,2])
RC[:1] = RC0
RC
RC[0,0]
# Run discrete-time version of the LV modelfor t in timeseries:
    print(t)for t in timeseries:
    RC[t,0] = RC[t-1,0] * ((1 + r * (1 - RC[t-1,0]/K)- a * RC[t-1,1]))
    RC[t,1] = RC[t-1,1] * (1 - z + e*a* RC[t-1,1])
    
# Setting the initial conditions for the two populations (10 resources and 5 consumers 
# per unit area), and convert the two into an array (because our function takes an array as input)
R0 = 10
C0 = 5
RC0 = sc.array([R0, C0])
RC = np.zeros([rows,2])
RC[:1] = RC0

# Run discrete-time version of the LV modelfor t in timeseries:

for row in RC0:
    for t in timeseries:
        indexvalue = timeseries.index(t)
        RC0 = np.append(RC0,DiscreteTime(RC0[indexvalue],t))

# Add start time point 
timeseries.insert(0,0)

#### Plotting Figures

fig, (ax1, ax2) = p.subplots(1,2) # creating two graph plotting areas 

## Plot graph 1
ax1.plot(timeseries, RC[:,0], 'g-', label='Resource density') 
ax1.plot(timeseries, RC[:,1], 'b-', label='Consumer density')
ax1.grid()
ax1.legend(loc='best')
ax1.set(xlabel = 'Time', ylabel = 'Population density')

## Plot graph 2
ax2.plot(RC[:,0], RC[:,1], 'r-', label="Resource density")
ax2.grid()
ax2.set(xlabel = 'Resource Density', ylabel = 'Consumer Density')

## Add parameter values to graph
labelr = ' '.join(("r = ", str(r)))
labela = ' '.join(("a = ", str(a)))
labelz = ' '.join(("z = ", str(z)))
labele = ' '.join(("e = ", str(e)))
parameterlabels = '\n'.join((labelr,labela,labelz,labele))
boxproperties = dict(boxstyle='round', facecolor='white', alpha=0.5)
ax2.text(0.1, 0.95, parameterlabels, transform=ax2.transAxes, fontsize=9, verticalalignment='top', bbox=boxproperties)

## Put super title over the two graphs
fig.suptitle('Consumer-Resource population dynamics')

## Save figure to results folder
fig.savefig('../results/LV3_model.pdf')
