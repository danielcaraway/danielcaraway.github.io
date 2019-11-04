--- 
layout: single
title: "Python Cheatsheet"
permalink: /python/
---

# Python

## Regex stripping multiple characters

```python
import re
name = "Barack (of Washington)"
name = re.sub('[\(\)\{\}<>]', '', name)
print(name)
# OUTPUT: Barack of Washington
```
[Stack Overflow](https://stackoverflow.com/questions/3900054/python-strip-multiple-characters)


## Using .format()

```python
# different datatypes can be used in formatting 
print ("Hi ! My name is {} and I am {} years old"
                            .format("Daniel", 30)) 
# OUTPUT: Hi ! My name is Daniel and I am 30 years old
```

## Ternary (why can't I remember this)
```python
condition_if_true if condition else condition_if_false
```

[stack overflow about removing things](https://stackoverflow.com/questions/1276764/stripping-everything-but-alphanumeric-chars-from-a-string-in-python)
```python
s = 'abc.com/abs'
exclude = '/'
s = ''.join(ch for ch in s if ch not in exclude)
```

