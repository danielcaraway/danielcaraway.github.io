---
layout: single
title: UPY Notes"
permalink: /UPY/
---


## Section 1: Course Introduction

## Section 2: Environment Set-Up

## Section 3: Jupyter Overview

## Section 4: Python Crash Course

## Section 5: Python for Data Analysis - NumPy

## Section 6: Python for Data Analysis - Pandas

## Section 7: Python for Data Analysis - Pandas Exercises

## Section 8: Python for Data Visualization - Matplotlib

## Section 9: Python for Data Visualization - Seaborn

## Section 10: Python for Data Visualization - Pandas Built-in Data Visualization

## Section 11: Python for Data Visualization - Plotly and Cufflinks

## Section 12: Python for Data Visualization - Geographical Plotting

## Section 13: Data Capstone Project

## Section 14: Introduction to Machine Learning

### 78. Supervised Learning Overview

[Reference Slides](https://docs.google.com/presentation/d/1WurfW8OWRqjiSmzmwOW71iN6CEShkbfOnyETqTvf6BE/edit#slide=id.g404b920135_0_58)

* Supervised learning is machine learning with labels

### 79. Evaluating Performance - Classification Error Metrics

1. Accuracy = number correctly predicted. As a measure of fit, is only good when the labeled data is balanced (e.g. half dogs, half cats -- NOT people with disease vs people no disease)
2. Recall
   1. Ability to find ALL relevant cases
   2. `number of true positives / (number of true positives + number of false negatives)`
3. Precision
   1. Ability to identify ONLY relevant data points
   2. `number of true positives / (number of true positives + number of false positives)`
4. F1 is a measure of the harmonic mean of precision and recall, taking both metrics into account
5. NOTE: There is no "best measure of fit" -- it 100% depends on what you're trying to test for. (e.g. a false positive is much better than a false negative in cancer tests)

### 80. Evaluating Performance - Regression Error Metrics

1. MAE -- mean absolute error. PROBLEM: Does not punish outliers
2. MSE -- mean squared error. Solves the outlier problem, HOWEVER, the metric isn't easily translatable (as it is squared)
3. RMSE -- Root mean squared error. Takes the root of the MSE and solves both problems. 

### 81. Machine Learning with Python


## Section 15: Linear Regression

## Section 16: Cross Validation and Bias-Variance Trade-Off

## Section 17: Logistic Regression

## Section 18: K Nearest Neighbors

## Section 19: Decision Trees and Random Forests

## Section 20: Support Vector Machines

## Section 21: K Means Clustering

## Section 22: Principal Component Analysis

## Section 23: Recommender Systems

## Section 24: Natural Language Processing

## Section 25: Neural Nets and Deep Learning

## Section 26: Big Data and Spark with Python

## Section 27: BONUS SECTION: THANK YOU!
