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

* Gamma is another TUNING PARAMETER for SVM
* The larger the gamma, the more wiggly the decision boundary, so when gamma is large, we are doing our best. And when we decrease gamma we do worse. 
* How do decide gamma? We use all our usual tools -- cross validation, and cost parameter C 
* With LINEAR support vector classifier we just have one tuning parameter, C

#### What happens if we have more than two classes?!

* OVA -- One Verse All (we take one and smush everything else into "All)
* OVO -- One Verse One (and we do this for every single one and you see which class wins the most pair-wise competitions )
* NOTE: OVA is used if number of classes is too large, otherwise OVO is favored  

* LOGISTIC REGRESSION solves classification problems by modeling the probabilities of the classes 
* With SVMs we are optimizing for the decision boundary

1. SVMs are powerful classifiers but the price we pay is interoperability 
2. With Logistic Regression (and the addition of the lasso etc.) we actually get probabilities which is very useful to us
3. Imagine telling a person she has a chance of cancer? She would want to know the percent probability, which logistic regression would give her, where SVM would just tell her yes she has a likelihood of cancer


QUIZ:

Recall that we obtain the ROC curve by classifying test points based on whether  𝑓̂ (𝑥)>𝑡 , and varying t.

How large is the AUC (area under the ROC curve) for a classifier based on a completely random function  𝑓̂ (𝑥)  (that is, one for which the orderings of the  𝑓̂ (𝑥𝑖)  are completely random)?

ANSWER:

0.5 

EXPLANATION 

If  𝑓̂ (𝑥)  is completely random, then  𝑓̂ (𝑥𝑖)  (and therefore the prediction for  𝑦𝑖 ) has nothing to do with  𝑦𝑖 . Thus, the true positive rate and the false positive rate are both equal to the overall positive rate, and the ROC curve hugs the 45-degree line.

### 9.5. SVMs in R

Generating a set of data and randomly classifying it leads to an interesting observation about SVMs:
1. Radial kernel gives an expected test error rate of 0.16350 (16%)
2. Linear kernel gives expected test error rate of 0.15791 (still 16% rounded, but slightly better) because the best decision boundary is truly linear 
3. Logistic regression is similar to SVM with a linear kernel 


---
### QUIZ:

Suppose that after our computer works for an hour to fit an SVM on a large data set, we notice that  𝑥4 , the feature vector for the fourth example, was recorded incorrectly (say, one of the decimal points is obviously in the wrong place).

However, your co-worker notices that the pair  (𝑥4,𝑦4)  did not turn out to be a support point in the original fit. He says there is no need to re-fit the SVM on the corrected data set, because changing the value of a non-support point can't possibly change the fit.

Is coworker correct? No. 

#### EXPLANATION:

When we change  𝑥4 , the fourth example might become a support point; if so, the fit may change. However, we could check whether  𝑥4,𝑦4  is still not a support point even after correcting the value. If so, then we really don't need to re-fit the model.


## OTHER RESOURCES:

[ML Mastery](https://machinelearningmastery.com/support-vector-machines-for-machine-learning/#:~:text=Support%20Vector%20Machines%20(Kernels)&text=The%20inner%20product%20between%20two,%2B%203*6%20or%2028.)

[datascience/chapter9.ipynb at master · luigiselmi/datascience](https://github.com/luigiselmi/datascience/blob/master/r/stat_learning/chapter9.ipynb)

[Support Vector Machines Using svm() function](https://rstudio-pubs-static.s3.amazonaws.com/271792_96b51b7fa2af4b3f808d04f3f3051516.html)

[ELI5 SVMs!](https://www.reddit.com/r/MachineLearning/comments/15zrpp/please_explain_support_vector_machines_svm_like_i/)

### Data prep for SVM:

* SVM works only with numeric data. If any categorical data, we need to convert that data to dummy variables 
* Basic SVM is for BINARY classification, two class classification. 