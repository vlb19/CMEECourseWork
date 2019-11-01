#!/bin/bash
# Author: Victoria Blanchard vlb19@imperial.ac.uk
# Script: csvtospace.sh
# Desc: substitute the commas in the files with spaces
# saves the output into a .txt file 
# Arguments: 1 -> comma delimited file 
# Date: 1 October 2019 

for f in `ls ../*.txt`; #runs code on every .csv file in the Temperatures folder
    do
        filename=$(basename ${f}) #strip file extension and save to new variable
        echo "Creating a space delimited version of $filename"; #explain what is being done to the user
        cat $f | tr -s "    " "," > ../results/$filename.txt #save space delimited file to results area
        echo "Done!" 
done