# Some imports to explore the datasets
# Import relevant packages for data manipulation
import pandas as pd
import scipy as sc
import matplotlib.pylab as pl
import seaborn as sns # You might need to install this (e.g., sudo pip install seaborn)
import numpy as np#Read in data

data = pd.read_csv("../data/CRat.csv")# Make a new dataframe with the relevant columns of interest
newdata = data[['ID', 'ResDensity', 'N_TraitValue']].copy()

# Check for missing or NA values
# If none then move on with wrangling
newdata2 = newdata[newdata.isna().any(axis=1)]
print(newdata2)

#Count the number of IDs to see if there are any sets of data with less than 5 data points
newdata.groupby('ID').ID.count()#Create a threshold of datapoints for the modelling
threshold = 5

#Create a variable called ValueCounts that counts then number of occurances
# Of each ID
ValueCounts = newdata['ID'].value_counts()

# Apply the threshold value to the ValueCounts to remove any IDs with less than 5 data points
toremove = ValueCounts[ValueCounts <= threshold].index

#Replace these values with NaNs
newdata.replace(toremove, np.nan, inplace=True)# Inspect data to see if the function worked
newdata['ID'].value_counts()

#Check to see if there are any NaN values
newdata.isnull().sum()#Drop NaN values from data frame
newdata_no_missing = newdata.dropna()
print(newdata_no_missing)

#Check that it has worked
newdata_no_missing.isnull().sum()newdata_no_missing.to_csv('../data/FunResData.csv')


