---
layout: single
title: 'BASH NOTES'
permalink: /bash/
---

## GET FILENAME WITHOUT EXTENSION

```console
filename=$(basename -- "$fullfile")
extension="${filename##*.}"
filename="${filename%.*}"
```

## Convert notebook to html if not already html

IN ENGLISH: 
For all python files, 
check if an html already exists. 
If not, make one.


#### ADDING TO AN ARRAY 

```console
args=()
for i in *.html; do
    args+=("$i")
done
echo "${args[@]}"

for i in *.ipynb; do
  if [[ ! " ${args[@]} " =~ " ${i%.*}.html " ]]; then
    jupyter nbconvert --to html $i
    echo "$i"
  fi
done
```

## CHECK IF FILE EXISTS IN FOLDER:

```console
for i in *.ipynb; do     
  find "${i%.*}.html"; 
done
```

#### OLD, NOT WORKING LIKE I WANTED LOL

```console
for d in *; do
  if [[ $d == *.ipynb ]] ; then
      if [[ $d != *.html ]] ; then
          echo "$d"
          jupyter nbconvert --to html $d
      fi
    fi
done
```

```console
for d in *; do
    if [[ $d != *.html ]] ; then
        echo "$d"
        jupyter nbconvert --to html $d
    fi
done
```


## Fixing File Permissions (especially on jupyter notebook)
/usr/local/share/jupyter/nbconvert/templates
sudo chmod a+rwx html/

[help here](https://www.chriswrites.com/how-to-change-file-permissions-using-the-terminal/)

## CONVERT ONE FILE

jupyter nbconvert --to html notebook.ipynb

### (IF YOU WANT IT TO EXECUTE)

jupyter nbconvert --execute --to html notebook.ipynb


## ADD DATE TO FILE NAME:

for d in *; do
  newdate=$(stat -f %SB -t %Y_%m_%d "$d")
  filename=${newdate}_${d##*/}
  echo "$filename"
  cp $d "$filename" 
done

## CONVERT ALL .ipynb FILES TO .html

for d in *.ipynb ; do
    jupyter nbconvert --to html $d
done

---


# BASH SCRIPT:

List files in directory
list sub files in directory 

for d in *.ipynb ; do
    jupyter nbconvert --execute --to html $d.ipynb
    echo "$d"
done

for d in *.ipynb ; do
    jupyter nbconvert --to html $d
done


for f in /IST_736_TextMining/* IST_736_TextMining/**/* ; do
  echo "$f"
done

for f in /ALI/* ALI/**/* ; do
  echo "$f"
done


recursive_list2() {
  for d in *; do
    if [ -d "$d" ]; then
      (cd -- "$d" && recursive_list)
    fi
    if [[ $d == *.ipynb ]] ; then
        echo "$d"
    fi
  done
}


recursive_list2() {
  for d in *; do
    if [[ $d == *.ipynb ]] ; then
        echo "$d"
    fi
  done
}

list_files(d) {
    if [[ $d == *.ipynb ]] ; then
        echo "$d"
    fi
}

recursive_list2() {
  for d in *; do
    if [ -d "$d" ]; then
      (cd -- "$d" && list_files)
    fi
    if [[ $d == *.ipynb ]] ; then
        echo "$d"
    fi
  done
}


recursive_list2() {
  for d in *; do
    if [ -d "$d" ]; then
      (cd -- "$d" && echo "$d")
    fi
  done
}




recursive_list_3() {
  for d in *; do
    if [ -d "$d" ]; then
      (cd -- "$d" && recursive_list_3)
    fi
    if [[ $d == *.ipynb ]] ; then
        echo "$d"
    fi
  done
}


recursive_list_3() {
  for d in *; do
    if [ -d "$d" ]; then
      (cd -- "$d" && recursive_list_3)
    fi
    if [[ $d == *.ipynb ]] ; then
        cp $d all_html/ || cp $d ../all_html/
    fi
  done
}



stat -f "%SB"


mv -- Untitled.ipynb "Untitled-$(stat -f %SB).ipynb"


for f in *.ipynb; do
   olddate=$(stat -f %SB -t %Y%m%d%H%M "$f")
   touch -m -t $olddate "$f"    
done


%Sa%nModify


for f in *.ipynb; do
   olddate=$(stat -f %Sa-t %Y%m%d%H%M "$f")
   touch -m -t $olddate "$f"    
done


stat -f "Access (atime): %Sa%nModify (mtime): %Sm%nChange (ctime): %Sc%nBirth  (Btime): %SB" 2011_executions.csv



stat -f "%Sm" 4.2.png



for f in *.ipynb; do echo "${f%%.*}"; done

for f in *.ipynb; do 
    newdate=$(stat -f %SB "$f")
    echo "${f%%.*}" && echo $newdate 
done






recursive_list_4() {
  for d in *; do
    if [ -d "$d" ]; then
      (cd -- "$d" && recursive_list_4)
    fi
    if [[ $d == *.ipynb ]] ; then
        newdate=$(stat -f %SB -t %Y_%m_%d "$d")
        filename=${newdate}_${d%%.*}.
        echo "$filename"
    fi
  done
}



for f in *.ipynb; do 
    newdate=$(stat -f %SB -t %Y_%m_%d "$f")
    filename=${newdate}_${f%%.*}
    echo "$filename"
done




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


## RENAMING FILES WITH DATE

recursive_list_4() {
  for d in *; do
    if [ -d "$d" ]; then
      (cd -- "$d" && recursive_list_4)
    fi
    if [[ $d == *.pdf ]] ; then
        newdate=$(stat -f %SB -t %Y_%m_%d "$d")
        filename=${newdate}_${d%%.*}.pdf
        echo "$filename"
        cp $d all_files/"$filename" || cp $d ../all_files/"$filename"
    fi
  done
}


recursive_list_5() {
  for d in *; do
    if [ -d "$d" ]; then
      (cd -- "$d" && recursive_list_5)
    fi
      newdate=$(stat -f %SB -t %Y_%m_%d "$d")
      filename=${newdate}_${d##*/}
      echo "$filename"
      <!-- cp $d all_files/"$filename" || cp $d ../all_files/"$filename" -->
  done
}

recursive_list_5() {
  for d in *; do
    if [ -d "$d" ]; then
      (cd -- "$d" && recursive_list_5)
    fi
      newdate=$(stat -f %SB -t %Y_%m_%d "$d")
      filename=${newdate}_${d##*/}
      echo "$filename"
  done
}

## RENAME FILES (below not recursive)

recursive_list_6() {
  for d in *; do
    newdate=$(stat -f %SB -t %Y_%m_%d "$d")
    filename=${newdate}_${d##*/}
    echo "$filename"
    cp $d dated/"$filename" || cp $d ../dated/"$filename"
  done
}

for d in *; do
  newdate=$(stat -f %SB -t %Y_%m_%d "$d")
  filename=${newdate}_${d##*/}
  echo "$filename"
  cp $d "$filename" 
done