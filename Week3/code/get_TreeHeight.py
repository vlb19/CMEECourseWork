# This function calculates heights of trees given distance of each tree 
# from its base and angle to its top, using  the trigonometric formula 
#
# height = distance * tan(radians)
#
# ARGUMENTS
# degrees:   The angle of elevation of tree
# distance:  The distance from base of tree (e.g., meters)
#
# OUTPUT
# The heights of the tree, same units as "distance"

########################################################
# Imports
########################################################
import math
import sys
import csv
import scipy as sc

####################################################
# Define functions
####################################################
def Treeheight(degrees, distance):
    radians = (degrees * math.pi) / 180
    height = distance * math.tan(radians)
    print("Tree height is:", height)
    return height

########################################################
# Inputs
########################################################
"""
if len(sys.argv) >1: 
    with open(sys.argv) as TreeHeights:
    csv_reader = csv.reader(TreeHeights, delimiter=',')
else: 
    with open("../data/trees.csv") as TreeHeights:
    csv_reader = csv.reader(TreeHeights, delimiter=',')
"""
f = open('../data/trees.csv', 'r')
csvread = csv.reader(f)
g = open('../results/treeheightspython.csv','w')
csvwrite = csv.writer(g)

import csv
with open ("../data/trees.csv") as treeheights: 
    data = csv.reader(treeheights)
    reader = csv.reader(f)
    headers = next(reader, None)

print(data)

for x in reader: 
    print (x[1])

    """"

    Height = Treeheight(row[1], row[2])
    print(Height)

f.close()
g.close()


"""

#Treeheight(30, 40)

h = Treeheight(trees$Angle.degrees, trees$Distance.m)