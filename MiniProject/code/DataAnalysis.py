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
import scipy as sc   
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
### Do any models fit better than the rest generally? ###
#########################################################

ModelANOVA = pg.anova(data = analysisdata, dv = 'AIC', between = 'Model', detailed = True)
ModelANOVA

#########################################################
### Do Phen or Mec models fit better? ###
#########################################################

counts = graphdata['MecOrPhen'].value_counts()
sc.stats.chisquare([counts[0], counts[1]])

#########################################################
### Does habitat influence model choice? ###
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
### Does consumer dimension influence model choice? ###
#########################################################

ConDimcrosstab = pd.crosstab(graphdata['BestModelAIC'], graphdata['Con_MovementDimensionality'], margins = False)

# Run a two-way ANOVA on model AICs with Habitat and Model as factors
ConDimANOVA = pg.anova(dv='AIC', between=['ConDimension','Model'], data = analysisdata, detailed = True)
ConDimANOVA

# Run a pairwise Tukey HSD to compare differences between each habitat
ConDimtukey = pg.pairwise_tukey(data = analysisdata, dv = 'AIC', between=['ConDimension'])
ConDimtukey

################################################################
### Generate bar chart for comparing model types per habitat ###
################################################################

# Crerate custom palettes
sns.palplot(sns.diverging_palette(128, 240, n=4))
custompalette = sns.diverging_palette(128, 240, n=4)

# Set dimensions of figure
plt.figure(num=None, figsize=(8,5), dpi = 80, facecolor = 'w', edgecolor = 'w')

# Create data frame to store percentages
Percentages = (graphdata['MecOrPhen'].value_counts()/len(graphdata['MecOrPhen'])*100)
PlotData = pd.DataFrame(['Phenomenological', 'Mechanistic'])
PlotData['ModelPercent'] = [Percentages[0],Percentages[1]]

# Plot bar chart
MecOrPhen = sns.barplot(x = 0, y= 'ModelPercent', data=PlotData, palette= custompalette, edgecolor = 'black')

# Give the y label a more descriptive value
plt.ylabel("Percentages of models fit")

# Give the y label a more descriptive value
plt.xlabel("Type of model")

# Save the figure to the results folder
plt.savefig('../results/PhenOrMec.pdf')


#########################################################
### Generate box and whisker plot for habitats ###
#########################################################

# Set dimensions of figure
plt.figure(num=None, figsize=(10,5), dpi = 80, facecolor = 'w', edgecolor = 'w')

# Create boxplot of best AIC value per model per habitat
bp = sns.boxplot(y = 'BestAIC', x = 'Habitat', data = graphdata, palette = custompalette, hue = "BestModelAIC")
handles, labels = bp.get_legend_handles_labels()

# Give the y label a more descriptive value
plt.ylabel("Minimum AIC Value")

# Create a legend for the different models 
plt.legend(loc = 'upper right')

# Save the figure to the results folder
plt.savefig('../results/HabitatCompare.pdf')


#########################################################
### Generate box and whisker plot for habitats ###
#########################################################

# Set dimensions of figure
plt.figure(num=None, figsize=(10,5), dpi = 80, facecolor = 'w', edgecolor = 'w')

# Create boxplot of best AIC value per model per habitat
bp = sns.boxplot(y = 'BestAIC', x = 'Con_MovementDimensionality', data = graphdata, palette = custompalette, hue = "BestModelAIC")
handles, labels = bp.get_legend_handles_labels()

# Give the y label a more descriptive value
plt.ylabel("Minimum AIC Value")

# Give the x label a more descriptive value 
plt.xlabel("Consumer movement dimensionality")

# Create a legend for the different models 
plt.legend(loc = 'upper right')

# Save the figure to the results folder
plt.savefig('../results/ConDimension.pdf')

#########################################################
### Print message for user ###
#########################################################
print("Models compared, figures saved to results folder")
