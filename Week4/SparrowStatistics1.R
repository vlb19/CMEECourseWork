getwd()#Check which working directory we're in 
setwd("home/vlb19/Documents/CMEECourseWork/Week4") #Re-set working directory to Week4 folder
getwd() #check that what we did worked

2*2+1
## [1] 5

2*(2+1)
## [1] 6

12/2^3
## [1] 1.5

(12/2)^3
## [1] 216

x <- 5 
x
## [1] 5

y <- 2
y
## [1] 2

x2 <- x^2
x2
## [1] 25

x
## [1] 5

a <- x2+x2
a
## [1] 30

y2 <- y^2
z2 <- x2 + y2
z <- sqrt(z2)
## [1] 5.385165

3>2 
## [1] TRUE

3>=3
## [1] TRUE

4 < 2
## [1] FALSE

myNumericVector <- c(1.3, 2.5, 1.9, 3.4, 5.6, 1.4, 3.1, 2.9)
myCharacterVector <- c("low","low","low","low","high","high","high","high")
myLogicalVector <- c(TRUE, TRUE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE)

str(myNumericVector)
##    num  [1:8]  1.3  2.5  1.9  3.4  5.6  1.4  3.1  2.9 	

str(myCharacterVector)
##  chr  [1:8]  "low"  "low"  "low"  "low"  "high"  "high"  "high"  ... 

str(myLogicalVector)
##    logi  [1:8]  TRUE  TRUE  FALSE  FALSE  TRUE  TRUE  ... 	

myMixedVector <- c(1, TRUE, FALSE, 3, "help",1.2, TRUE, "notwhatIplanned")
str(myMixedVector)
##    chr  [1:8]  "1"  "TRUE"  "FALSE"  "3"  "help"  "1.2"  "TRUE"  ... 	
install.packages("lme4")
library(lme4)
require(lme4)

help(getwd)
help(log)

sqrt(4); 4^0.5; log(0); log(1); log(10); log(Inf)
##  [1]  2 	
##  [1]  2 	
##  [1]  -­‐Inf 	
##  [1]  0 	
##  [1]  2.302585
##  [1]  Inf 	

exp(1)
##  [1]  2.718282 	
  
pi 	
##  [1]  3.141593

rm(list=ls())

d <- read.table("SparrowSize.txt", header=TRUE)
str(d)