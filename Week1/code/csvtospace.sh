#!/bin/bash
# Author: Victoria Blanchard vlb19@imperial.ac.uk
# Script: cvtospace.sh
# Desc: substitute the commas in the files with spaces
# saves the output into a .csv file 
# Arguments: 1 -> tab delimited file 
# Date: 1 October 2019 

for f in  `ls ../data/Temperatures/*.csv` ; #goes to the directory containing the temperature data
    do
        echo "Creating a space delimited version of $f ..." #prints function with each file neame
        filename=$(basename "${f}" .csv) #strips .csv extension from the filename
        cat $f | tr -s "," " " >> ../data/Temperatures/$filename.txt #changes comma delimited files into space delimited files and stores them in the Temperatures folder with the .txt extension
        echo "Done!" #Prints done
    done #finishes for loop
