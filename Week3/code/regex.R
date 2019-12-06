""" Script that utilisies regex and gives includes example exercises """# Sets a variable 

my_string = "a given string"

# finds a space in the string 
# Tells you match is found
match = re.search(r'\s', my_string)
print(match)

# Finds numeric characters in the string
match = re.search(r'\d', my_string)print(match)MyStr = 'an example'match = re.search(r'\w*\s', MyStr) # Matches word and space 

# if else statament that prints the match if found but if not prints alternative statement 
if match:                      
  print('found a match:', match.group()) 
else:
  print('did not find a match')   # Finds the number 2 in a string
match = re.search(r'2' , "it takes 2 to tango")
match.group()# Finds any numeric value in a string 
match = re.search(r'\d' , "it takes 2 to tango")
match.group()# Prints anything past a numeric value in a string
match = re.search(r'\d.*' , "it takes 2 to tango")
match.group()# Prints the 3rd word in a string
match = re.search(r'\s\w{1,3}\s', 'once upon a time')
match.group()# Prints everything onwards from a space, word
match = re.search(r'\s\w*$', 'once upon a time')
match.group()# Excludes the numeric character in output

# The stars in the script mean the pattern is repeated as many times as possible
re.search(r'\w*\s\d.*\d', 'take 2 grams of H2O').group()# Repeats pattern of word and space
re.search(r'^\w*.*\s', 'once upon a time').group() # 'once upon a '# Stops greedy tokens when they find the first pattern
re.search(r'^\w*.*?\s', 'once upon a time').group()#Illustration of greedy tags
re.search(r'<.+>', 'This is a <EM>first</EM> test').group()

#How to make them 'lazy'
re.search(r'<.+?>', 'This is a <EM>first</EM> test').group()# Returns first match of a numeric value with a decimal than another numeric value
re.search(r'\d*\.?\d*','1432.75+60.22i').group()#Didnt find the exact sequence because of greeedy values but found the individual letters
re.search(r'[AGTC]+', 'the sequence ATTCGT').group()#Finds just the species name and returns it 
re.search(r'\s+[A-Z]\w+\s*\w+', "The bird-shit frog's name is Theloderma asper.").group()# example of finding an email that isnt correct

MyStr = 'Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s]+,\s[\w\.@]+,\s[\w\s]+",MyStr)
match.group()#matches the different patterns of the email overall and outputs it
match = re.search(r"[\w\s]+,\s[\w\.-]+@[\w\.-]+,\s[\w\s]+",MyStr)
match.group()# Another example of grouping patterns
MyStr = 'Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s]+,\s[\w\.-]+@[\w\.-]+,\s[\w\s]+",MyStr)
match.group()# Example on how to create groups 
match = re.search(r"([\w\s]+),\s([\w\.-]+@[\w\.-]+),\s([\w\s&]+)",MyStr)

if match:
  print(match.group(0))
print(match.group(1))
print(match.group(2))
print(match.group(3))MyStr = "Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory; Another academic, a-academic@imperial.ac.uk, Some other stuff thats equally boring; Yet another academic, y.a_academic@imperial.ac.uk, Some other stuff thats even more boring"#Illustrates how to use re.findall()

#Outputs all emails
emails = re.findall(r'[\w\.-]+@[\w\.-]+', MyStr) 
for email in emails:
  print(email)


