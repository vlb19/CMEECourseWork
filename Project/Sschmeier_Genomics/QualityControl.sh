#!/bin/bash    

# Quality Control
###############################
### Learning outcomes
    # Describe the steps involved in pre-processing/cleaning sequence data 
    # Distinguish between a good and a bad sequencing run
    # Compute, investigate, and evaluate the quality of sequence data from a sequencing experiment 

################
### The data ###
################
# First we are going to download the data we will analyse. Open a shell/terminal

conda activate ngs

# Create a directory you work in 
mkdir analysis 

# Change into directory
cd analysis

# download the data 
curl -O http://compbio.massey.ac.nz/data/203341/data.tar.gz

# uncompress the data 
tar -xvzf data.tar.gz

############################
### Investigate the data ###
############################

## Use the command-line to get some ideas about the files

cd data # change directory into the new data folder
ls # list all items in directory

less evolved-6-R1.fastq.gz # open data file to view it
Q # exit data file

## What kind of files are we dealing with?

# 4 FASTQ files. Ancestral DNA and evolved DNA. Each has two reads (R1 and R2) for forward and reverse reads because the data is from paired-end Illumina sequencing. 

## How many sequence reads are in the file?

# convert FASTQ files to FASTA files
zcat ancestor-R1.fastq.gz | awk 'NR%4==1{printf ">%s\n", substr($0,2)}NR%4==2{print}' > ancestor-R1.fa
zcat ancestor-R2.fastq.gz | awk 'NR%4==1{printf ">%s\n", substr($0,2)}NR%4==2{print}' > ancestor-R2.fa
zcat evolved-6-R1.fastq.gz | awk 'NR%4==1{printf ">%s\n", substr($0,2)}NR%4==2{print}' > evolved-6-R1.fa
zcat evolved-6-R2.fastq.gz | awk 'NR%4==1{printf ">%s\n", substr($0,2)}NR%4==2{print}' > evolved-6-R2.fa

# visualise transformed data
head ancestor-R1.fa 

# count number of sequence IDs in file
AncestorR1reads=$(grep -c -o ">" ancestor-R1.fa)
AncestorR2reads=$(grep -c -o ">" ancestor-R2.fa)
EvolvedR1reads=$(grep -c -o ">" evolved-6-R1.fa)
EvolvedR2reads=$(grep -c -o ">" evolved-6-R2.fa)

## Assume a genome size of 12MB. Calculate the coverage based on this formula: C = LN / G 
    # C: coverage
    # G: haploid genome length in bp
    # L: read length in bp (e.g. 2x100 paired-end = 200)
    # N: number of reads sequenced

# Calculate average read length
zcat ancestor-R1.fastq.gz | awk 'NR%2==0' > ancestorcount-R1.fa #Remove sequence IDs and + character lines
awk 'NR%2==1' ancestorcount-R1.fa > ancestorcount2-R1.fa #Remove quality values
AncR1readlen=$(wc -m < ancestorcount2-R1.fa) #count number of characters

# calculate coverage
coverage=$((("$AncR1readlen"*"$AncestorR1reads")/(12*10^6)))


### Explain briefly what the quality value represents

""" A quality value is the probability that the base call it corresponds to is incorrect"""

###################################
### Sickle for dynamic trimming ###
###################################

## We are using a simple program 'Sickle' for dynamic trimming of our sequencing reads to remove bad quality called bases from our reads 

conda install sickle-trim

## Now we are going to run the program on our paired-end data

# Create a new directory
cd ..
mkdir trimmed

# sickle parameters: 
sickle --help

# as we are dealing with paired-end data, we will be using "sickle pe"
sickle pe --help

# run sickle on the ancestor
sickle pe -g -t sanger -f data/ancestor-R1.fastq.gz -r data/ancestor-R2.fastq.gz -o trimmed/ancestor-R1.trimmed.fastq.gz -p trimmed/ancestor-R2.trimmed.fastq.gz -s trimmed -s trimmed/ancestor-singles.trimmed.fastq.gz

# run sickle on the evolved samples
sickle pe -g -t sanger -f data/evolved-6-R1.fastq.gz -r data/evolved-6-R2.fastq.gz -o trimmed/evolved-6-R1.trimmed.fastq.gz -p trimmed/evolved-6-R2.trimmed.fastq.gz -s trimmed -s trimmed/evolved-singles.trimmed.fastq.gz

#######################################################
### Quality assessment of sequencing reads (FastQC) ###
#######################################################

conda install fastqc

# should now run the program 
fastqc --help

"""

    FastQC reads a set of sequence files and produces from each one a quality control report consisting of a number of different modules, each one of which will help to identify a different potential type of problem in your data.

    If no files to process are specified on the command line then the program will start as an interactive graphical application.  If files are provided on the command line then the program will run with no user interaction required.  In this mode it is suitable for inclusion into a standardised analysis pipeline.

"""
## FastQC is a very simple program to run that provides information about sequence read quality

# The basic command looks like: 
fastqc -o RESULT-DIR INPUT-FILE.[txt/fa/fq] ...

# -o RESULT -DIR is the directory where the result files will be written 
# INPUT-FILE.[txt/fa/fq] is the sequence file to analyse, can be more than one file

# The result will be a HTML page per input file that can be opened in a web browser 

### Run FastQC on the untrimmed and trimmed data
## Create a directory for the results -> trimmed-fastqc
mkdir trimmed-fastqc

## Run FastQC on all trimmed files
fastqc -o trimmed-fastqc trimmed/evolved-6-R1.trimmed.fastq.gz trimmed/evolved-6-R2.trimmed.fastq.gz trimmed/ancestor-R1.trimmed.fastq.gz trimmed/ancestor-R2.trimmed.fastq.gz

## Visit FastQC website and read about sequencing QC reports for good and bad Illumina sequencing runs 

## Compare your results to these examples of a particularly bad run and write down your observations with regards to your data 

""" 

The base statistics are all good. The per base sequence quality is good in all samples. The per tile sequence quality is bad in the forward reads but not the reverse strand. The per sequence quality scores are all good, as are the per base GC and N contents. The sequence length distributions are all bad. The sequence duplication levels, overrepresented sequences, and adapter content are all great. 

"""

## What elements in these example figures indicate that the example is from a bad run?

""" 
The sequence length distributions are not normally distributed, and are skewed towards long length reads. 

In the forward strands the per tile sequence quality graphics have at least one orange tile when the screen should be blue only. 

"""