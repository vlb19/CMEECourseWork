#!/usr/bin/env python3

### Plotting in Python
### Numerical integration using scipy
## The Lotka-Volterra model

import scipy as sc
import scipy.linalg
import scipy.integrate as integrate

def dCR_dt(pops, t=0):
    
    R = pops[0] #resource population abundance
    C = pops[1] #consumer population abundance
    dRdt = r * R - a * R * C
    dCdt = -z * C + e * a * R * C
    
    return sc.array([dRdt, dCdt])

type(dCR_dt)

# assign parameter values
r = 1. #intrinsic growth rate of the resource population
a = 0.1 #per captita search rate fore the resource (area x time^-1)
z = 1.5 #mortality rate
e = 0.75 #consumer efficiency

#define time vector integrating from time point 0 to 15 using 1000 sub-divisions of time
t = sc.linspace(0, 15, 1000)

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

import matplotlib.pylab as p

f1 = p.figure()

p.plot(t, pops[:,0], 'g-', label='Resource density') 
p.plot(t, pops[:,1], 'b-', label='Consumer density')
p.grid()
p.legend(loc='best')
p.xlabel('Time')
p.ylabel('Population density')
p.title('Consumer-Resource population dynamics')

f1.savefig('../results/LV_model.pdf') #Save figure to results folder

f2 = p.figure()
p.plot(pops[:,0], pops[:,1], 'r-', label="Resource density")
p.grid()
p.xlabel('Resource Density')
p.ylabel('Consumer Density')
p.title('Consumer-Resource population dynamics')

f2.savefig('../results/LV_model2.pdf')