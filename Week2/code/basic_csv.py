#!/usr/bin/env python3
"""print modified contents of one csv file to another csv file """

### Imports 
import csv

# Read a file containing:
# 'Species','Infraorder','Family','Distribution','Body mass male (Kg)'
f = open('../data/testcsv.csv','r')

# Read in file and append contents of each row to a temporary tuple
# Print each row preceeded by "The species is"
csvread = csv.reader(f)
temp = []
for row in csvread:
    temp.append(tuple(row))
    print(row)
    print("The species is", row[0])

f.close()

# write a file containing only species name and Body mass
f = open('../data/testcsv.csv','r')
g = open('../data/bodymass.csv','w')

# Write a new csv file containing each row
csvread = csv.reader(f)
csvwrite = csv.writer(g)
for row in csvread:
    print(row)
    csvwrite.writerow([row[0], row[4]])

f.close()
g.close()
