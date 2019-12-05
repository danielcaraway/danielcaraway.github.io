--- 
layout: single
title: "Python Cheatsheet"
permalink: /python/
---

# Python

## Get unique list

`python
mylist = list(set(mylist))
`
`python
sorted([*{*c}])
`

## Regex BETWEEN two STRINGS

(?<=% of )(.*)(?= at )
[example](https://www.regextester.com/96872)

## Save image from link

`python
import requests

img_data = requests.get(image_url).content
with open('image_name.jpg', 'wb') as handler:
    handler.write(img_data)
`

## Markdown to word doc

```console
pandoc -o output.docx -f markdown -t docx HW5_pretty.md
```

## Regex, characters between symbols `§` and `;`

`(?<=§).*?(?=;)`

[SO link](https://stackoverflow.com/questions/3335562/regex-to-select-everything-between-two-characters)

## Regex find all between quotes

`re.findall(r'"([^"]*)"', inputString)`

[SO 1](https://stackoverflow.com/questions/22735440/extract-a-string-between-double-quotes)
[SO 2](https://stackoverflow.com/questions/2947502/getting-dialogue-snippets-from-text-using-regular-expressions)

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

