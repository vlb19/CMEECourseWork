#!/bin/bash    

# Tool installation
#########################################
### Install the conda package manager ###
#########################################

# download the latest conda installer
curl -0 https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

# run the installer
bash Miniconda3-latest-Linux-x86_64.sh

# delete the installer after successful run
rm Miniconda3-latest-Linux-x86_64.sh

### Update .bashrc and .zshrc config-files 
# Before we are able to use conda we need to tell our shell 
# where it can find our program. We add the right path to 
# the conda installation to our shell config files

echo 'export PATH="/home/vlb19/miniconda3/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="/home/vlb19/miniconda3/bin:$PATH"' >> ~/.zshrc

# We are appending a line to a file (either .bashrc or .zshrc). If we are starting a new command-line shell, either file gets executed first (depending on whether you are using either bash or zsh shells). 

# This line permenantly puts the directory ~/miniconda3/bin first on your path variable 

# Update conda 

conda update conda 

### Installing conda channels to make tools available

# Different tools are packaged in what conda calls channels. We need to add some channels to make the bioinformatics and genomics tools available for installation 

# Install some conda channels
# A channel is where conda looks for packages 

conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

###########################
### Create environments ###
###########################

# We create a conda environment for some tools. This is useful to work reproducible as we can easily recreate the tool set with the same version numbers later on. 

conda create -n ngs python=3 
# activate the environment
conda activate ngs 

# The PATH variable gets temporarily manipulated here so it will look first in your environment's bin directory but afterwards in the general conda bin directory

### Install software
# To install software into the activated environment, one uses the command conda install 

# Install more tools into the environment
conda install package 

# To tell if you are in the correct conda environment, look at the command-prompt. If the name of the environment is in round brackets at the very beginning of the prompt you're fine, otherwise activate the environment using conda activate environmentname before installing the tools 

##############################
### General conda commands ###
##############################

# to search for packages 
conda serarch [package]

# to updata all packages 
conda update --all --yes 

# List all packages installed
conda list [-n env]

# conda list environments 
conda env list 

# conda create new environment
conda create -n [name] package [package] ...

# activate env 
conda activate [name]

# deactivate env 
conda deactivate




