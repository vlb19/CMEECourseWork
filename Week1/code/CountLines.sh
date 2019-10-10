#!/bin/bash
# Author: Victoria Blanchard vlb19@imperial.ac.uk
# Script: CountLines.sh
# Desc: Count the number of lines in the desired file
# Arguments: 1 -> File
# Date: 1 October 2019 

NumLines=`wc -l < $1`
echo "The file $1 has $NumLines lines"
echo