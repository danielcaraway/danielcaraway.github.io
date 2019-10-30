---
layout: single
title: 'daily log'
---

# Python

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