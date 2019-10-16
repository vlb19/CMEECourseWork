#!/usr/bin/env python3

"""Description of this program or application.
    You can use several lines"""

__appname__ = 'align_seqs_better.py'
__author__ = 'Viki Blanchard (vlb19@ic.ac.uk)'
__version__ = '0.0.1'

#Imports

import os
import sys
import pickle

path = "../data/fasta" # sets the path to the desired directory
os.chdir(path) # sets the directory to the path

def parse_fasta(fastafile): # converts any fasta file to a single
    #string with the header removed
    fastastr = ""
    header = True
    with open(fastafile, "r") as f:
        for row in f:
            if header:
                header = False #skips first line
            else:
                fastastr += row.strip("\n") #strips all new lines
    return fastastr

if len(sys.argv) > 1: #if there are user arguments use them
    seq1 = parse_fasta(sys.argv[1])
    seq2 = parse_fasta(sys.argv[2])
else: #otherwise use the set files
    seq1 = parse_fasta("407228412.fasta")
    seq2 = parse_fasta("407228326.fasta")


# Assign the longer sequence s1, and the shorter to s2
# l1 is length of the longest, l2 that of the shortest

l1 = len(seq1)
l2 = len(seq2)
if l1 >= l2:
    s1 = seq1
    s2 = seq2
else:
    s1 = seq2
    s2 = seq1
    l1, l2 = l2, l1 # swap the two lengths

# A function that computes a score by returning the number of matches starting
# from arbitrary startpoint (chosen by user)
def calculate_score(s1, s2, l1, l2, startpoint):
    matched = "" # to hold string displaying alignements
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"
    return score

# Test the function with some example starting points:
# calculate_score(s1, s2, l1, l2, 0)
# calculate_score(s1, s2, l1, l2, 1)
# calculate_score(s1, s2, l1, l2, 5)

# now try to find the best match (highest score) for the two sequences
my_best_align = None
my_best_score = {} # Create new empty dictionary for best scores


for i in range(l1): # Note that you just take the last alignment with the highest score
    z = calculate_score(s1, s2, l1, l2, i)
    my_best_align = "." * i + s2 # add i number of "." before adding
    #the sequence which is aligning sequence 2 to seq1 
    if z in my_best_score.keys(): 
        my_best_score[z].append(my_best_align) #append aligments to 
        #dictionary by score
    else:
        my_best_score[z] = [my_best_align]

vals = max(my_best_score.keys()) #store the higest score to vals variable

path = "../../code" #set path to original directory
os.chdir(path) #change to original directory

f = open('../results/best_fasta_alignments.txt','w+') #open new file in 
#results
f.write ("Best Alignment: "+"\n") #heading for document 
for x in my_best_score[vals]:
    f.write(x) # Write every alignment with the best score 
f.write ("\n" + seq2 + "\n") # Write the sequence seq1 is aligned to
f.write ("Best Score: " + "\n" + str(vals)) #write in the best score value
f.close()

print("Sequences aligned!")
