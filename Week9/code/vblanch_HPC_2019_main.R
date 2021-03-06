#!/usr/bin/env Rscript

name <- "Victoria Blanchard"
preferred_name <- "Viki"
email <- "vlb19@ic.ac.uk"
username <- "vlb19"
personal_speciation_rate <- 0.002 # will be assigned to each person individually in class and should be between 0.002 and 0.007

rm(list = ls())
graphics.off()

##########################################
# Question 1 - Calculate species richness
species_richness <- function(community){
  
  # Count number of unique species in the community
  length(unique(community)) 
}

##########################################
# Question 2 - Generate initial state for your simulation community
init_community_max <- function(size){
  
  # Create vector sequence of length 'size'
  seq(size) 
}

##########################################
# Question 3 - Generate alternative initial state for simulation
init_community_min <- function(size){
  
  # Create a vector of length 'size' containing all 1s
  vec <- c(rep(1, size)) 
  return(vec)
}

##########################################
# Question 4 - Choose two random numbers between 1 and max_value
choose_two <- function(max_value){
  
  # From range 1:max_value, sample 2 numbers
  sample(1:max_value, 2) 
}

##########################################
# Question 5 - Perform a single step of a simple neutral model
neutral_step <- function(community){

  #store the two numbers generated by the choose_two function
  choices <- choose_two(length(community)) 
  #replace the number indexed by the first choice with the number indexed by the second choice
  community[choices[1]] <- community[choices[2]] 
  
  return(community)
}

##########################################
# Question 6 - Simulate several neutral_steps on a community so that a generation has passed 
neutral_generation <- function(community){
  #randomly round halved odd community sizes up or down
  steps = round(jitter(length(community)/2, amount = 0.1))
  for (i in 1:steps){
    # perform a neutral step on the community x/2 number of times
    community <- neutral_step(community) 
  }
  return(community)
}

##########################################
# Question 7 - run neutral theory simulation for duration number of generations
neutral_time_series <- function(community,duration)  {
  # Set empty richness vector
  richness <- c(species_richness(community)) 

  # For each generation run neutral_generation on the community
  for (generation in 1:duration) {
    community <- neutral_generation(community)
    r = species_richness(community)
    richness <- c(richness, r)
    } 

  # return species richness of the final community
  return(richness)
}

##########################################
# Question 8 Run the species model under certain conditions
question_8 <- function() {
  graphics.off() # clear any existing graphs and plot your graph within the R window
  x <- c()
  y <- c()
  duration = 200
  richness <- neutral_time_series(init_community_max(100),duration)
  for (i in 1:duration){
    y <- c(y, richness[i])
    x <- c(x, i)
  }
  plot(x,xlab = "Generation", y, ylab = "Species Richness", col = "magenta4", bg = "magenta2", pch = 22, lines(x,y))

  return("The system will always converge to 1 if you wait long enough. This is because impenetrable groups form and these spread across all connected groups until every individual is replaced by a single species.")
}

##########################################
# Question 9 - Perform a step of a neutral model with speciation
neutral_step_speciation <- function(community,speciation_rate)  {
  newspecies <- runif(1) # generate a random number between 0 and 1
  
  # if the random selection is above the speciation rate run the neutral step
  if (newspecies > speciation_rate) {
    community <- neutral_step (community)

  # otherwise replace an individual with a new species
  } else {
    #store the two numbers generated by the choose_two function
    choices <- choose_two(length(community)) 
    #replace the number indexed with new species ID (maximum number in the community and adding one)
    community[choices[1]] <- max(community)+1
  }
  return(community)                                                      
}

##########################################
# Question 10
neutral_generation_speciation <- function(community,speciation_rate)  {
  #randomly round halved odd community sizes up or down
  steps = round(jitter(length(community)/2, amount = 0.1))
  for (i in 1:steps){
    # perform a neutral step on the community x/2 number of times
    community <- neutral_step_speciation(community,speciation_rate)
  }

  return(community)
}
  
