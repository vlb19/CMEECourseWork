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

trees<-read.csv("../data/trees.csv", header = TRUE)

TreeHeight <- function(degrees, distance){
  radians <- degrees * pi / 180
  height <- distance * tan(radians)
  #print(paste("Tree height is:", height))

  return (height)
}

#TreeHeight(30,40)
h <- TreeHeight(trees$Angle.degrees, trees$Distance.m)
trees$Height <- h
write.csv(trees,"../results/TreeHts.csv")