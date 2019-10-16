taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a short python script to populate a dictionary called taxa_dic 
# derived from  taxa so that it maps order names to sets of taxa. 
# E.g. 'Chiroptera' : set(['Myotis lucifugus']) etc. 

taxa_dic = {}
order_dict = []

for species,order in taxa:
    if order not in order_dict:
        order_dict.append(order)

    for y in order_dict:
        set_add = set()
        for i in taxa: 
            if i[1] == y:
                set_add.add(i[0])
        taxa_dic[y]=set_add

"""
#taxa_dic = []#creates new empty dictionary
from collections import defaultdict #import the defaultdict class from collections 
taxa_dic = defaultdict(list) #creates dictionary containing defaultdict and sets 
#the defaultfactory setting to list, meaning it will make a new list for each 
#item encountered for the first time, append that item and then re-run the for loop
#the for loop contained within the function makes a list for each key then the the 
#new list item is appended to the existing key 
for taxas, order in taxa: #identifies the first column as taxa and the second column
    #as order
    taxa_dic[order].append(taxas) #appends taxa values to the corresponding order key
"""

print ("Dictionary of order names and taxa") #tells the user what is happening
print (taxa_dic) #prints the new dictionary
 
