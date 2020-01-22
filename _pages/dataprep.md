--- 
layout: single
title: "Data Prep"
permalink: /dataprep/
---

## Counting Unique

df.groupby(['group']).agg(['min','max','count','nunique'])

df.groupby('param')['group'].nunique()

## Dealing with Skewness

As mentioned in most of the answers that there are various ways of dealing with skewed data. I would just like to highlight that SMOTE is one of the recommended ways to overcome this skewness.

All of the above answers covers the techniques to overcome the issue. If you choose to do upsampling/downsampling then the imblearn package in python can helpful. It includes several techniques to deal with imbalanced data in general. (I wanted to add as comment in Rahul's answer but don't have enough reputations.) – smm Feb 4 at 0:13

via [SO](https://datascience.stackexchange.com/questions/32818/train-test-split-of-unbalanced-dataset-classification)
[SMOTE](https://imbalanced-learn.readthedocs.io/en/stable/generated/imblearn.over_sampling.SMOTE.html)

When you want it [stratified](https://stackoverflow.com/questions/46340697/stratified-balanced-sampling-from-unbalanced-data-machine-learning)