#!/usr/bin/env python3

""" Plotting in Python
Numerical integration using scipy
The Lotka-Volterra model """

__appname__ = '[LV2.py]'
__author__ = 'Victoria Blanchard (vlb19@ic.ac.uk)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

import scipy as sc
import scipy.linalg
import scipy.integrate as integrate
import sys
import matplotlib.pylab as p


def dCR_dt(pops, t=0):
    
    R = pops[0] #resource population abundance
    C = pops[1] #consumer population abundance
    dRdt = r * R * (1 - R / K) - a * R * C 
    dCdt = -z * C + e * a * R * C
    
    return sc.array([dRdt, dCdt])

type(dCR_dt)

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


#define time vector integrating from time point 0 to 15 using 1000 sub-divisions of time
t = sc.linspace(0, 30, 1000)

# Setting the initial conditions for the two populations (10 resources and 5 consumers per unit area), and convert the two into an array (because our function takes an array as input)

R0 = 10 
C0 = 5
RC0 = sc.array([R0, C0])

# Numerically integrate this system forward from the starting conditions
pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)
pops

type(infodict)

infodict.keys()

infodict['message']

#### Plotting Figures

fig, (ax1, ax2) = p.subplots(1,2) # creating two graph plotting areas 

## Plot graph 1
ax1.plot(t, pops[:,0], 'g-', label='Resource density') 
ax1.plot(t, pops[:,1], 'b-', label='Consumer density')
ax1.grid()
ax1.legend(loc='best')
ax1.set(xlabel = 'Time', ylabel = 'Population density')

## Plot graph 2
ax2.plot(pops[:,0], pops[:,1], 'r-', label="Resource density")
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
fig.savefig('../results/LV2_model.pdf')
