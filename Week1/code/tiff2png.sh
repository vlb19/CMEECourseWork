#!/bin/bash
# Author: Victoria Blanchard vlb19@imperial.ac.uk
# Script: tiff2png.sh
# Desc: converts a tiff to a jpg file
# Arguments: 1 -> one tiff file
# Date: 1 October 2019 

for f in *.tif;
    do
        echo "Converting $f";
        convert "$f" "$(basename "$f" .tiff).jpg";
    done