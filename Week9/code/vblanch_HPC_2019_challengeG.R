# CMEE 2019 HPC excercises R code challenge G proforma

rm(list=ls()) # nothing written elsewhere should be needed to make this work

name <- "Victoria Blanchard"
preferred_name <- "Viki"
email <- "vlb19@ic.ac.uk"
username <- "vlb19"

# don't worry about comments for this challenge - the number of characters used will be counted starting from here

turtle <- function(start_position, direction, length)  {
  endposition <- c()
  endposition[1] = as.numeric(start_position[1]) + (length * cos(direction))
  endposition[2] = as.numeric(start_position[2]) + (length * sin(direction))
  
  line <- cbind(start_position, endposition)
  lines(line[1,], line[2,]) }

fern2 <- function(start_position, direction, length, dir)  {
  endposition1 <- turtle(start_position, direction, length)
  if (length > 0.05){
    fern2(endposition1, direction = direction - (pi / 4) *dir, 0.38*length, dir)
    fern2(endposition1, direction, 0.87*length, dir = dir * -1)
  }
}
plot.new()
fern2(c(25,0), (pi / 2), 15, 1)



