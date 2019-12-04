#!/usr/bin/env python3

# Author: Victoria Blanchard vlb19@imperial.ac.uk
# Script: tuple.py
# Date: 3 December 2019

# Desc: 
# Birds is a tuple of tuples of length three: latin name, common name, mass.
# A script to print these on a separate line or output block by species 

# OUTPUT
# Prints latin name, common name, and mass of each individual within the 
# dictionary on a separate line

### Dictionary of birds with latin name, common name, and mass
birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
        )

print ("Information on birds in dictionary")

# print each piece of information in a separate output block
for birdinfo in birds:
    print( "The latin name is: ", birdinfo[0])
    print( "The common name is: ", birdinfo[1])
    print( "The average species mass is: ", birdinfo[2], "\n")


