---
title: "ISL"
permalink: /projects/ISL/CH9
---

[CODE HERE](https://courses.edx.org/asset-v1:StanfordOnline+STATSX0001+1T2020+type@asset+block/ch9.html)

[The Math Behind SVMs](https://shuzhanfan.github.io/2018/05/understanding-mathematics-behind-support-vector-machines/)

## OUTLINE FROM LECTURES

### 9.1 Optimal Separating Hyperplanes

There is no probability model -- it just looks for a hyperplane that separates the classes in a direct way

QUESTION
If 𝛽 is not a unit vector but instead has length 2, then ∑𝑝𝑗=1𝛽𝑗𝑋𝑗 is

ANSWER
twice the signed Euclidean distance from the separating hyperplane ∑𝑝𝑗=1𝛽𝑗𝑋𝑗=0

EXPLANATION
We know 𝛽′=12𝛽 has length 1, so it is a unit vector in the same direction as 𝛽 . Therefore, ∑𝑝𝑗=1𝛽𝑗𝑋𝑗=2∑𝑝𝑗=1𝛽′𝑗𝑋𝑗 , where ∑𝑝𝑗=1𝛽′𝑗𝑋𝑗 is the Euclidean distance.

### 9.2 Support Vector Classifier

If N > P, data is often not separable by a linear boundary.

HOWEVER, in problems like genomics and other problems with a lot of y-data, the sample points are less than the dimensions and...

When the number of sample points is less than the number of dimensions (y) you can always separate with a hyperplane.

QUESTION

If we increase C (the error budget) in an SVM, do you expect the standard error of 𝛽 to increase or decrease?

ANSWER

Decrease

EXPLANATION

Increasing C makes the margin "softer," so that the orientation of the separating hyperplane is influenced by more points.

### 9.3 Feature Expansion and the SVM

* We can quickly and simply give ourselves more features by raising existing features to the power of 2,3,4 etc... X^2, X^3 etc.. `(X1, X2, X1^2, X2^2, X1*X2)`
* When we do this, we add dimensions. The more dimensions we have, the more likely we will find a separator

#### Nonlinearities and Kernels

* We don't like doing polynomial regression with a degree bigger than 3 (even cubic polynomial space is a big space)
* K is computing the INNER PRODUCT between the target point X and each subsequent X in the sample
* Alpha is non-zero only for those in the support set 

#### REVIEW QUESTIONS

##### QUESTION

True or False: If no linear boundary can perfectly classify all the training data, this means we need to use a feature expansion.

##### ANSWER

False

##### Explanation

As in any statistical problem, we will always do better on the training data if we use a feature expansion, but that doesn't mean we will improve the test error. Not all regression lines should perfectly interpolate all the training points, and not all classifiers should perfectly classify all the training data.


---

##### QUESTION

True or False: The computational effort required to solve a kernel support vector machine becomes greater and greater as the dimension of the basis increases.

##### ANSWER

False

##### Explanation

The beauty of the "kernel trick" is that, even if there is an infinite-dimensional basis, we need only look at the n^2 inner products between training data points.

### 9.4 Example and Comparison with Logistic Regression

### 9.5. SVMs in R



## OTHER RESOURCES:

[ML Mastery](https://machinelearningmastery.com/support-vector-machines-for-machine-learning/#:~:text=Support%20Vector%20Machines%20(Kernels)&text=The%20inner%20product%20between%20two,%2B%203*6%20or%2028.)

### Data prep for SVM:

* SVM works only with numeric data. If any categorical data, we need to convert that data to dummy variables 
* Basic SVM is for BINARY classification, two class classification. 