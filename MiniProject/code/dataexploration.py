#!/usr/bin/env python3

""" Exploring Functional Responses data set
"""

__appname__ = 'dataexploration.py'
__author__ = 'Viki Blanchard (vlb19@ic.ac.uk)'
__version__ = '0.0.1'

# Some imports to explore the datasets
import pandas as pd
import numpy as np

#########################################################
### Load in data ###
#########################################################

# Import data into python 
data = pd.read_csv("../data/CRat.csv")

##########################################################
### Data preparation ###
##########################################################

### Create new data frame with only columns of interest for initial plots
newdata = data[['ID','ResDensity','N_TraitValue','Habitat','Res_MovementDimensionality', 'Con_MovementDimensionality', 'ConTaxa','ResTaxa']].copy()
#newdata = pd.DataFrame([data.ID,data.ResDensity,data.N_TraitValue,data.Habitat,data.Res_MovementDimensionality, data.Con_MovementDimensionality, data.ConTaxa,data.ResTaxa]).transpose()


### Modify the taxa to include only genus 
newdata['ConTaxa'] = newdata['ConTaxa'].str.split().str[0]
newdata['ResTaxa'] = newdata['ResTaxa'].str.split().str[0]

### Remove any IDs containing NA values
newdata2 = newdata.dropna()

### Remove any IDs with less than 5 data points
# Visualise number of counts for each ID
newdata2.groupby('ID').ID.count() 

# Set the threshold value for number of repeats
threshold = 5

# Group data points by ID number and store a count of instances
ValueCounts = newdata2['ID'].value_counts()

# Create variable to hold IDs that need to be removed from the table
toremove = ValueCounts[ValueCounts <= threshold].index

# Replace IDs to remove with "NaN"
newdata2 = newdata2.replace(to_replace = toremove, value= np.nan)

# Visually check claue counts are now more than 5
newdata2['ID'].value_counts()

# Remove all rows with NA data
newdata_no_missing = newdata2.dropna()

# Count number of NAs in the data set to be sure all have been removed
newdata_no_missing.isnull().sum()

### Save modified data to a .csv file
newdata_no_missing.to_csv('../data/FunResData.csv')

### Print message
print("Data wrangled for NLLS fitting")