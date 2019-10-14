# How many times will 'hello' be printed?
"""Say_hello"""
for i in range(3, 5):
    print('hello')
print ('done')

for j in range(12):
    if j % 3 == 0:
        print('hello')
print('done')

for j in range(15):
     if j % 5 == 3:
        print (j)
        print('hello1')
     elif j % 4 == 3:
        print (j)
        print('hello2')
print('done')

z = 0
while z != 15:
    print('hello')
    z = z + 3
print('done')

z = 12
while z < 100:
    if z == 31:
        for k in range(7):
            print ('hello')
    elif z == 18:
        print ('hello')
    z = z + 1
print('done')