#!/usr/bin/env Rscript

# CMEE 2019 HPC excercises R code HPC run code proforma

rm(list=ls()) # good practice 
graphics.off() # turn off any graphics

# Source main code file
source("vblanch_HPC_2019_main.R")

# Read in job number from the cluster
# iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))

# Create local test iter
 iter <- 1

# Create the seed number
set.seed(iter)
  # Select the correct iter for community in each parallel simulation 
  # based on the iter of iter 
  if (1 <= iter & iter <= 25){
    size = 5000
  } else if (26 <= iter & iter <= 50){
    size = 1000
  } else if (51 <= iter & iter <= 75){
    size = 2500
  } else if (76 <= iter & iter <= 100){
    size = 5000
  } else {print("Sizing was wrong")}

  # Set a wall time of 11.5 hours for all your jobs
  # wall_time = 11.5*60 
  # Set a test wall time of one minute 
  wall_time = 1
  
  # Set the other necessary starting conditions
  speciation_rate = 0.00585 #unique speciataion rate to me
  interval_rich = 1
  interval_oct = size/10
  burn_in_generations = 8*size 
  
  # Add leading zeros to iter if it is less than three digits long to tidy up the file name
  itername <- sprintf("iter_%03d",iter)
  
  # Create a filename to store results. Set the end of the file name to be the iter so the
  # files are not overwritten
  output_file_name <- paste("HPC_", itername, ".rda", sep = "")
  
  # Call the function cluster_run to do the simulation 
  cluster_run (speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name)

  


    


