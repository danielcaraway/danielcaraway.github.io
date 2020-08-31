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


---
## GENERAL NOTES

### ELI5 ANOVA?

ANOVA = Analysis of Variance 

[From Reddit](https://www.reddit.com/r/explainlikeimfive/comments/16gt7r/eli5_ttest_and_anova/)

START: We want to measure all the 5 year olds in the world

PROBLEM: There are wayyy too many 5 year olds for us to do this in a day!

SOLUTION: Take a small sample of 5 year olds, maybe the 5 year olds in your town

PROBLEM: What if there is something in the water that causes all the 5 year olds in your town to be slightly taller, on average, than 5 year olds of another town?

SOLUTION: We can get more samples (maybe call your friend two towns over, and your cousin in another state)  and do a T-test!

-- From the reddit post

How do we know that the difference in heights isn't due to chance alone?

That's where the T-Test comes in. The T-Test allows us to compare results in terms of that variation. It allows us to say with confidence that the kids in Bigtown are taller than kids in Littletown (we call this "statistical significance") or that the 1-inch difference likely was found due to natural randomness in our samples.

Now ANOVA also deals with variation (in fact ANOVA stands for "Analysis of Variance"), but in a slightly different way. When comparing two or more groups, say the height of the five-year-olds in Mr. Smith's, Mrs. Jones, and Dr. Baker's classes, we want to know if there really is a significant difference in height. We do this by comparing the amount of variation within each group, vs the amount of variation between each group. If there's a lot of variation within each class (lots of tall kids and short kids), and only a little bit of variation between each class (the average height of each class is about the same), then it's harder to say that the result is "significant" -- it might be due to chance alone. However if it's the other way around, then we can be relatively confident that the difference is real.


## Interview with Jerome Friedman

* Responsible for a lot of applied techniques used in this course! Such as CART!
* Jon Bentley developed k-d trees
* Programs in FourTran for fun, as a hobby :D 
* Started to rethink k-d trees for nearest neighbor because he was interested in pattern recognition and learning