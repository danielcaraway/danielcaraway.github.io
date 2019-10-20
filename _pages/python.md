---
layout: single
title: 'daily log'
---

# Python

[stack overflow about removing things](https://stackoverflow.com/questions/1276764/stripping-everything-but-alphanumeric-chars-from-a-string-in-python)
```python
s = 'abc.com/abs'
exclude = '/'
s = ''.join(ch for ch in s if ch not in exclude)
```