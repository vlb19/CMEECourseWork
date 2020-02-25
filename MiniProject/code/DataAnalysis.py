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
import matplotlib.axes as ax
from matplotlib.patches import Polygon

graphdata = pd.read_csv("../data/OptimisedFitSummary.csv")

# Print number of columns loaded
print("Loaded {} columns.".format(len(graphdata.columns.values)))

# Print column headings
print(graphdata.columns.values)

HabitatCrosstab = pd.crosstab(graphdata['BestModelAIC'], graphdata['Habitat'], margins = False)
print(HabitatCrosstab)

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
plt.savefig('../results/HabitatCompare')

# Set dimensions of figure
plt.figure(num=None, figsize=(20,10), dpi = 80, facecolor = 'w', edgecolor = 'w')

# Create boxplot of best AIC value per model per habitat
bp = sns.catplot(y = 'BestAIC', x = 'Habitat', data = graphdata, palette = custompalette, hue = "BestModelAIC", kind = "violin")

# Give the y label a more descriptive value
plt.ylabel("Minimum AIC Value")

# Save the figure to the results folder
plt.savefig('../results/HabitatCompareViolin')

Habitatcrosstab = pd.crosstab(graphdata['Habitat'], graphdata['MecOrPhen'], margins = False)
print(Habitatcrosstab)

# Set dimensions of figure
plt.figure(num=None, figsize=(7,6), dpi = 80, facecolor = 'w', edgecolor = 'w')

# Plot bar chart
MecOrPhen = sns.countplot(x = 'Habitat', hue = 'MecOrPhen', data = graphdata)

# Give the y label a more descriptive value
plt.ylabel("Frequency of best model selected")

# Save the figure to the results folder
plt.savefig('../results/PhenOrMec')

analysisdata = pd.read_csv('../data/AnalysisTable.csv')

# Print number of columns loaded
print("Loaded {} columns.".format(len(analysisdata.columns.values)))

# Print column headings
print(analysisdata.columns.values)

analysisdata.head()

HabitatANOVA = pg.anova(dv='AIC', between=['Habitat','Model'], data = analysisdata, detailed = True)
HabitatANOVA

Habitattukey = pg.pairwise_tukey(data = analysisdata, dv = 'AIC', between=['Habitat'])
Habitattukey


Modeltukey = pg.pairwise_tukey(data = analysisdata, dv = 'AIC', between=['Model'])
Modeltukey


ConDimcrosstab = pd.crosstab(graphdata['BestModelAIC'], graphdata['Con_MovementDimensionality'], margins = False)
print(ConDimcrosstab) 
