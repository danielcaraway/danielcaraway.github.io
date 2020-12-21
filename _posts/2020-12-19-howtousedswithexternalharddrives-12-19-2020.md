---
layout: single
title: "How to use Data Science Superpowers for Useless Things: Finding a document hidden on an external hard drive"
tags: howto
---

# How to Find a Document hidden on an External Hard Drive 

```python
import glob
import pandas as pd
from google.colab import drive
drive.mount('/gdrive', force_remount=True)

file = '/gdrive/My Drive/EHD/___EHD_08_ALLTHEFILES.txt'
fopen = open(file,mode='r+')

fread = fopen.readlines()

x = '.psd'


all_lines = []
for line in fread:
  if x in line:
      all_lines.append(file + '#' + line.strip())


all_lines_08 = all_lines
for line in all_lines:
  if 'template' in line or 'effect' in line:
    print(line)      

```

## How to list all parent directories

```python
import glob
import pandas as pd
from google.colab import drive
drive.mount('/gdrive', force_remount=True)

file = '/gdrive/My Drive/EHD/___EHD_06_ALLTHEFILES.txt'
fopen = open(file,mode='r+')

fread = fopen.readlines()

x = '.psd'


all_lines = []
mega_dict = {}
for line in fread:

  split_line = line.split('/')
  try:
    if split_line[1] in mega_dict:
      mega_dict[split_line[1]] += 1
    else:
      mega_dict[split_line[1]] = 1
  except:
    pass

```