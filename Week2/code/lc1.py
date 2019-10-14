birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 

print ("Latin names of birds") #Tells the user what is happening
Latin_Names  = [row[0]for row in birds] #stores the first column of birds into a new dictionary
print (Latin_Names) #prints the new dictionary

print ("Common names of birds")
Common_Names = [row[1]for row in birds]
print (Common_Names)

print ("Mean body mass of each species")
Body_Mass = [row[2]for row in birds]
print (Body_Mass)

# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

For_Latin_Names = [] #creates new empty dictionary
for row in birds: #searches each value in birds
    For_Latin_Names.append(row[0]) #adds the first value of each row to the new dictionary
print ("Latin names of birds") #tells the user what is happening
print (For_Latin_Names) #prints the new dictionary

For_Common_Names = []
for row in birds:
    For_Common_Names.append(row[1])
print ("Common names of birds")
print (For_Common_Names)

For_Body_Mass = []
for row in birds:
    For_Body_Mass.append(row[2])
print ("Mean body mass of each species")
print (For_Body_Mass)
