---
layout: default
title: multilevelPSA
subtitle: Multilevel Propensity Score Analysis
submenu: multilevelPSA
---

#### `mlpsa.logistic`: Estimates propensity scores using logistic regression. ####

#### Description ####


 This method will estimate a separate logistic regression
 model for each level 2 (or cluster).


#### Usage ####

     
     mlpsa.logistic(vars, formula, level2, stepAIC = FALSE,
     ...)


#### Arguments ####

data frame containing the variables to estimate the logistic regression the logistic regression formula to use the name of the column containing the level 2 specification if true, the [`stepAIC`](stepAIC.html) from the `MASS` package will be used within each level. currently unused.

#### Value ####


 a list of glm classes for each level 2 or
 stepwise-selected model if stepAIC is true.


#### Seealso ####


 getPropensityScores


