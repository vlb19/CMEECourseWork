#!/usr/bin/env python3

# Author: Victoria Blanchard vlb19@imperial.ac.uk
# Script: using_name.py
# Date: 25 October 2019

""" Changes output depending on where program is called from """

# OUTPUT
# prints output depending on where the program is called from

if __name__ == '__main__':
    print('This program is being run by itself')
else:
    print('I am being imported from another module')

