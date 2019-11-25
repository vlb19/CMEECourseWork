#!/usr/bin/env Rscript

# Plots log(field metabolic rate) against log(body mass) for the Nagy et al 
# 1999 dataset to a file fmr.pdf.

cat("Reading CSV\n") #print "Reading CSV" and a new line

nagy <- read.csv('../data/NagyEtAl1999.csv', stringsAsFactors = FALSE) # reading in the data without converting strings to factors

cat("Creating graph\n") # print "Creating graph" and a new line
pdf('../results/fmr_plot.pdf', 11, 8.5) # opens a pdf to plot graph into with a width of 11 inches and a height of 8 inches
col <- c(Aves='purple3', Mammalia='red3', Reptilia='green3') # assigning colours to variables
# plotting log 10 scaled data from nagy with point size of 19
plot(log10(nagy$M.g), log10(nagy$FMR.kJ.day.1), pch=19, col=col[nagy$Class], 
     xlab=~log[10](M), ylab=~log[10](FMR)) # labelling x and y axis

for(class in unique(nagy$Class)){ #for each different class in the nagy class column 
    model <- lm(log10(FMR.kJ.day.1) ~ log10(M.g), data=nagy[nagy$Class==class,]) #fit linear regression to nagy data
    abline(model, col=col[class]) #plot line from the model with a colour that corresponds to the class (assigned in line 10)
}
dev.off() # closes the pdf

cat("Finished in R!\n Graph saved in results folder \n") 
