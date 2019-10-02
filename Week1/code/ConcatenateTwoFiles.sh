#!/bin/bash
# Author: Victoria Blanchard vlb19@imperial.ac.uk
# Script: ConcatenateTwoFiles.sh
# Desc: Merge two files
# Arguments: 3 -> three separate files
# Date: 1 October 2019 

cat $1 > $3
cat $2 >> $3
echo "Merged File is "
cat $3

#end