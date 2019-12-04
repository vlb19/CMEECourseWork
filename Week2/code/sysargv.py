#!/usr/bin/env python3

# Author: Victoria Blanchard vlb19@imperial.ac.uk
# Script: sysargv.py
# Date: 3 December 2019

# Desc: 
# Demonstrate system arguments

# ARGUMENTS
# system argument required

# OUTPUT
# Prints system argument-dependent strings

### Imports ###

import sys

### Script ###
print("This is the name of the script", sys.argv[0])
print("Number of arguments: ", len(sys.argv))
print("The arguments are: ", str(sys.argv))

