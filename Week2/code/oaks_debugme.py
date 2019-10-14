import csv
import sys
import doctest
import pdb

#Define function
def is_an_oak(name):
    """
    Returns True if name starts with 'quercus'
    
    >>> is_an_oak('Fagus sykvatica')
    False
    
    >>> is_an_oak('Quercus cerris')
    True

    >>> is_an_oak('Quercus')
    True

    """
    if 'quercus' in name.lower():
            return True
    elif 'qrcs' in name.lower() and len(name)>6:
            return True
    else:
            return False
    return 


def main(argv): 
    f = open('../data/TestOaksData.csv','r')
    g = open('../data/JustOaksData.csv','w')
    taxa = csv.reader(f)
    csvwrite = csv.writer(g)
    oaks = set()
    for row in taxa:
        print(row)
        print ("The genus is: ") 
        print(row[0] + '\n')
        if is_an_oak(row[0]):
            print('FOUND AN OAK!\n')
            csvwrite.writerow([row[0], row[1]])    
    
    return 0
    
if (__name__ == "__main__"):
    status = main(sys.argv)
    doctest.testmod()