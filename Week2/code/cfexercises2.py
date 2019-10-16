#!/usr/bin/env python3 

"""Description of this program or application"""

__appname__ = '[cfexercises2.py]'
__author__ = 'Victoria Blanchard (vlb19@ic.ac.uk)'
__version__ = '0.0.1'

## imports ## 

import sys #module to interface our program with the operating system

if len(sys.argv) > 1:
    x = int(sys.argv[1])
    y = int(sys.argv[2])
    z = int(sys.argv[3])
else:
    x = 3
    y = 10
    z = 6


def say_hello(x,y):
    for i in range(x,y):
        print('hello')
    
def x_div_3(x):
    for j in range(x):
        if j % 3 == 0:
         print('hello')

def x_div_3or4(x):
    for j in range(x):
        if j % 5 == 3:
            print('hello')
        elif j % 4 == 3:
            print('hello')

def z_not_15(z):
    while z != 15:
        print('hello')
        z = z + 3

def zbelow100(z):
    while z < 100:
        if z == 31:
            for k in range(7):
                print ('hello')
        elif z == 18:
            print ('hello')
        z = z + 1 


print("Says hello y-x times")
print (say_hello(x,y))
print ("Done!")

print("Says hello x/3 times")
print(x_div_3(x))
print("Done!")

print(x_div_3or4(x))
print("Done!")

print("Says hello while z+3 does not equal 15")
print(z_not_15(z))
print("Done!")

print("Says hello while z is below 100 and fits within the parameters")
print(zbelow100(z))
print("Done!")
