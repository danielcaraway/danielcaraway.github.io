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

- Supervised learning is machine learning with labels

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

1. scikit-learn tries to be the same across all modeling families (see below)
2. some methods will be available only to supervised learning algorithms (and others only for unsupervised)
3. X and Y are passed to supervised learning algos (because that is LABELED data) and only X is passed to unsupervised learning algos

#### On ALL ESTIMATORS/ALGOS

- `model.fit()` -- fit training data (for supervised, this accepts X and y (`model.fit(X,y)`) -- for unsupervised, just X (`model.fit(X)`))
- SUPERVISED: `model.predict()` (this takes the new data `model.predict(X_new)` and returns the learned label for each object in the passed data)
- SUPERVISED: `model.predict_proba()` for clssification rpoblems, some estimators use this to return the probability the new observation has each categorical label. Label with highest probability is returned by model.predict()
- SUPERVISED: `model.score()` (scores are betwen 0 and 1, closer to 1 being better fit)
- UNSUPERVISED: `model.predict()` as well (predict labels in clustering algos)
- UNSUPERVISED: `model.transform()` accepts X_new
- UNSUPERVISED: `model.fit_transform()`

## Section 15: Linear Regression

Originally "regression" came from a study in the 1800s about a father's and the height of his sons. It was shown that while a father's height is important, the more important factor is the overall mean of the population. The son's height tended to be closer to the overall average height of all the people. Meaning height REGRESSES towards the mean.

Our goal with linear regression, is to draw a line that's as close as possible to every single data point. If we have only two points, this line will simply hit both of those points. If there are many points, our goal is to find THE BEST line. Well, what's THE BEST line? There are a few ways to measure this but the overall goal is to minimize the distance between ALL the points and their distance to our line.

1. Things tend to regress towards the mean
2. Linear regression is finding a line that is as close as possible to every data point
3. How do we find "the best" line? We try to minimize the distance between each point and our line
4. What is our "distance measure"? -- If we are using the Least Squares Method (sum of squares of the residuals)

NOTE:

`from sklearn.cross_validation import train_test_split`

has been changed to :

`from sklearn.model_selection import train_test_split`

---

### Linear Regression with Python Pt 1:

Split into X and y, toss out language

df.columns
X = df[[columns (without predictor column -- PRICE --  or address bc it's NLP)]]

y = column we want

use documentation to tuples for traintest split
X_train, X_test, etc.
(UPY has test_size=0.4 and random_State=101)

from sklearn.linear_model (use tab) import LinearRegression model

then instantiate it
`lm = LinearREgression()`

lm. HIT TAB to see all available methods on the model

we want lm.fit()
(we only want to train the training data)

PRINT COEFF = `lm.coef_`
PRINT INTERCEPT: `lm.intercept_`

make a df of COEF

cdf = pd.DataFrame(lm.coef\_, X.columns)

In English -- a one unit increase (holding all others constant) results in the COEFF increase in hosue price

### QUICK REVIEW:

1. Grab data
2. Do quick EDA
3. Separate our data into X and y (features and what we are trying to predict)
4. Import the model (in this case, Linear Regression)
5. Fit that model to the training data

## Section 16: Cross Validation and Bias-Variance Trade-Off

## Section 17: Logistic Regression

## Section 18: K Nearest Neighbors

## Section 19: Decision Trees and Random Forests

## Section 20: Support Vector Machines

## Section 21: K Means Clustering

## Section 22: Principal Component Analysis

## Section 23: Recommender Systems

### GOAL -- take notes while NOT WATCHING LECTURE

Then, recreate what I learned with my notes

1. import pandas and numpy
2. create column_names ['userid', itemid, rating, timestamp]
3. df = pd.read_csv u,data sep="\t" (tab separated data)
4. check head
5. MOVIE LENS dataset
6. grab the movie titles from a separate csv
7. pd.merge(df, movie_titles, on="item_id")
8. Now explore the data
9. Import matplotlib.pyplot as plt
10. import seaborn as sns
11. sns.set_Style('white')
12. matplotlib line
13. ratings df
14. avg rating number of ratings
15. groupby title rating mean()
16. sort_values(ascending=False)
17. get MOST ratings (count)
18. Add number of ratings column
19. `sns.jointplot(x='rating',y='num of ratings', data=ratings, alpha=0.5)

PART TWO!

1. Create a matrix that has user ids on one axis and movie titles on another axis (each cell has rating the user gave that movie)
2. Use PIVOT TABLE to get this matrix

### PART TWO, AGAIN! 02-03-21

1. Make a matrix with `df.pivot_table`
2. Pick movies to test our recommender with!
   1. using our ratings df, sort_values (ascending=False)
   2. get JUST the ratings for those selected movies (e.g. star wars and liar liar)
   3. our_matrix['Star Wars (1977)']
3. Find movies similar to our test movies with the `corrwith` function!
4. Makd a df out of this, drop the na,
5. But wait?! These don't really coorelate with Star Wars!?
6. We should drop anything that has fewer than 100 ratings
7.

NOTE: We use JOIN instead of MERGE when we have to dfs with the same index (in this case, `title`)

### HTML

<div>
<h1> Testing this thing </h1>
{% for file in site.static_files %}
    {% if file.path contains 'UPY' %}
        {% if file.extname contains '.html' %}
            <div><a href="https://danielcaraway.github.io/{{ file.path }}">{{ file.basename }}</a></div>
        {% endif %}
    {% endif %}
{% endfor %}
</div>

### PYTHON

<div>
<h1> Testing this thing </h1>
{% for file in site.static_files %}
    {% if file.path contains 'UPY' %}
        {% if file.extname contains '.py' %}
            <div><a href="https://danielcaraway.github.io/{{ file.path }}">{{ file.basename }}</a></div>
        {% endif %}
    {% endif %}
{% endfor %}
</div>

## Section 24: Natural Language Processing

## Section 25: Neural Nets and Deep Learning

## Section 26: Big Data and Spark with Python

## Section 27: BONUS SECTION: THANK YOU!
