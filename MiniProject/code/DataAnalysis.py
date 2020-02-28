#!/usr/bin/env python3

""" Data analysis and figure generation
"""

__appname__ = 'DataAnalysis.py'
__author__ = 'Viki Blanchard (vlb19@ic.ac.uk)'
__version__ = '0.0.1'

# Some imports to explore the datasets
import pandas as pd
import seaborn as sns
import numpy as np
import pingouin as pg    
import matplotlib.pyplot as plt

# Print information for user
print("Analysing model fits, please wait.")

#########################################################
### Load in data sets ###
#########################################################

# Data formatted for  ANOVA analysis
analysisdata = pd.read_csv('../data/AnalysisTable.csv')

# Data formatted for plotting
graphdata = pd.read_csv("../data/OptimisedFitSummary.csv")

#########################################################
### Analyse effects of habitat on model choice ###
#########################################################

# Visualise the data 
Habitatcrosstab = pd.crosstab(graphdata['BestModelAIC'], graphdata['Habitat'], margins = False)
print(Habitatcrosstab)

# Test the normality of the data 
pg.normality(analysisdata['AIC'])

# Run a two-way ANOVA on model AICs with Habitat and Model as factors
HabitatANOVA = pg.anova(dv='AIC', between=['Habitat','Model'], data = analysisdata, detailed = True)
HabitatANOVA

# Run a pairwise Tukey HSD to compare differences between each habitat
Habitattukey = pg.pairwise_tukey(data = analysisdata, dv = 'AIC', between=['Habitat'])
Habitattukey

#########################################################
### Visualise consumer dimension analysis data ###
#########################################################

ConDimcrosstab = pd.crosstab(graphdata['BestModelAIC'], graphdata['Con_MovementDimensionality'], margins = False)

#########################################################
### Generate box and whisker plot for habitats ###
#########################################################

# Crerate custom palettes
sns.palplot(sns.diverging_palette(128, 240, n=4))
custompalette = sns.diverging_palette(128, 240, n=4)

# Set dimensions of figure
plt.figure(num=None, figsize=(8,6), dpi = 80, facecolor = 'w', edgecolor = 'w')

# Create boxplot of best AIC value per model per habitat
bp = sns.boxplot(y = 'BestAIC', x = 'Habitat', data = graphdata, palette = custompalette, hue = "BestModelAIC")
handles, labels = bp.get_legend_handles_labels()

# Give the y label a more descriptive value
plt.ylabel("Minimum AIC Value")

# Create a legend for the different models 
plt.legend(loc = 'upper right')

# Save the figure to the results folder
plt.savefig('../results/HabitatCompare.pdf')

################################################################
### Generate bar chart for comparing model types per habitat ###
################################################################

# Set dimensions of figure
plt.figure(num=None, figsize=(7,6), dpi = 80, facecolor = 'w', edgecolor = 'w')

# Plot bar chart
MecOrPhen = sns.countplot(x = 'Habitat', hue = 'MecOrPhen', data = graphdata, palette= custompalette, edgecolor = 'black')

# Give the y label a more descriptive value
plt.ylabel("Frequency of best model selected")

# Save the figure to the results folder
plt.savefig('../results/PhenOrMec.pdf')

#########################################################
### Print message for user ###
#########################################################
print("Models compared, figures saved to results folder")
