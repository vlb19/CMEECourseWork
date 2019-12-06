#!/usr/bin/env python3

""" Print Kingdom, Phylum, and Species from a CSV"""

# Author: Victoria Blanchard vlb19@imperial.ac.uk
# Script: blackbirds.py
# Date: 25 November 2019

### Imports
import re

# Read the file (using a different, more python 3 way, just for fun!)
with open('../data/blackbirds.txt', 'r') as f:
    text = f.read()

# replace \t's and \n's with a spaces:
text = text.replace('\t',' ')
text = text.replace('\n',' ')

# First encode into ascii bytes
text = text.encode('ascii', 'ignore') 
# Decode back to string
text = text.decode('ascii', 'ignore') 

# Find all Kingdoms, Phyla, and Species
Kingdom = re.findall(r'Kingdom\s+\w+', text) # Find all kingdoms
Phylum = re.findall(r'Phylum\s+\w+', text) # Find all Phyla
Species = re.findall(r'Species\s+\w+', text) # Find all Species


### Print all 
for i in range(len(Kingdom)): 
    print (Kingdom[i])
    print (Phylum[i])
    print (Species[i], '\n')