##########################################
# Question 11
neutral_time_series_speciation <- function(community,speciation_rate,duration)  {
  # Set empty richness vector
  richness <- c(species_richness(community)) 

  # For each generation run neutral_generation on the community
  for (generation in 1:duration) {
    community <- neutral_generation_speciation(community, speciation_rate)
    r = species_richness(community)
    richness <- c(richness, r)
    } 

  # return species richness of the final community
  return(richness)
}

##########################################
# Question 12
question_12 <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()

  #set initial conditions
  speciation_rate = 0.1
  duration = 200
  
  # run a neutral theory simulation
  richnessmax <- neutral_time_series_speciation(init_community_max(100), speciation_rate, duration)
  richnessmin <- neutral_time_series_speciation(init_community_min(100), speciation_rate, duration)
  
  # plot two time series on the same axis
  x <- c(0:duration) #set generation on x axis
  plot(x,xlab = "Generation", richnessmax, ylab = "Species Richness", ylim=c(0,100), col = "magenta4", bg = "magenta2", pch = 22, type = 'l')
  lines(richnessmin, col="blue")
  
  return("Highly diverse communities lose richness over time as speciation replaces unique existing species with new species. Communities with low diversity gain species richness over time as common species are replaced by unique species. Over many generations the richness tends towards the same equilibrium in both as both are gaining or loosing species richness as a function of speciation rate. Eventually all of the species in the origninal commnunities will have been replaced with new species and so the richness will tend towards the same equilibrium dictated by the probability of speciation. A high probability of speciation  will give a high value of equilibrated species richness. ")
}

##########################################
# Question 13 - tell you what the species abundances are
species_abundance <- function(community)  {
  table <- table(community) # store unique identities in first row and counts in second row
  sort(table, decreasing = TRUE) # sort by decreasing abundance of each species
  
}

##########################################
# Question 14
octaves <- function(abundance_vector) {
  # Take a log2 value of the abundance vector
  # Add 1 to this to account for the presence of zeros
  # Round to the lower integer 
  # Bin these values
  tabulate(floor(log2(abundance_vector))+1)
}

##########################################
# Question 15
sum_vect <- function(x, y) {
  # sum two vectors (x and y) after making both vectors
  # the same length
  diff <- length(x)-length(y)
  if (diff > 0) {
    y <- c(y, rep(0, abs(diff))) }
  if (diff < 0) {
    x <- c(x, rep(0, abs(diff))) }
  vector_sum <- x + y
  return(vector_sum)
}

##########################################
# Question 16 
question_16 <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()

  #Set starting values for temporary variables
  richnessmax <- init_community_max(100)
  richnessmin <- init_community_min(100)
  speciation_rate = 0.1
  duration = 200
  generations = 2000
  counter = 0
  
      # Run neutral model for a 'burn in' period of 200 generations
      for (i in 1:duration) {
        richnessmax <- neutral_generation_speciation(richnessmax, speciation_rate)
        richnessmin <- neutral_generation_speciation(richnessmin, speciation_rate)
      }

      #Record species abundance octave vectors
      octavesmin <- octaves(species_abundance(richnessmin))
      octavesmax <- octaves(species_abundance(richnessmax))
      
      #Continue simulation for a further 2000 generations
      for (x in 1:generations) {
        richnessmax <- neutral_generation_speciation(richnessmax, speciation_rate)
        richnessmin <- neutral_generation_speciation(richnessmin, speciation_rate)
        # store octave values every 20 generations
        if (x%%20 == 0) {
          counter = counter+1 #set a counter for each iteration
          octavesmin <- sum_vect(octavesmin, octaves(species_abundance(richnessmin)))
          octavesmax <- sum_vect(octavesmax, octaves(species_abundance(richnessmax)))
          }
      }
      # Calculate average octaves
      averagemaxoctaves <- octavesmax/counter
      averageminoctaves <- octavesmin/counter

      # Plot bar charts of average octaves for communities initialised with
      # maximum and minimal diverstiy
      par(mfrow=c(1,2))
      barplot(averagemaxoctaves,generations)
      barplot(averageminoctaves,generations)
      
  return ("The initial condition does not matter for the final outcome because after the initial burn-in period (excluded here) both populations tend towards the same octave number. We could summise this would happen from the results of question 12")
}

