---
layout: single
title: 'BASH NOTES'
---

jupyter nbconvert --execute --to html notebook.ipynb



BASH SCRIPT:

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