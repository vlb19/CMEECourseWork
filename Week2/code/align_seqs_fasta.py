#!/usr/bin/env python3
""" Align two DNA sequences and save the best alignment 
and best alignment score to a csv file in results folder"""

### Imports
import os
import sys

# Change working directory
path = "../data/fasta"
os.chdir(path)

### Functions

# Parse the fasta file to skip the header then remove newline characters
def parse_fasta(fastafile):
    fastastr = ""
    header = True
    with open(fastafile, "r") as f:
        for row in f:
            if header:
                header = False
            else:
                fastastr += row.strip("\n")
    return fastastr

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

# Check for system arguments and use default files if there are none
if len(sys.argv) > 1:
    seq1 = parse_fasta(sys.argv[1])
    seq2 = parse_fasta(sys.argv[2])
else: 
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

# find the best match (highest score) for the two sequences
my_best_align = None
my_best_score = -1

for i in range(l1): # Just take the last alignment with the highest score
    z = calculate_score(s1, s2, l1, l2, i)
    if z > my_best_score:
        my_best_align = "." * i + s2 # use * to move the sequences along
        my_best_score = z 

print("Sequences aligned!")

# Change working directory
path = "../../code"
os.chdir(path)

# Save results into text file with proper formatting
f = open('../results/best_fasta_alignment.txt',"w+")
my_best_score = str(my_best_score)
f.write ("Best Alignment: ")
f.write ("\n")
f.write (my_best_align)
f.write ("\n")
f.write (seq2)
f.write ("\n")
f.write ("Best Score: ")
f.write ("\n")
f.write (my_best_score)
f.close()