---
layout: single
title: "How to use Data Science Superpowers for Useless Things: Organizing Ancient Projects, pt2"
tags: howto portfolio bash EHD
---



## EDITED

FIRST `brew install coreutils`

```bash
recursive_list_5() {
for d in *; do
  if [ -d "$d" ]; then
    (cd -- "$d" && recursive_list_5)
  fi
  newdate=$(stat -f %SB -t %Y__%m__%d "$d")
  filepath=$(realpath "$d")
  arrIN=(${filepath//\// })
  filename=${newdate}____${arrIN[1]}
  newname=`echo $filename | sed -e 's/ /_/g'`; 
  mv "$d" "$newname"
done
}
```

## INITIAL ATTEMPT

```bash
recursive_list_5() {
for d in *; do
  if [ -d "$d" ]; then
    (cd -- "$d" && recursive_list_5)
  fi
  newdate=$(stat -f %SB -t %Y__%m__%d "$d")
  filepath=$(realpath "$d")
  arrIN=(${filepath//\// })
  # new=$(IFS=_; echo ${arrIN[@]})
  # new= $(IFS=_ eval 'joined="${arrIN[@]}"')
  # echo $new
  new=""
  for i in "${arrIN[@]}"; do
      echo "$i"
      echo "next"
      new+=($i)
  done
  echo "$arrIN[1]"
  filename=${newdate}____${arrIN[1]}
  newname=`echo $filename | sed -e 's/ /_/g'`; 
  # echo "$filename"
  mv "$d" "$newname"
done
}

```