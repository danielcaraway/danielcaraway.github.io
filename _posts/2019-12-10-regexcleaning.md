---
layout: single
title: 'regex to clean class outline'
tags: regex 
---

## NOTE: Remember to confirm the regex button is ACTUALLY CHECKED in VSCode

(Page |Assignment )( Completed| Not completed).+

(Assignment )( Complete).+

(Assignment |Page | )( Not completed| Complete).+

---

Completed.+

Not Completed.+

Page


## Get rid of anything with a slash in the line
.+(?=/).+$

## Remove line if it starts with a digit

^\d.+

## Remove lines that start with space

^\n

## Formatting markdown
(if it starts with a space)
^\s
(replace it with... `####`)
(if it starts with a 'W')
^W
(replace it with `## W`)