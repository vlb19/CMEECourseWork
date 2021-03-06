#!/usr/bin/env python3

# Author: Victoria Blanchard vlb19@imperial.ac.uk
# Script: runLVs.py
# Date: 25 November 2019

""" A python script that runs the LV python scripts
using inputs from system arguments"""

import timeit
import scipy as sc
import time
import sys
import cProfile

# Import the functions 
from LV1 import dCR_dt as LV1Script 
from LV2 import dCR_dt as LV2Script
from LV3 import LV3_script

# Set parameters
r = float(sys.argv[1]) 
a = float(sys.argv[2])
z = float(sys.argv[3])
e = float(sys.argv[4])

RC0 = sc.array([10,5])

# Record overall running times for the two scripts
start = time.time()
LV1Script(RC0)
print("LV1 Script takes %f s to run." %(time.time()- start))

start = time.time()
LV2Script(RC0)
print("LV2 Script takes %f s to run." %(time.time()- start))

# Display run times of different sections of the code
cProfile.run('LV1Script(RC0)')
cProfile.run('LV2Script(RC0)')

