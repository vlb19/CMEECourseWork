# Computes the correlation coefficients between successive years in KeyWest Data

rm(list=ls()) # clears the workspace

load("../data/KeyWestAnnualMeanTemperature.RData")
ls()
library("ggplot2")

Year <- ats$Year
Temp <- ats$Temp
ggplot(ats, aes(x=Year, y = Temp)) + geom_point(size=2, shape=23)

ats$sucyear <- ats$Temp
shift1 <- function(x, n) `length<-`(tail(x, -n), length(x))
ats<-transform(ats,sucyear = shift1(sucyear, 1))
ats1 <- ats[-nrow(ats),]

ogcorrelation <- cor(ats1$Temp,ats1$sucyear,method = "pearson")
correlations <- vector()
replicates = 10000

for (i in 1:replicates){
  randomtemps <- data.frame(matrix(nrow=100, ncol=2))
  randomtemps$X1 <- sample(ats$Temp)
  randomtemps$X2 <- randomtemps$X1
  randomtemps <- transform(randomtemps,X2 = shift1(X2, 1))
  randomtemps <- randomtemps[-nrow(randomtemps),]
  correlations <- append(correlations, cor(randomtemps$X1,randomtemps$X2,method = "pearson"))

}
count = 0 
for (x in correlations) {
  if (x > ogcorrelation) {
    count = count+1
  }
}

  plot(correlations) +
    points(ogcorrelation, col = "red")


fraction <- count/replicates
print(fraction)
