---
layout: default
title: multilevelPSA
subtitle: Multilevel Propensity Score Analysis
submenu: multilevelPSA
---

#### `psrange`: Estimates models with increasing number of comparision subjects starting from
 1:1 to using all available comparison group subjects. ####

#### Description ####


 Estimates models with increasing number of comparision
 subjects starting from 1:1 to using all available
 comparison group subjects.


#### Usage ####

     
     psrange(df, treatvar, formula, nsteps = 10, nboot = 10,
     samples = seq(length(which(treatvar == 1)), length(which(treatvar == 0)), (length(which(treatvar == 0)) - length(which(treatvar == 1)))/nsteps),
     ...)


#### Arguments ####

data frame with variables to pass to glm vector representing treatment placement. Should be coded as 0s (for control) and 1s (for treatment). formula for logistic regression model number of steps to estimate from 1:1 to using all control records. number of models to execute for each step. the sample sizes to draw from control group for each step. other parameters passed to glm.

#### Value ####


 a class of psrange that contains a summary data frame, a
 details data frame, and a list of each individual result
 from glm.


