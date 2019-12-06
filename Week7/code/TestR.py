#!/usr/bin/env python

# Author: Victoria Blanchard vlb19@imperial.ac.uk
# Script: TestR.py
# Date: 25 November 2019
""" Open a Rscript in an R shell within R"""

## Imports
import subprocess


subprocess.Popen("Rscript --verbose TestR.R > ../results/TestR.Rout 2> ../results/TestR_errFile.Rout", shell=True).wait()

subprocess.Popen("Rscript --verbose TestR.R > ../results/TestR.Rout 2> ../results/TestR_errFile.Rout", shell=True).wait()