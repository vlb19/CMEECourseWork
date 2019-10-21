rm(list=ls()) #clear workspace

d<-read.table("SparrowSize.txt", header=TRUE)
str(d)

names(d) #column headings

head(d) # first 6 data sets

length(d$Tarsus)

hist(d$Tarsus)

"""Centrality, mean, median, and mode in normally distributed data"""

mean(d$Tarsus)
## returns error message because of NAs in data

help(mean)
mean(d$Tarsus, na.rm = TRUE)
median(d$Tarsus, na.rm = TRUE)
mode(d$Tarsus) #returns "numeric" because dataset is continuous so most frequently occuring value

par(mfrow = c(2,2)) #sets up a workspace which will fit 4 graphs
hist(d$Tarsus, breaks = 3, col="grey")
hist(d$Tarsus, breaks = 10, col="pink")
hist(d$Tarsus, breaks = 30, col="green")
hist(d$Tarsus, breaks = 100, col ="blue")
#Number of breaks determines number of bins used to draw the histogram, at some point the resolution is larger than the resolution of the measuring device

install.packages("modeest") # can't download this package
?modeest
mlv(d$Tarsus)

d2<-subset(d, d$Tarsus!="NA")
length(d$Tarsus)

mean(d$Wing, na.rm = TRUE)
median(d$Tarsus, na.rm = TRUE)

range(d$Tarsus, na.rm = TRUE)
range(d2$Tarsus, na.rm= TRUE)
var(d$Wing, na.rm = TRUE)
var(d2$Wing, na.rm = TRUE)

par(mfrow = c(2,2))
sd(d$Wing, na.rm=TRUE)