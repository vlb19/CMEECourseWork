#!/bin/bash
# Author: Victoria Blanchard vlb19@imperial.ac.uk
# Script: run_get_TreeHeight.sh
# Desc: gets Tree Heights from input file and saves
# Arguments: 1 -> .csv file
# Date: 30 October 2019 

echo "Creating .csv file with calculated tree heights"
args <- commandArgs()
print(args)

echo "Running R script!"
Rscript get_TreeHeight.R trees
echo "Done! Results saved in trees.csv"

echo "Running python script!"
python3 get_TreeHeight.py
echo "Done! Results saved in pythontrees.csv"

echo "Check results folder"
exit