#!/usr/bin/env python3

# Author: Victoria Blanchard vlb19@imperial.ac.uk
# Script: run_fmr_R.py
# Date: 25 November 2019

""" Execute an R script from a file within the 
R shell in python terminal"""

### Imports
import subprocess

### Script
subprocess.call("/usr/bin/Rscript fmr.R", shell = True) #execute an R script found in fmr.R within the R shell