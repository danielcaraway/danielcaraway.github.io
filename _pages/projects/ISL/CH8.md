---
title: "ISL"
permalink: /projects/ISL/CH8
---

# 7. Tree Based Methods

## VIDEO OUTLINE

[Lecture Slides](https://courses.edx.org/assets/courseware/v1/62c570de505d28b78e8e4ea932daddf2/asset-v1:StanfordOnline+STATSX0001+1T2020+type@asset+block/trees-handout.pdf)

### 8.1 Tree-based Methods

### 8.2 More details on Trees

- Bushy trees have high variance -- they are overfitting the data and likely not going to predict well

#### PRUNING:

- A good strategy is to build a large tree and PRUNE it back to obtain a SUBTREE
- Cost Complexity Pruning, aka weakest link pruning
  - Similar to LASSO in regression
  - We use Cross Validation to help us choose alpha

Cross Validation is what we use to help us prune our tree -- it will show us where our error is reduced (look at baseball example, and we can see the cv is lowest at 3) so we can tell our tree to have three terminal nodes.

### 8.3 Classification Trees

If response is a _categorical variable_, we call that a CLASSIFICATION TREE!!

#### How do we split?!

Binary (into two parts), recursively (meaning over and over until an end case is met)

#### What is the criteria for splitting?

We can't use RSS (like in regression), so we use classification error rate (which is just the fraction of the training data that does not match the classification criterion)

NEED TO VERIFY but if we have 8 cats and 1 turtle, our error rate would be 1/9 as we'd assume cats and we'd be wrong 1 out of the 9 times we were guessing which random household creature Colin was holding. (This is not including the fact that we hold Leo less because he is less "holdable" than a cat. Also, salmonella, apparently.)

Gini index: if it is small, one class is favored and the rest are all really small.

PROS OF DECISION TREES!

- Easy to understand by non subject matter experts

CONS OF DECISION TREES:

- Not great at predictability

![trees vs linear models](IISL_CH8_TREES.png "Trees")

### 8.4 Bagging and Random Forests

### 8.5 Boosting

### 8.R -- Tree-Based methods in R

### Chapter 8 Quiz
