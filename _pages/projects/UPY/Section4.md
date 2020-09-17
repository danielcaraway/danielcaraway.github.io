---
title: "UPY: Python Crash Course"
permalink: /projects/UPY/S4
---

```python
def countDog(string):
    dog_count = 0
    sentence = string.lower().split()
    for word in sentence:
        if word == "dog":
            dog_count += 1
    return dog_count

countDog('This dog runs faster than the other dog dude!')
```

### Remove words that don't start with `s`

```python
seq = ['soup','dog','salad','cat','great']
list(filter(lambda s: s[0] == 's', seq))

```

### Final Problem

**You are driving a little too fast, and a police officer stops you. Write a function
to return one of 3 possible results: "No ticket", "Small ticket", or "Big Ticket".
If your speed is 60 or less, the result is "No Ticket". If speed is between 61
and 80 inclusive, the result is "Small Ticket". If speed is 81 or more, the result is "Big Ticket". Unless it is your birthday (encoded as a boolean value in the parameters of the function) -- on your birthday, your speed can be 5 higher in all
cases. **

```python
def caught_speeding(speed, is_birthday):
  if is_birthday:
      speed = speed - 5

  if speed > 80:
      return "Big Ticket"
  elif speed > 60 and speed < 81:
      return "Small Ticket"
  else:
      return "No Ticket"

  pass
caught_speeding(81,True) # should be "Small Ticket"
caught_speeding(81,False) # should be "Big Ticket"
```