##########################################
# Question 17
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name)  {
  # Initialise community with size given by the input 'size' and minimal diversity
  community <- init_community_min(size)
  # Set counter to zero 
  counter = 0
  
  #save start time and current times as vectors in minutes
  start_time <- proc.time()[3]/60
  current_time <- proc.time()[3]/60
  
  #Apply neutral generations for a predefined amount of time (wall_time)
  while ((current_time-start_time) < wall_time) {
    
    #Apply neutral generations to community
    richness <- neutral_generation_speciation(community, speciation_rate)
    #Record species abundance at the first time step
    SpeciesAbundance <- list(octaves(species_abundance(richness)))
    
    #Run neutral model over the burn-period (burn_in_generations)
    for (generation in 1:burn_in_generations){
      #Record number of generations in the burn in
      counter = counter+1
      
      #Store the species richness at intervals of interval_rich
      if (generation %% interval_rich == 0){
        richness <- neutral_generation_speciation(richness, speciation_rate)
      }
      # Store speices abundances during the burn-in period as octaves 
      # Every interval_oct generations
      if (generation %% interval_oct == 0){
        SpeciesAbundance[length(SpeciesAbundance)+1] <- list(octaves(species_abundance(richness)))
      }
        
    #Record the species abundances as octaves every interval_oct generations
    #outside of the burn-in period
   if (generation %% interval_oct == 0){
    richness <- neutral_generation_speciation(community, speciation_rate)
    SpeciesAbundance[length(SpeciesAbundance)+1] <- list(octaves(species_abundance(richness)))
   }
    current_time <- proc.time()[3]/60
    }
  }
  #Save data to rda file 
  save(counter, SpeciesAbundance,richness,speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, file = output_file_name)
    
  }

##########################################
# Questions 18 and 19 involve writing code elsewhere to run your simulations on the cluster

##########################################
# Question 20 
process_cluster_results <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  # Initialise global variables to store running totals for each community size
  VectorTotal500 <- 0
  VectorTotal1000 <- 0
  VectorTotal1500 <- 0
  VectorTotal2000 <- 0 
  
  #Initialise generation counters for each community size
  TotalTime500 <- 0
  TotalTime1000 <- 0
  TotalTime1500 <- 0
  TotalTime2000 <- 0
  
  # Create a list of all the iter file names within the directory
  file_list <- list.files(pattern = "NR\\_[[:digit:]][[:digit:]][[:digit:]].rda$")
  # load each file 
  for (each_file in 1:length(file_list)){
    load(file = file_list[each_file])
    
    #Find the correct row index for the first generation after the burn-in period
    cutpoint <- ceiling(burn_in_generations/interval_oct) 
    #Create a new dataframe excluding the burn-in time
    afterburnspeciesabundance <- SpeciesAbundance[c(cutpoint:length(SpeciesAbundance))]
    
    if (size == 500){
      # Sum all the rows in the new vector
      for (row in afterburnspeciesabundance){
        VectorTotal500 <- sum_vect(VectorTotal500,row)
      }
      # Save total time for this file into the global variable
      TotalTime500 <- TotalTime500 + length(afterburnspeciesabundance)
    }
    
    else if (size == 1000){
      # Sum all the rows in the new vector
      for (row in afterburnspeciesabundance){
        VectorTotal1000 <- sum_vect(VectorTotal500,row)
      }
      # Save total time for this file into the global variable
      TotalTime1000 <- TotalTime1000 + length(afterburnspeciesabundance)
    }
    
    else if (size == 1500){
      # Sum all the rows in the new vector
      for (row in afterburnspeciesabundance){
        VectorTotal1500 <- sum_vect(VectorTotal500,row)
      }
      # Save total time for this file into the global variable
      TotalTime1500 <- TotalTime1500 + length(afterburnspeciesabundance)
    }
    
    else if (size == 2000){
      # Sum all the rows in the new vector
      for (row in afterburnspeciesabundance){
        VectorTotal2000 <- sum_vect(VectorTotal2000,row)
      }
      # Save total time for this file into the global variable
      TotalTime2000 <- TotalTime2000 + length(afterburnspeciesabundance)
    }
    
    else {print("Something has gone wrong somewhere")}
    
    # Calculate average octave vectors for each community size
    averageoctaves500 <- VectorTotal500/TotalTime500
    averageoctaves1000 <- VectorTotal1000/TotalTime1000
    averageoctaves1500 <- VectorTotal1500/TotalTime1500
    averageoctaves2000 <- VectorTotal2000/TotalTime2000
  }
  
  # Plot four bar graphs in a multi-panel graph 
  par(mfrow=c(2,2))
  barplot(averageoctaves500, main = "Community Size = 500", names.arg=1:length(averageoctaves500), ylab= "Octave Abundance", xlab = "Octave bins")
  barplot(averageoctaves1000, main = "Community Size = 1000", names.arg=1:length(averageoctaves1000), ylab= "Octave Abundance", xlab = "Octave bins")
  barplot(averageoctaves1500, main = "Community Size = 1500", names.arg=1:length(averageoctaves1500), ylab= "Octave Abundance", xlab = "Octave bins")
  barplot(averageoctaves2000, main = "Community Size = 2000", names.arg=1:length(averageoctaves2000), ylab= "Octave Abundance", xlab = "Octave bins")
  
  # Create a list of the four octave outputs plotted on the graphs in order of increasing community size
  combined_results <- list(averageoctaves500, averageoctaves1000, averageoctaves1500, averageoctaves2000) 
  return(combined_results)
}

