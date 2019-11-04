#!/usr/bin/Rscript
# Brown Bears 

#####################################################################
# 1) Identify which positions are SNPs
#####################################################################

### read data
data <- read.csv("../data/bears.csv", stringsAsFactors = F, header = F)
dim(data)

### find SNPs and store positions into a variable called snps
snps <- c()
for (i in 1:ncol(data)){
    if(length(unique(data[,i]))==2) snps <- c(snps, i)
    }

View(snps)
#####################################################################
# 2) Calculate, print, and visualise allele frequencies for each SNP
#####################################################################

### Create a new dataframe with only alleles present 
bearalleles <- c()
for (position in snps){
    bearalleles <- cbind(bearalleles,data[,position])
}

for(x in 1:ncol(bearalleles)){



