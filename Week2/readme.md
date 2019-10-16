# Week 2 readme file

## Wee2 folder
* code
* data
* results
* sandbox
* readme.md

### Code Folder

#### align_seqs.py
* no user input required
* inputs sequences saved in data file
* aligns two sequences and assigns them a score
* saves best alignment and best alignment score to text file in results

#### align_seqs_better.py
* imports two sequences from either user defined files or specified files in the fasta folder
* aligns two sequences and assigns them a score
* saves best alignment score and best corresponding alignments to text file in results

#### align_seqs_fasta.py
* imports two sequences from either user defined files or specified files in the fasta folder
* aligns two sequences and assigns them a score
* saves last alignment with best alignment score and the score to text file in results

#### basic_io1.py
* Requires no user input 
* Imports data from sandbox 
* prints data file then prints every other line from data file

#### basic_csv.py
* Requires no user input 
* Imports csv
* Imports csv data from data folder 
* Writes data from csv to a differents csv 

#### basic_io2.py
* Requires no user input
* Imports string data from sandbox
* Writes contents of datafile from sandbox to new file

#### basic_io3.py
* Requires no user input
* Imports pickle 
* Imports string data from sanbox
* Pickle.dumps imported string data then pickle loads it 

#### boilerplate.py
* Requires no user input
* Returns "this is a boilerplate"

#### cfexercises1.py
* Requires no user input 
* Returns various values and serves as the base code for cfexercises2

#### cfexercises2.py
* Requires user input of an integer
* Runs cfexercises1.py code on user input

#### control_flow.py
* Requires user input of one integer
* Returns prodcuts of various functions if input is there or uses internally stored values if there is no input

#### debugme.py
* Requires no user input 
* Returns an error when run

#### dictionary.py
* Requires no user input 
* Creates dictionary of taxa with species as first column and order as second
* Prints taxa dictionary grouped by order 

#### lc1.py
* Requires no user input
* Creates dictionary of bird species name, common name, and weights
* Prints each column separately twice 

#### lc2.py
* Requires no user input 
* Vector created with Month and total rainfall 
* Returns list of months where rainfall exceeded 100mm and another with months less than 50mm and does this twice

#### loops.py
* Requires no user input 
* Prints several outputs for finite loops before printing "Geronimo" from an infinite loop

#### oaks.py
* Requires no user input
* Returns whether each value in the dictionary is an oak or not

#### oaks_debugme.py
* Requires user string input
* Returns whether user input is defined as an oak

#### scope.py 
* Requires no user input 
* Changes the values of global and local variables then prints those new values

#### sysargv.py
* Requires user input of one or more arguments
* Prints the arguments and the number of arguments

#### test_control_flow.py
* No input required
* Runs doctest on code from control_flow

#### test_control_flow.pyc
* Binary file for test_control_flow.py

#### tuple.py
* No input required 
* Re-orders dictionary by species then common name 

#### using_name.py
* No input required 
* Prints one output if run from command line and another if imported as a module

### Data Folder 
* bodymass.csv 
* sequences.csv
* testcsv.csv
* TestOaksData.csv
* **fasta** folder
    * 407228326.fasta
    * 407228412.fasta
    * E.coli.fasta

### Results Folder
Empty

**Sandbox contents ignored**