##########################################
# Question 21
question_21 <- function()  {
  
  # Dimension = log of the number of pieces divided by the magnification
  FractalDimension2D <- log(8)/log(3)
  
  return("There are 8 repeats of the core pattern shown in this fractal, meaning N = 8. If we were to zoom out of the picture, you would need to repeat this fractal three times to make a single line. The length of one side goes from one to three meaning that M = 3. If we put those numbers into the fractal dimension equation we get the answer 1.893")
}

##########################################
# Question 22
question_22 <- function()  {
  
  # Dimension = log of the number of pieces divided by the magnification
  FractalDimension3D <- log(20)/log(3)

  return("20 cubes make up this 3D shape, making the number of pieces equal to 20. The length increases by three the same as before so M = 3. If we put these into the fractal dimension equation we get an answer of 2.727")
}

##########################################
# Question 23
chaos_game <- function()  {
  # clear any existing graphs and plot your graph within the R window
  dev.off
  
  # Store point vectors for points A, B, and C
  A = c(0,0)
  B = c(3,4)
  C = c(4,1)
  
  # Initialise the point vector "X" at (0,0)
  X = c(0,0)
  
  # Plot x on an empty graph with the axis limits at 4
  plot(1, type = "n", xlab="", ylab="", xlim = c(0,4), ylim= c(0,4), main = "The Sierpinski Triangle", axes=FALSE)
  
  # Change the value of X and re-plot it 10,000 times
  for (i in 1:100000){
    # Plot a very small point at X's coordinates
    points(X[1],X[2], cex=0.01)
    
    # Save A, B, and C to a list
    PointsVariable <- list(A, B, C)
    
    # Choose eiher A, B, or C
    plotpoint <- sample(1:3, size = 1)
    
    # Retrieve the value of the selected point, add it to X and divide the result
    # by two to get a coordinate halfway between X and the point,
    # then overwrite the value of X to this result
    X <-(PointsVariable[[plotpoint]]+X)/2
  }
  return("This plots the Sierpinski Triangle")
}

