#!/usr/bin/env python3

# Author: Victoria Blanchard vlb19@imperial.ac.uk
# Script: othercode.py
# Date: 25 November 2019

""" Tutorial on using subprocess
Creates an object from which you can 
extract the output and other information. 
Extracts information from varios other python scripts.
"""

### Imports
import subprocess

### Script

# Create object p from which you can extract the output and other information
p = subprocess.Popen(["echo", "I'm talkin' to you, bash!"], stdout = subprocess.PIPE, stderr=subprocess.PIPE)

#stdout = output process spawned by your command
#stderr = the error code (capturing whether the code is sucessful or not)

stdout, stderr = p.communicate()
stderr
stdout

print(stdout.decode())

p = subprocess.Popen(["ls", "-l"], stdout = subprocess.PIPE)
stdout, stderr = p.communicate() 
#print(stdout.decode())

p = subprocess.Popen(["python", "../../Week2/code/boilerplate.py"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
stdout, stderr = p.communicate()
print(stdout.decode())

subprocess.os.system("pdflatex yourlatexdoc.tex")

p = subprocess.Popen(["python", "../../Week2/code/boilerplate.py"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
print(stdout.decode())

### Handling Directory and File Paths
subprocess.os.path.join('directory', 'subdirectory', 'file')

MyPath = subprocess.os.path.join('directory', 'subdirectory', 'file')
MyPath