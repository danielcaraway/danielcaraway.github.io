---
layout: single
title: "How to use Data Science Superpowers for Useless Things: Who do I text most?"
tags: howto
---

## Who do I text the most?

```python
df = pd.read_csv('Messages_06_2015_to_08_2019_all - Messages_06_2015_to_08_2019_all.csv')
p_df = pd.DataFrame(df.groupby('person')['text'].count())
p_df.sort_values(by="text")

```