#!/bin/bash    

# Genome assembly
###############################
# Learning outcomes
    # Compute and interpret a whole genome assembly 
    # Judge the quality of a genome assembly 

#########################
### Subsampling reads ###
#########################

# Due to the size of the data sets you may find that assembly takes a lot of time to complete, especially on older hardware. To mitigate this problem we can randomly select a subset of sequences we are going to use at this stage of the tutorial. To do this we install another program

conda activate ngs 
conda install seqtk

# Now that seqtk has been installed, we are going to sample 10% of the original reads

# change directory
cd analysis

# create directory 
mkdir sampled

# sub sample reads
seqtk sample -s11 trimmed/ancestor-R1.trimmed.fastq.gz 0.1 | gzip > sampled/ancestor-R1.trimmed.fastq.gz

seqtk sample -s11 trimmed/ancestor-R2.trimmed.fastq.gz 0.1 | gzip > sampled/ancestor-R2.trimmed.fastq.gz

# the '-s' options need to be the same value for file 1 and file 2 to sample the reads that belong to each other. It specifies the seed value for the random number generator 

# It should be noted that by reducing the number of reads that go into the assembly, we are loosing information that could otherwise be used to make the assembly. Thus the assembly will be likely "much" worse than when using the complete dataset 

##################################
### Creating a genome assembly ###
##################################

# We want to create a genome assembly for our ancestor. We are going to use the quality trimmed forward and backward DNA sequences and use a program called SPAdes to build a genome assembly. 

## Discuss briefly why we are using the acestral sequences to create a reference genome as opposed to the evolved line

""" 



"""

###############################
### SPAdes usage ###
###############################

### Installing the software
conda activate ngs
conda install spades

# Create an output directory
mkdir assembly

# to get help for SPAdes and an overview of the parameter type: 
spades.py -h

## Run SPAdes with default parameters on the ancestor
# The two files we need to submit to SPAdes are two paired-end read files
spades.py -o assembly/spades-default/ -1 trimmed/ancestor-R1.trimmed.fastq.gz -2 trimmed/ancestor-R2.trimmed.fastq.gz

## Read in the SPAdes manual about assembling with 2x150bp reads

""" 

Recent advances in DNA sequencing technology have led to a rapid increase in read length. Nowadays, it is a common situation to have a data set consisting of 2x150 or 2x250 paired-end reads produced by Illumina MiSeq or HiSeq2500. However, the use of longer reads alone will not automatically improve assembly quality. An assembler that can properly take advantage of them is needed.

SPAdes use of iterative k-mer lengths allows benefiting from the full potential of the long paired-end reads. Currently one has to set the assembler options up manually, but we plan to incorporate automatic calculation of necessary options soon.

Please note that in addition to the read length, the insert length also matters a lot. It is not recommended to sequence a 300bp fragment with a pair of 250bp reads. We suggest using 350-500 bp fragments with 2x150 reads and 550-700 bp fragments with 2x250 reads.

Multi-cell data set with read length 2x150

Do not turn off SPAdes error correction (BayesHammer module), which is included in SPAdes default pipeline.

If you have enough coverage (50x+), then you may want to try to set k-mer lengths of 21, 33, 55, 77 (selected by default for reads with length 150bp).

Make sure you run assembler with the --careful option to minimize number of mismatches in the final contigs.

We recommend that you check the SPAdes log file at the end of the each iteration to control the average coverage of the contigs.

"""

## Run SPAdes a second time but use the option suggested at the SPAdes manual section 3.4 for assembling 2x150bp paired-end reads (are fungi multicellular?). Use a different output directory 'assembly/spades-150' for this run 

spades.py -k 21,33,55,77 --careful --only-assembler -1 trimmed/ancestor-R1.trimmed.fastq.gz -2 trimmed/ancestor-R2.trimmed.fastq.gz -o assembly/spades-150/

###########################
### Assembly Statistics ###
###########################

# Quast (QUality ASessment Tool) evaluates genome assemblies by computing various metrics including: 
    # N50: length for which the collection of contigs of that length or longer covers at least 50% of assembly length 
    # NG50: where length of the reference genome is being covered
    # NA50 and NGA50: where aligned blocks instead of contigs are taken
    # Missassemblies: missembled and unaligned contigs or contigs bases
    # genes and operons covered 

# It is easy with Quast to compare these measures among several assemblies

conda install quast

# Run Quast with both assembly scaffolds.fasta files to compare the results

quast -o assembly/quast assembly/spades-default/scaffolds.fasta assembly/spades-150/scaffolds.fasta

## Compare the results of Quast with regards to the two different assemblies

## Which do you prefer and why?

## Run the same command used on the trimmed data on the original untrimmed data
spades.py -k 21,33,55,77 --careful --only-assembler -1 data/ancestor-R1.fastq.gz -2 data/ancestor-R2.fastq.gz -o assembly/spades-150/

## Run Quast on the assembly and compare the statistics to the one derived for the trimmed data set. Write down your observations. 
spades.py -o assembly/spades-150/ -k 21,33,55,77 --careful -1 trimmed/ancestor-R1.trimmed.fastq.gz -2 trimmed/ancestor-R2.trimmed.fastq.gz
spades.py -o assembly/spades-original/ -k 21,33,55,77 --careful -1 data/ancestor-R1.fastq.gz -2 data/ancestor-R2.fastq.gz

# Rename your assembly directory spades_final
mkdir spades_final
mv assembly/spades-default assembly/spades_final

