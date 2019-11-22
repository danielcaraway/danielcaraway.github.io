--- 
layout: single
title: "Python Cheatsheet"
permalink: /python/
---

## Plotting a table using matplotlib

[SO](https://stackoverflow.com/questions/32137396/how-do-i-plot-only-a-table-in-matplotlib)

## BAR CHARTS!!

[BAR CHARTS!! ](https://danielcaraway.github.io/html/WK_5_Seaborn.html)

## Change colors in heatmaps

[heatmaps](https://python-graph-gallery.com/92-control-color-in-seaborn-heatmaps/)

## Pretty confusion matrix

[pretty blue squares](https://scikit-learn.org/stable/auto_examples/model_selection/plot_confusion_matrix.html)

## ZOOM IN

plt.xlim(0.5,0.7)
plt.ylim(0.5,0.7)

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


## SEABORN GROUPBY

```python
df_2 = df.groupby('A').sum()
df_2.reset_index(inplace=True)
sns.barplot(x='A', y='B', data=df_2);