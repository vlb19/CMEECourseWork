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


### Imports
import networkx as nx
import scipy as sc
import matplotlib.pylab as p
import csv
import pandas
import numpy as np


### Import csv files 
links = pandas.read_csv('../data/QMEE_Net_Mat_edges.csv', header =0)
nodes = pandas.read_csv('../data/QMEE_Net_Mat_nodes.csv', header =0)

### Generate an adjacency list representing a food web
#links = links.rename(columns= {"ICL":0,"UoR":1,"CEH":2,"ZSL":3,"CEFAS":4,"NonAc":4})
links.index = ["ICL", "UoR", "CEH", "ZSL", "CEFAS", "NonAc"]
links = links.stack().reset_index()
links = links[(links != 0).all(1)]
AdjL = sc.array(links)
AdjL = np.delete(AdjL,2,1)

AdjL

### Save university ID (node) data
#Sps = nodes.iloc[:,0]# get University ids
Sps = sc.unique(AdjL)
Sps
### Use a circular configuration

pos = nx.circular_layout(Sps) # calculate the coordinates using networkx

# Generate a networkx graph object
G = nx.Graph()

# Add nodes and links to it
G.add_nodes_from(Sps)
G.add_edges_from(AdjL)

colours = ['lime', 'lime', 'blue', 'red', 'blue', 'lime']
# Generate node sizes that are proportional to (log) body sizes
#NodSizs= 1000 * (Sizs-min(Sizs))/(max(Sizs)-min(Sizs)) 
#Need to make arrow size

# Render the graph 
f3 = p.figure()
nx.draw_networkx(G, pos, node_size = 4500, node_color = colours, arrowsize=20, arrowstyle='fancy')
nx.coloring.greedy_color(G, strategy = 'independent_set')

# Save file
f3.savefig('../results/Nets.svg')



