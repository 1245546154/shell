with open("a.txt","r") as f1,open("b.txt","r") as f2:
    a = f1.readlines()
    b = f2.readlines()
list1 = set(a)
list2 = set(b)
data = list1.intersection(list2)

for i in data:
    print(i.strip())
