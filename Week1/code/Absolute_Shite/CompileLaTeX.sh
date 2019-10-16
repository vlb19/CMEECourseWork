#!/bin/bash
#Author: Victoria Blanchard vlb19@imperial.ac.uk
#Script: CompileLaTeX.sh
#Desc: shell script to compile latex with bibtex
#Arguments: 1 -> 1 bibtex file
#Date: 2 October 2019

pdflatex $1.tex    
pdflatex $1.tex
bibtex $1
pdflatex $1.tex
pdflatex $1.tex 
evince $1.pdf &

#Cleanup
rm *~
rm *.aux
rm *.dvi
rm *.log
rm *.nav
rm *.out
rm *.snm
rm *.toc