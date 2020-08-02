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