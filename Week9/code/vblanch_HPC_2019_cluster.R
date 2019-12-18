#!/usr/bin/env Rscript

# CMEE 2019 HPC excercises R code HPC run code proforma

rm(list=ls()) # good practice 
graphics.off() # turn off any graphics

# Source main code file
source("vblanch_HPC_2019_main.R")

# Read in job number from the cluster
# iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))

# Create local test iter
iter <- 1:3

# Create the seed number
for (value in iter){
  set.seed(iter)
  # Select the correct value for community in each parallel simulation 
  # based on the value of iter 
  if (1 <= iter <= 25){
    size = 500
  } else if (26 <= iter <= 50){
    size = 1000
  } else if (51 <= iter <= 75){
    size = 2500
  } else if (76 <= iter <= 100){
    size = 5000
  } else {print("Sizing was wrong")}
  # Set a wall time of 11.5 hours for all your jobs
  wall_time = 1
  # Set the other starting conditions
  speciation_rate = 0.00585
  interval_rich = 1
  interval_oct = size/10
  burn_in_generations = 8*size 
  
  # Call the function cluster_run to do the simulation 
  cluster_run (speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name)
}


  
# Create a filename to store results. Set the end of the file name to 
# be iter so files are not overwritted

    


