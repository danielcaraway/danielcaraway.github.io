---
title: "ISL"
permalink: /projects/ISL/
---

# Introduction to Statistical Learning 

[Symbols](https://www.rapidtables.com/math/symbols/Statistical_Symbols.html)

## OUTLINE A

1. Introduction
2. Statistical Learning
3. Linear Regression
4. Classification
5. Resampling Methods
6. Linear Model Selection and Regularization
7. Moving Beyond Linearity
8. Tree-Based Methods
9. Support Vector Machines
10. Unsupervised Learning

## OUTLINE B

### 1. Introduction

### 2. Statistical Learning

1. What is Statistical Learning?
2. Assessing Model Accuracy
3. LAB: Intro to R
4. EXERCISES

### 3. Linear Regression

1. Simple Linear Regression
2. Multiple Linear Regression
3. Other considerations in the Regression Model
4. The Marketing Plan
5. Comparison of Linear Regression with K-Nearest Neighbors
6. LAB: Linear Regression
7. EXERCISES

### 4. Classification

1. An Overview of Classification
2. Why Not Linear Regression?
3. Logistic Regression
4. Linear Discriminant Analysis
5. A Comparison of Classification Methods
6. LAB: Logistic Regression, LDA, QDA and KNN
7. EXERCISES

### 5. Resampling Methods

1. Cross-Validation
2. The Bootstrap
3. LAB: Cross-Validation and the Bootstrap
4. EXERCISES

### 6. Linear Model Selection and Regularization

1. Subset Selection
2. Shrinkage Methods
3. Dimension Reduction Methods
4. Considerations in High Dimensions
5. LAB 1: Subset Selection Methods
6. LAB 2: Ridge Regression and the Lasso
7. LAB 3: PCR and PLS Regression
8. EXERCISES

### 7. Moving Beyond Linearity

1. Polynomial Regression 
2. Step Functions
3. Basic Functions
4. Regression Splines
5. Smoothing Splines
6. Local Regression
7. Generalized Additive Models
8. LAB: Non-Linear Modeling
9. EXERCISES

### 8. Tree-Based Methods

1. The Basics of Decision Trees
2. Bagging, Random Forests, Boosting
3. LAB: Decision Trees

### 9. Support Vector Machiens

1. Maximal Margin Classifier
2. Support Vector Classifiers
3. Support Vector Machines
4. SVMs with More than Two Classes
5. Relationship to Logistic Regression
6. LAB: Support Vector Machines
7. EXERCISES

### 10. Unsupervised Learning

1. The CHallenge of Unsupervised Learning
2. Principal Components Analysis
3. Clustering Methods
4. LAB 1: Principal Components Analysis
5. LAB 2: Clustering
6. LAB 3: NC160 Data Example
7. EXERCISES 

## CHAPTER OUTLINES

### Chapter 1: Introduction

### Chapter 2: Statistical Learning 

1. What is Statistical Learning?
   1. Why Estimate F?
   2. How do we estimate F?
   3. The Trade-Off between Prediction Accuracy and Model Interpretability
   4. Supervised versus  Unsupervised Learning
   5. Regression Versus Classification Problems 
2. Assessing Model Accuracy
   1. Measuring the Quality of Fit
   2. The Bias-Variance Trade-Off
   3. The Classification Setting
3. LAB: Intro to R
4. EXERCISES


#### 2.1: What is Statistical Learning?

TL;DR: A set of approaches for estimating f 
(Where f is a function of X, our predictors/input variables, that equal Y our output variable)
   1. Why Estimate F?
      1. Prediction
         1. f can be a black box
         2. EX: We want to see if this patient's blood sample will tell us if this person is at high risk for something
         * Who will respond positively to a mailing? 
      1. Inference
         1. When we want to understand the relationship between X and Y 
         2. How Y changes as a function of X
         3. f cannot be a black box
         * Which predictors are associated with the response?
         * What is the relationship between the response and each predictor?
         * Can the relationship between Y and each predictor be adequately summarized using a linear equation or is the relationship more complicated? 
         * What effect will changing the price of a product have on sales?
         * How much extra will a house be worth if it has a view of the river?
      TL;DR -- Linear is good for inference, non-linear is better for prediction (and worse for interpretability)

   2. How do we estimate F?
      1. Parametric Methods
         1. Trying to fit to a linear model
         2. DEF: reduce the problem of estimating f down to one of estimating a set of PARAMETERS
      2. Non-parametric Methods
         1. DEF: Seek an estimate of f that gets as close to the dta points as possible without being too rough or wiggly 
         2. Large number of observations needed
   3. The Trade-Off between Prediction Accuracy and Model Interpretability
      1. Inflexible == more linear == less accurate, easier to interpret
      2. Flexible == non linear (think svms) == more accurate, harder to interpret 
   4. Supervised versus Unsupervised Learning
      1. SUPERVISED: For each observation of the predictor measurements (xi), there is an associated response measurement (yi)
         1. PREDICTION: Accurately predict the response for future observations
         2. INFERENCE: Better understand the relationship between the response and predictors 
      2. UNSUPERVISED: "Flying blind" -- it's not possible to fit a linear regression bc we don't have a response variable that can "supervise" our analysis. 
   5. Regression Versus Classification Problems 

#### 2.2: Assessing Model Accuracy
   1. Measuring the Quality of Fit
   2. The Bias-Variance Trade-Off
   3. The Classification Setting
      1. The Bayes Classifier
      2. K-Nearest Neighbors
      3. 
