#!/usr/bin/env python3
""" Learning how to open and retrieve pickle dumps """

#######################
# STORING OBJECTS
#######################
# To save an object (even complex) for later use

### Imports 
import pickle

### Script
#Create a dictionary with keys and data
my_dictionary = {"a key":10, "another key":11}

#Open a pickle file and dump dictionary into it
f = open('../sandbox/testp.p','wb')
pickle.dump(my_dictionary,f)
f.close()

## Load the data again from the pickle file
f = open('../sandbox/testp.p','rb')
another_dictionary = pickle.load(f)
f.close()

print(another_dictionary)