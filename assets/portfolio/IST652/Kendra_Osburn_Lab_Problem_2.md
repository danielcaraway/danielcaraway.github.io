# IST 652
## Lab 2 
### Kendra Osburn
#### July 23, 2019

a. Show the expression that gets the value of the stock dictionary at the key "orange"

```stock[orange]```

stock = {"banana": 6, "apple": 0, "orange": 32, "pear": 15}
prices = {"banana": 4, "apple": 2, "orange": 1.5, "pear": 3}

```
stock["cherry"] = 19
price["cherry"] = 3.5
```

b. Iterate over stock dictionary and print each key and value

```
for fruit in stock:
	print(fruit, stock[fruit])
```

c. Sum the total items in the grocery list
```
groceries = ["apple", "banana", "pear"]
grocery_total = 0
for item in groceries:
	print(prices[item])
	grocery_total += prices[item]
print('grocery total:', grocery_total)
```

d. Print out the total value in stock of all the itmes

```
totals = []
for fruit in stock:
	print(prices[fruit] * stock[fruit])
	totals.append(prices[fruit] * stock[fruit])
print('total value in stock:', sum(totals))
```


All together:
```
stock = {"banana": 6, "apple": 0, "orange": 32, "pear": 15}
prices = {"banana": 4, "apple": 2, "orange": 1.5, "pear": 3}
stock["cherry"] = 19
prices["cherry"] = 3.5
for fruit in stock:
	print(fruit, stock[fruit])
groceries = ["apple", "banana", "pear"]
grocery_total = 0
for item in groceries:
	print(prices[item])
	grocery_total += prices[item]
print('grocery total:', grocery_total)
totals = []
for fruit in stock:
	print(prices[fruit] * stock[fruit])
	totals.append(prices[fruit] * stock[fruit])
print('total value in stock:', sum(totals))
```

OUTPUT: 
banana 6
apple 0
orange 32
pear 15
cherry 19
2
4
3
grocery total: 9
24
0
48.0
45
66.5
total value in stock: 183.5