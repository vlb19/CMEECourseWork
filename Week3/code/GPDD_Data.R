# Map of world with points 
rm(list=ls()) # clears the workspace
load("../data/GPDDFiltered.RData")
library("maps")

map(database = "world")

points(gpdd$long,gpdd$lat,pch=16,col="darkred")

## Expected biases from results:
## Bias towards northern hemisphere and colder climates