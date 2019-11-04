# This function calculates heights of trees given distance of each tree 
# from its base and angle to its top, using  the trigonometric formula 
#
# height = distance * tan(radians)
#
# ARGUMENTS
# degrees:   The angle of elevation of tree
# distance:  The distance from base of tree (e.g., meters)
#
# OUTPUT
# The heights of the tree, same units as "distance"


#Define function
TreeHeight <- function(degrees, distance){
  radians <- degrees * pi / 180
  height <- distance * tan(radians)
  #print(paste("Tree height is:", height))

  return (height)
}

TreeHeight(30,40) # Tests the function out on two numbers

### Take file from command line
arg1 <- commandArgs(TRUE)
trees<-read.csv(paste("../data/",arg1[1], ".csv", sep=""))

h <- TreeHeight(trees$Angle.degrees, trees$Distance.m)
trees$Height <- h

### Write a new csv in the results directory with the original file name
write.csv(trees,paste ("../results/", arg1[1], ".csv", sep = ""), row.names = FALSE) 