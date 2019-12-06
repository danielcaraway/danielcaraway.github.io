---
layout: single
title: 'BASH PARTY'
tags: bash html
---

How to bash:

## STEP 1: Copy all jupyter files to new folder

1. List all files in (homework) directory (AND subdirectories) 
2. If file ends in .ipynb, copy it to new folder

```console
recursive_list() {
  for d in *; do
    if [ -d "$d" ]; then
      (cd -- "$d" && recursive_list)
    fi
    if [[ $d == *.ipynb ]] ; then
        cp $d all_html/ || cp $d ../all_html/
    fi
  done
}
```

## STEP 2: Change file name to include timestamp

```console
for f in *.ipynb; do 
    newdate=$(stat -f %SB -t %Y_%m_%d "$f")
    echo "${newdate}_${f%%.*}" && echo $newdate 
done
```
### Because the "creation date" is lost when we make a copy, this adds the date to the title first!!

```console
recursive_list_4() {
  for d in *; do
    if [ -d "$d" ]; then
      (cd -- "$d" && recursive_list_4)
    fi
    if [[ $d == *.ipynb ]] ; then
        newdate=$(stat -f %SB -t %Y_%m_%d "$d")
        filename=${newdate}_${d%%.*}.ipynb
        echo "$filename"
        cp $d all_html/"$filename" || cp $d ../all_html/"$filename"
    fi
  done
}
```

## STEP 3: Convert Jupyter files to html files

```console
for d in *.ipynb ; do
    jupyter nbconvert --to html $d
done
```

OR -- to execute

```console
for d in *.ipynb ; do
    jupyter nbconvert --execute --to html $d
done
```