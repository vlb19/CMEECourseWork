#!/usr/bin/env python3

""" Create a network plot using data from imported CSV """

__appname__ = '[DrawFW.py]'
__author__ = 'Victoria Blanchard (vlb19@ic.ac.uk)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

### Imports
import networkx as nx
import scipy as sc
import matplotlib.pylab as p
import csv
import pandas

### Import csv files 
edges = pandas.read_csv('../data/QMEE_Net_Mat_edges.csv', header =0)
nodes = pandas.read_csv('../data/QMEE_Net_Mat_nodes.csv', header =0)

### Generate a synthetic food web
def GenRdmAdjList(N = 2, C = 0.5):
    """ 
    """
    Ids = range(N)
    ALst = []
    for i in Ids:
        if sc.random.uniform(0,1,1) < C:
             sLnk =c.random.choice(Ids,2).tolist()
            if Lnk[0] != Lnk[1]: #avoid self (e.g., cannibalistic) loops
                ALst.append(Lnk)
    return ALst

### Assign number of species (MaxN) and connectance (C)
MaxN = 30
C = 0.75

### Generate an adjacency list representing a random food web
AdjL = sc.array(GenRdmAdjList(MaxN, C))
AdjL

### Generate species (node) data
Sps = sc.unique(AdjL) # get species ids

### Generate body sizes for the species 
SizRan = ([-10,10]) #use log10 scale
Sizs = sc.random.uniform(SizRan[0],SizRan[1],MaxN)
Sizs

### Visualising the size distribution generated 

p.hist(Sizs) #log10 scale
p.hist(10 ** Sizs) #raw scale
p.close('all') # close all open plot objects

### Use a circular configuration

pos = nx.circular_layout(Sps) # calculate the coordinates using networkx

# Generate a networkx graph object
G = nx.Graph()

# Add nodes and links (edges) to it
G.add_nodes_from(Sps)
G.add_edges_from(tuple(AdjL))

tuple(AdjL)
# Generate node sizes that are proportional to (log) body sizes
NodSizs= 1000 * (Sizs-min(Sizs))/(max(Sizs)-min(Sizs)) 

# Render the graph 
f3 = p.figure()
nx.draw_networkx(G, pos, node_size = NodSizs)

# Save file
f3.savefig('../results/DrawFW.pdf')



