# CMEE 2019 HPC excercises R code HPC run code proforma

rm(list=ls()) # good practice 
source("vblanch_HPC_2019_main.R")

community <- init_community_max(7)
duration <- 20
speciation_rate <- 0.2
abundance_vector <- c(100,64,63,5,4,3,2,2,1,1,1,1)

choose_two(community)
neutral_step(community)
neutral_generation(community)
neutral_time_series(community,duration)
question_8()
neutral_step_speciation(community,0.2)
neutral_generatirichnesson_speciation(community,species_rate)
neutral_time_series_speciation(community,speciation_rate,duration)
question_12()
species_abundance(c(1,5,3,6,5,6,1,1))
