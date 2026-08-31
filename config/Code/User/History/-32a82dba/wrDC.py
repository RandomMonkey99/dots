import turtle as t
wn = t.Screen()
sides = int(input("How many sides: "))
for i in range(sides):
    t.fd(50)
    t.write("Side" + i)
    t.fd(50)
    t.right(360/sides)
t.done()