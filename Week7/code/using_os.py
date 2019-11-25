#!/usr/bin/env python3

# Imports
import os
import subprocess

# Get the user's home directory.
home = subprocess.os.path.expanduser("~")
print(home)

# Use the subprocess.os module to get a list of files and  directories in your ubuntu home directory 
firlist = subprocess.os.listdir(home)
print(firlist)

# Get a list of files and directories in your home/ that start with an uppercase 'C'

FilesDirsStartingWithC = [filename for filename in os.listdir('/home/vlb19') if filename.startswith("C")]
print(FilesDirsStartingWithC)

# Use a for loop to walk through the home directory.
for (root, dirs, files) in subprocess.os.walk(home):
    for name in files: 
        (base, ext) = os.path.splitext(name)
        files = base

  
#################################
# Get files and directories in your home/ that start with either an 
# upper or lower case 'C'

# Type your code here:
FilesDirsStartingWithC = [filename for filename in os.listdir('/home/vlb19') if filename.startswith("C") or filename.startswith("c")]
print(FilesDirsStartingWithC)