##########################################
# Question 24
turtle <- function(start_position, direction, length)  {
  # Start_position is a coordinate, direction is an angle in radians, and length is 
  # length of line between start and end position
  
  # Initialise empty vector to store endpoint coordinates
  endposition <- c()
  
  # Calculate endpoint coordinates:
    # Method: start_position -> endposition (XY) is the hypotenuse of a right angled triangle.
    # The length of XY multiplied by cos (direction) will give the length of the adjacent side
    # Adding this length to the x value of X will give you the x value of Y
    # Length of XY * sin (direction) will give you the length of the opposite line
    # Adding this length to the y value of X will give you the y value of Y
  endposition[1] = as.numeric(start_position[1]) + (length * cos(direction))
  endposition[2] = as.numeric(start_position[2]) + (length * sin(direction))
  
  # save coordinates of start and end position to a new vector
  line <- cbind(start_position, endposition)
  
  # Plot line segments between coordinate pairs
  # segments(start_position[1], endposition[1], start_position[2], endposition[2])
  lines(line[1,], line[2,])
  
  return(endposition)
}

##########################################
# Question 25
elbow <- function(start_position, direction, length)  {
  
  #Call turtle once to plot the first line, then store the end position coordinates
  endposition <- turtle(start_position, direction, length)
  
  #Call turtle again to plot the second line using the end position coordinates from 
  # the first plot as the new start coordinates, changing the angle of the line by 45
  # degrees and reducing the length of the second line to 95% of the first line
  turtle(endposition, direction - (pi / 4), 0.95*length)

}

##########################################
# Question 26
spiral <- function(start_position, direction, length)  {
  
  #Call turtle once to plot the first line, then store the end position coordinates
  endposition <- turtle(start_position, direction, length)
  
  #Set a limit to the line length
  if (length > 0.05){
    # call this function within itself to plot subsequent lines, adjusting the 
    # angle by 45 degrees with each plot and reducing the line length by 5% each time
    spiral(endposition, direction - (pi / 4), length <- 0.95*length)
  }
  
  return("You get a spiral but it comes back with an error message saying 7970404 is too close to the limit. This is because the graph is trying to plot a line whose length is too small for R to plot (i.e. the line length is too close to the lower limit that R is able to plot)")
}

##########################################
# Question 27
draw_spiral <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  # Create an empty plot with axis limits set at 5 
  plot(1, type = "n", xlab="", ylab="", xlim = c(0,5), ylim= c(0,5), axes=FALSE)
  
  # Call the spiral function with starting values to plot the spiral 
  spiral(start_position = c(1,1), direction = pi / 2, length = 1.5)
}

##########################################
# Question 28
tree <- function(start_position, direction, length)  {
  
  #Call turtle once to plot the first line, then store the end position coordinates
  endposition1 <- turtle(start_position, direction, length)
  
  #Set the limit of the line length
  if (length > 0.05){
    
    # Plot the first spiral rotating clockwise, reducing the length by 35% for each 
    # subsequent line
    tree(endposition1, direction - (pi / 4), 0.65*length)
    
    # For each point, plot the same thing mirrored giving double the number of 
    # end positions
    tree(endposition1, direction + (pi / 4), 0.65*length)
    
    # Repeat the loop up to the limit of the line length 
  }
}

draw_tree <- function()  {
  
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  # Create an empty plot with axis limits set to 50
  plot(1, type = "n", xlab="", ylab="", xlim = c(0,50), ylim= c(0,50), axes=FALSE)
  
  # Call the tree function with starting values
  tree(start_position = c(25,0), direction = (pi / 2), length = 15)
}

##########################################
# Question 29
fern <- function(start_position, direction, length)  {
  
  #Call turtle once to plot the first line, then store the end position coordinates
  endposition1 <- turtle(start_position, direction, length)
  
  #Set the limit of the line length
  if (length > 0.08){
    # Plot the fractal curving to the right, reducing the line length by 62% each plot
    fern(endposition1, direction - (pi / 4), 0.38*length)
    # For each point draw a vertical line, reducing the line length by 13% each plot
    fern(endposition1, direction, 0.87*length)
  }
}

draw_fern <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  # Create an empty plot with the y axis limit set to 120, and the x axis
  # limit set to 50. The plot will be taller than it is wide. 
  plot(1, type = "n", xlab="", ylab="", xlim = c(0,50), ylim= c(0,120), axes=FALSE)
  
  # Call the fern function with starting values 
  fern(start_position = c(0,0), direction = (pi / 2), length = 15)
}

