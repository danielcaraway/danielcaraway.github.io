---
title: "ISL"
permalink: /projects/ISL/CH7
---

# 7. Moving Beyond Linearity

## OUTLINE A

1. Polynomial Regression
2. Step Functions
3. Basis Functions
4. Regression Splines
5. Smoothing Splines
6. Local Regression
7. Generalized Additive Models
8. LAB: Non-linear Modeling
9. Exercises

## OUTLINE B

1. Polynomial Regression
2. Step Functions
3. Basis Functions
4. Regression Splines
   1. Piecewise Polynomials
   2. Constraings and SPlines
   3. The Spline Basis Representation
   4. Choosing the Number and Locations of the Knots
   5. Comparison to Polynomial Regression
5. Smoothing Splines
   1. An overview of smoothing splines
   2. Choosing the smoothing paramater (lambda)
6. Local Regression
7. Generalized Additive Models
   1. GAMS for Regression Problems
   2. GAMS for Classification Problems
8. LAB: Non-linear Modeling
   1. Polynomial Regression and Step Functions
   2. Splines
   3. GAMS

## OUTLINE C: NOTES

What do we do with non-linear data? (Polynomial Regression)
How do we fit a piecewise constant function? (Step functions)

- Polynomial Regression
  - Extends the Linear Model by raising each of the predictors to a power
  - EX: cubic regression is X, X^2, X^3 as predictors
  - Provides a simple way to fit non-linear data
- Step Functions
  - Cuts a predictor K into many pieces making a quantitative variable a qualitative variable

### NOTES FROM VIDEO

Create new variables as TRANSFORMATIONS of the original variables

EX: x1 = x, x2 = x^2, x3 = x^3

POINTWISE: showing at any given POINT what the standard error is
(NOT Global Confidence Bands)

pointwise-variances

#### STEP FUNCTIONS

Another way of fitting nonlinearities

- Popular in epidemiology and biostatistics

HOW TO:

1. cut your continuous variable into discrete sub-ranges

Turns into a "Piecewise Constant Model"

### NOTES FROM QUIZ

What can we add to linear models to capture non-linear effects?

- Spline terms
- Polynomial terms
- Interactions
- Step functions

  7.2

Explanation

Every function in the basis must be continuous at t, and we must be able to represent any piecewise linear function with a single knot at t as a linear combination of the functions in the basis.

## Smoothing Splines

### 7.3 (In Videos) 7.5 (In book)

Smoothing a spline is a way to fit data without having to worry about knots
You can estimate the smoothing parameter by cross-validation
Leave One Out cross validation is attractive with spine-smoothing because, like linear regression, there is some tidy math behind it

in R `smooth.spline(age, wage)`

### 7.3.1 QUIZ

In terms of model complexity, which is more similar to a smoothing spline with 100 knots and 5 effective degrees of freedom?

A natural cubic spline with 5 knots

---BOOK

## 7.6 Local Regression

## 7.7 Generalized Additive Models

### 7.7.1 GAMS for Regression Problems

### 7.7.2 GAMS for Classification Problems

--- VIDEOS

## 7.4 Generalized Additive Models and Local Regression

- GAMS allow for non-linearity in several variables
- We like GAMS because you can retain the additivity of linear models and they are easy to interpret
- GAMS are "additive" meaning there aren't interactions in the model

git s
