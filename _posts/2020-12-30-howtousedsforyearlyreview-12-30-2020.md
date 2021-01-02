---
layout: single
title: "How to use Data Science Superpowers for Useless Things: Finding Trends in Self Data"
tags: howto yearlyreview 
---

## woman log


1. DELETE PAGE NUMBERS: `^\d.*`
2. DELETE NEWLINES: `^\n`
3. SEPARATE DATE FROM NOTES: FIND: `(, \d\d\d\d)` & REPLACE: `$1 ----`
4. PUT NOTE ON ONE LINE: FIND: `\r?\n(\W.*)` & REPLACE: ` $1` 
5. PUT NOTE ON ONE LINE TAKE 2: FIND: `\r?\n^((?!\w\w\w\s))(.*)` & REPLACE: ` $2`