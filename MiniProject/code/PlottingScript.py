#!/usr/bin/env python3

""" Plotting models and data analysis
"""

# Some imports to explore the datasets
import csv
import matplotlib
import numpy as np
import pandas as pd
import seaborn as sns
import scipy.stats as stats
import researchpy as rp
import statsmodels.api as sm
from statsmodels.formula.api import ols
    
import matplotlib.pyplot as plt

### Importing data ### 
data = pd.read_csv('../data/MergedOptTable.csv')

# Print number of columns loaded
print("Loaded {} columns.".format(len(data.columns.values)))

# Print column headings
print(data.columns.values)

### Convert habitat to numeric values
# Create a dictionary of habitat numeric equivalents
Habitat = {'Freshwater':1, 'Marine':2, 'Terrestrial':3}
# Swap out habitat strings for numeric equivalents
data.Habitat = [Habitat[item] for item in data.Habitat] 

### Convert habitat to numeric values
# Create a dictionary of habitat numeric equivalents
Dimensionality = {'sessile':1, '2D':2, '3D':3}
# Swap out habitat strings for numeric equivalents
data.Res_MovementDimensionality = [Dimensionality[item] for item in data.Res_MovementDimensionality]
data.Con_MovementDimensionality = [Dimensionality[item] for item in data.Con_MovementDimensionality] 
print(data.Res_MovementDimensionality)


#### ANALYSIS 

rp.summary_cont(data.Habitat)

formula = 'Habitat ~ C(AIC_Hol_Model), C(AIC__Cub_Model)'







##################


data_crosstab = pd.crosstab(data['Best_AIC_Model'], data['Habitat'], margins = False)
print(data_crosstab)

data_crosstab = pd.crosstab(data['Best_AIC_Model'], data['ConTaxa'], margins = False)
print(data_crosstab)

data_crosstab = pd.crosstab(data['Best_AIC_Model'], data['Res_MovementDimensionality'], margins = False)
print(data_crosstab)