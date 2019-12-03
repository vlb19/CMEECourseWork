#!/usr/bin/env python3

# Author: Victoria Blanchard vlb19@imperial.ac.uk
# Script: get_TreeHeight.py
# Date: 25 October 2019

# Desc: 
# This function calculates heights of trees given distance of each tree 
# from its base and angle to its top, using  the trigonometric formula 
# height = distance * tan(radians)

# ARGUMENTS
# degrees:   The angle of elevation of tree
# distance:  The distance from base of tree (e.g., meters)

# OUTPUT
# The heights of the tree, same units as "distance"

########################################################
# Imports
########################################################
import math
import sys
import csv
import scipy as sc
import pandas as pd
import numpy as np

####################################################
# Define functions
####################################################
def Treeheight(degrees, distance):
    radians = (degrees * math.pi) / 180
    height = distance * math.tan(radians)
    return height

########################################################
# Importing csv
########################################################

# take system argument defined file name if there is one otherwise use the default trees.csv
if len(sys.argv) >1: 
    trees = pd.read_csv(sys.argv[1])
else: 
    trees = pd.read_csv('../data/trees.csv', header =0)

"""
Treeheight(30, 40)
"""
# index angle and distance columns from data set
angle = trees["Angle.degrees"] 
distance = trees["Distance.m"]

# create empty array
h = np.array([])

# calculate heights for each row in data set and add them to the array 
for i in range(0,len(angle)):
    height = Treeheight(angle[i],distance[i])
    h = np.append(h,height)

# add height column to data frame with height data
trees["Height.m"] = h

# write new data to csv file in results folder
trees.to_csv('../results/pythontrees.csv')