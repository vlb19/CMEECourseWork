#!/usr/bin/env python3

"""Description of this program or application.
    You can use several lines"""

__appname__ = '[application name here]'
__author__ = 'Your Name (your@email.address)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

#Imports

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
    if re.match(r'\bquercus\b', name, re.IGNORECASE):
        return True
    else:
        return False


def main(argv): 
    f = open('../data/TestOaksData.csv','r')
    line1 = f.readline()
    lines = f.readlines()[0:]
    g = open('../results/JustOaksData.csv','w')
    g.write(line1)
    taxa = csv.reader(lines)
    csvwrite = csv.writer(g)
    oaks = set()
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