##########################################
# Question 30
fern2 <- function(start_position, direction, length, dir)  {

  #Call turtle once to plot the first line, then store the end position coordinates
  endposition1 <- turtle(start_position, direction, length)
  
  #Set the limit of the line length
  if (length > 0.5){
    
    # Plot the fractal to the right or left depending on the direction
    fern2(endposition1, direction = direction - (pi / 4) *dir, 0.38*length, dir)
    
    # Plot a straight line following the direction from which the fractal branches
    fern2(endposition1, direction, 0.87*length, dir = dir * -1)
  }
}

draw_fern2 <- function()  {
  # Clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  # Create an empty plot with the x axis limit set to 60 and the y axis limit set to 120
  plot(1, type = "n", xlab="", ylab="", xlim = c(0,60), ylim= c(0,120), axes=FALSE)
  
  # Call the fern function with starting values
  fern2(start_position = c(25,0), direction = (pi / 2), length = 15, dir=1)
}

##########################################
# Challenge question A
Challenge_A <- function() {
  # clear any existing graphs and plot your graph within the R window
}

##########################################
# Challenge question B
Challenge_B <- function() {
  # clear any existing graphs and plot your graph within the R window
}

##########################################
# Challenge question C
Challenge_C <- function() {
  # clear any existing graphs and plot your graph within the R window
}

##########################################
# Challenge question D
Challenge_D <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

##########################################
# Challenge question E
Challenge_E <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

##########################################
# Challenge question F - This plot takes less than a minute to run
Challenge_F <- function() {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  # Set starting parameters
  start_position = c(5,0) 
  direction = (pi / 2) 
  length = 3
  dir=1
  
  # Set the line length limits we want to iterate through 
  maxlengths = c(rev(seq(0.01, 2, by=0.05)))
  
  # Define new fern function with a changeable length limit
  fern3 <- function(start_position, direction, length, dir, lengthlimit)  {
    
    #Call turtle once to plot the first line, then store the end position coordinates
    endposition1 <- turtle(start_position, direction, length)
    
    #Set the limit of the line length
    if (length > lengthlimit){
      
      # Plot the fractal to the right or left depending on the direction
      fern3(endposition1, direction = direction - (pi / 4) *dir, 0.38*length, dir, lengthlimit)
      
      # Plot a straight line following the direction from which the fractal branches
      fern3(endposition1, direction, 0.87*length, dir = dir * -1, lengthlimit)
    }
  }
  
  # Initialise the plot
  plot(1, type = "n", xlab="", ylab="", xlim = c(0,12), ylim= c(0,23), axes=FALSE)
  
  # Define new function to plot a single iteration of the length limit variable
  Singleframe <- function(maxlength, length){
    #for (x in maxlengths){
    # Call the new fern function with some starting values
    fern3(start_position,direction, length, 1, maxlength)
  }

  # Create an animated plot to show the effect of changing line length on the plot
  for (x in maxlengths) {
    if (x > 0.1){
      # create a lag between one plot an the next to make an animation
      Sys.sleep(0.5)
      # plot the fern 
      Singleframe(x, length)
      
    # To allow the system time to plot the new fractal we need to increase the lag 
    # between frames. When the line limit is above 0.05 the lag is increased to 5 seconds
    } else if (x > 0.05) { 
      Sys.sleep(5)
      Singleframe(x, length)
    
    # For the last plot the lag is increased to 10 seconds
    } else {
      Sys.sleep(10)
      Singleframe(x, length)
    }
      
  }


  
  return("Generally, the complexity of the fractal (or the bushyness of the fern) decreases the higher the value of the length limit although small changes do not have a great impact when the length limit is very large (shown by the gradual thickening of the line in the first stages of the tree). The time taken to plot also increases with the decreasing size of the line limit (shown by the slowing of the plot towards the end of the animation). This is because the dimensions of the fractal are increasing with decreasing size of line limit, R is plotting more lines and therefore takes longer to generate the graph.")
}

##########################################
# Challenge question G should be written in a separate file that has no dependencies on any functions here.

