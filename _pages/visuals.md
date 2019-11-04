--- 
layout: single
title: "Python Cheatsheet"
permalink: /python/
---

## BAR CHARTS!!

[BAR CHARTS!! ](https://danielcaraway.github.io/html/WK_5_Seaborn.html)

## Change order of bar charts

add ```order=['one', 'two','three']```

like so

```python
sns.catplot(x="Answer.sentiment.label", 
            y="WorkTimeInSeconds", 
            kind="bar", 
            order=['Negative', 'Neutral', 'Positive'], 
            data=pos)
plt.title('Positive')
```