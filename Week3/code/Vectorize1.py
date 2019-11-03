## Sum all the elements of a matrix

import numpy as np
import time

M = np.random.uniform(1000000, size=(1000,1000)) #create a matrix of 1000000 random uniform numbers with 1000 columns and 1000 rows

#Define function to sum all elements
def SumAllElements(M): 
    Dimensions = M.shape #store the dimensions of the matrix
    Tot = 0 # start running total 
    for i in range(0,Dimensions[0]): #for every row value
        for j in range(0,Dimensions[1]): #for every column value
            Tot = Tot + M[i,j] # add the element in the matrix to the running total 
    return (Tot) #return the overall total 

start_time = time.time() #store the current time as a variable
SumAllElements(M) #run the function
runningtime = time.time() - start_time #running time = time now - time before running the script
print("Using loops, the time taken is:", runningtime)

start_time = time.time()
M.sum()
runningtime = time.time() - start_time
print("Using the in-built vectorized function, the time taken is:", runningtime)
