import turtle as t
wn = t.Screen()
sides = int(input("How many sides: "))
print([ i
    for i in sides
])
for i in range(sides):
    t.fd(50)
    t.write("Side" + str(i+1))
    t.fd(50)
    t.right(360/sides)
t.done()