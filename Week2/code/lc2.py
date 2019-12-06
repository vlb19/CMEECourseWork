#!/usr/bin/env python3
""" Use a list comprehension to create a list of month,
rainfall tuples where the amount of rain was greater than 100 mm.
Then use a list comprehension to create a list of just month names where the
 amount of rain was less than 50 mm. Then do it all again using 
 conventional loops"""

# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )


# 1) Create list of month, rainfall tuples where 
# the amount of rain is greater than 100mm

print ("Months where rainfall exceeded 100 mm") #tells the user what to expect
Months_above_100  = [row[0] for row in rainfall if row[1] > 100]
Values_above_100  = [row[1] for row in rainfall if row[1] > 100]
print (Months_above_100 + Values_above_100)

# 2) A a list of just month names where the
# amount of rain was less than 50 mm. 

print ("Months where rainfall was less than 50 mm") #tells the user what to expect
Months_below_50  = [row[0] for row in rainfall if row[1] < 50]
Values_below_50  = [row[1] for row in rainfall if row[1] < 50]
print (Months_below_50 + Values_below_50)

# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 

For_Month_above_100 = [] #creates new empty dictionary
for row in rainfall: #searches each value in rainfall
    if row[1] > 100: #if the second column value is larger than 100
        For_Month_above_100.append(row[0]) #add the corresponding month to the dictionary
        For_Month_above_100.append(row[1]) #and add the rainfall value
print ("Months where rainfall exceeded 100 mm") #tells the user what to expect
print (For_Month_above_100) #prints dictionary 

For_Month_below_50 = []
for row in rainfall:
    if row[1] < 50:
        For_Month_below_50.append(row[0])
        For_Month_below_50.append(row[1])
print ("Months where rainfall was less than 50 mm")
print (For_Month_below_50)
