#!/usr/bin/env python3

# Author: Victoria Blanchard vlb19@imperial.ac.uk
# Script: oaks_debugme.py
# Date: 3 December 2019

# Desc: 
# Checks whether items in a dictionary are oaks 

# ARGUMENTS
# Requires csv file

# OUTPUT
# Prints "Found an Oak", writes a csv file containing
# only oaks

### Imports ###

import csv
import sys
import doctest
import re

#Define function
def is_an_oak(name):
    """
    Returns True if name starts with 'quercus'
    
    >>> is_an_oak('Fagus sykvatica')
    False
    
    >>> is_an_oak('Quercus cerris')
    True

    >>> is_an_oak('Quercus')
    True

    """
    # match "quercus" with the input name
    if re.match(r'\bquercus\b', name, re.IGNORECASE):
        return True
    else:
        return False


def main(argv): 
    # open data
    f = open('../data/TestOaksData.csv','r')
    line1 = f.readline()
    lines = f.readlines()[0:]

    # open output document
    g = open('../results/JustOaksData.csv','w')
    g.write(line1)
    taxa = csv.reader(lines)
    csvwrite = csv.writer(g)
    oaks = set()

    # test whether each row in taxa contains an oak
    for row in taxa:
        print(row)
        print ("The genus is: ") 
        print(row[0] + '\n')
        if is_an_oak(row[0]):
            print('FOUND AN OAK!\n')
            csvwrite.writerow([row[0], row[1]])    

    return 0


if (__name__ == "__main__"):
    status = main(sys.argv)
    doctest.testmod()