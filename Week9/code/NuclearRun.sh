#!/bin/bash
#PBS -l walltime=00:03:00
#PBS -l select=1:ncpus=1:mem=5gb
module load anaconda3/personal
echo "R is about to run"
pwd
R --vanilla < $HOME/Rtest/ClusterRun.R
mv NR* $HOME
echo "R has finished running"
