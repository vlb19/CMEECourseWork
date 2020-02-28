#!/bin/bash 
#Author: Victoria Blanchard vlb19@imperial.ac.uk
#Script: run_MiniProject.sh
#Desc: One file to run all the mini project scripts
#Arguments: 4 files: dataexploration.py, NLLS_Fitting_Script.R, 
# DataAnalysis.py, MiniProjectReport.tex
#Date: 26th February 2020

# Run data exploration script
python3 "dataexploration.py"

# Run NLLS fitting script 
Rscript "NLLS_Fitting_Script.R"

# Run model analysis script 
python3 "DataAnalysis.py"

# Run LaTeX compiling script
latex "MiniProjectReport.tex"
# Run word count for LaTex
texcount -1 -sum MiniProjectReport.tex > MiniProjectReport.sum
# Re-run LaTeX compiling script with included word count
latex "MiniProjectReport.tex"
echo "Report compiled"
