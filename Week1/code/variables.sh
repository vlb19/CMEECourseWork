#!/bin/bash
# Author: Victoria Blanchard vlb19@imperial.ac.uk
# Script: variables.sh
# Desc: Tells you the current variable, allows you to 
# change it and then adds two user inputted numbers
# Arguments: 3 -> new variable, two numbers
# Date: 1 October 2019 

#shows the use of variables
MyVar='Emma'
echo 'the current value of the variable is' $MyVar
echo 'Please enter a new string'
read MyVar
echo 'the current value of the variable is' $MyVar

#Reading multiple values 
echo 'Enter two numbers separated by space (s)'
read a b 
echo 'you entered' $a 'and' $b '. Their sum is:'
mysum=`expr $a + $b`
echo $mysum