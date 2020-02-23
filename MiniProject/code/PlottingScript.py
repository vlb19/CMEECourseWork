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
import pingouin as pg    
import matplotlib.pyplot as plt

### Importing data ### 
data = pd.read_csv('../data/AnalysisTable.csv')

# Print number of columns loaded
print("Loaded {} columns.".format(len(data.columns.values)))

# Print column headings
print(data.columns.values)

### HABITAT ANALYSIS ###
# Summarise AIC by model and habitat
rp.summary_cont(data.groupby(['Habitat','Model']))['AIC']

# Run a two-way ANOVA on the AIC values by Habitat and Model
model = ols('AIC ~ C(Model)*C(Habitat)', data).fit()


# Check if the overall model is significant
print(f"Overall model F({model.df_model: .0f},{model.df_resid: .0f}) = {model.fvalue: .3f}, p = {model.f_pvalue: .4f}")

# Check assumptions of two-way ANOVA are met 
    #Durban-Watson detects the presence of autocorrelation
    #Jarque-Bera tests assumption of normality
    #Omnibus tests the assumption of homogeneity of variance
    #Condition Number assess multicollinearity
        #NB: values over 20 are indicative of multicollinearity. 
model.summary()

# View ANOVA table
res = sm.stats.anova_lm(model, typ=2)
res

# Since assumptions of two-way ANOVA are not met we need to do 
# a non-parametric Friedman Test

stats.kruskal(data['AIC', data['Model'], data['Habitat']])


