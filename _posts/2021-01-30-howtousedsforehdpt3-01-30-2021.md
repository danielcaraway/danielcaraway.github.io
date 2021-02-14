---
layout: single
title: 'How to use Data Science Superpowers for Useless Things: Organizing Ancient Projects Pt 3'
tags: howto portfolio bash EHD
---

## RENAMING FILES USING PYTHON

```python
import os, time, shutil

ehd = 'EHD_7'
file_to_flatten = '__2017mac'
directory_in_str = '/Volumes/{}/{}/'.format(ehd, file_to_flatten)
destination = '/Volumes/{}/{}/{}_ALL/'.format(ehd, file_to_flatten, file_to_flatten)

for subdir, dirs, files in os.walk(directory_in_str):
    for file in files:
        filepath = subdir + os.sep + file

        time_stamp = ''

        try:
            stat = os.stat(filepath)
            time_stamp = time.strftime('%Y-%m-%d', time.localtime(stat.st_birthtime))
        except:
            print('----',stat.st_mtime)

        newfilename = time_stamp + '_' + filepath.split(directory_in_str)[1].replace('/', '__')
        newpath = destination + newfilename

        try:
            shutil.move(filepath, newpath)
#             print(filepath, newpath)
        except:
            print('error')
```

## RENAMING FILES USING PYTHON OLD

Errors? Check to make sure you renamed your EHD_7 to whatever your current EHD is!

```python
import os, time, shutil

directory_in_str = '/Volumes/EHD_7/2007/'
destination = '/Volumes/EHD_7/2007/____2007_ALL/'
# ext = (".jpg", ".png", ".jpeg", ".gif", ".mov", ".mp4", ".mpg", ".mpeg", ".heic", ".avi")

for subdir, dirs, files in os.walk(directory_in_str):
    for file in files:
#         print(file)
        filepath = subdir + os.sep + file


        time_stamp = ''

#         stat = os.stat(filepath)
        try:
            stat = os.stat(filepath)
            time_stamp = time.strftime('%Y-%m-%d', time.localtime(stat.st_birthtime))
        except:
            print('----',stat.st_mtime)

        newfilename = time_stamp + '_' + filepath.split(directory_in_str)[1].replace('/', '__')
#         print(filepath, newfilename)
        newpath = destination + newfilename

        try:
            shutil.move(filepath, newpath)
#             print(filepath, newpath)
        except:
            print('error')

```

### OH NO! I accidentally moved it without the '/'!

```python
directory_in_str = '/Volumes/EHD_5/IomegaHDD_20150315_transfer/'
destination = '/Volumes/EHD_5/IomegaHDD_20150315_transfer/Iomega_ALL/'
for subdir, dirs, files in os.walk(directory_in_str):
    for file in files:
        filepath = subdir + os.sep + file
        if file[:10] == "Iomega_ALL":
            newname = file[10:]
            shutil.move(filepath, destination + newname)
            print(file)

```

## CONFIRMING WE GOT EVERYTHING:

```python
directory_in_str = '/Volumes/EHD_5/____play/'
# destination = '/Volumes/EHD_5/*FIRST_TRANSFER/____FIRST_TRANSFER_ALL/'
for subdir, dirs, files in os.walk(directory_in_str):
    for file in files:
        print(file)

```
