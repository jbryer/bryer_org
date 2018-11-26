---
layout: default
title: multilevelPSA
subtitle: Multilevel Propensity Score Analysis
submenu: multilevelPSA
---

#### `loess.plot`: Loess plot with density distributions for propensity scores and outcomes on
 top and right, respectively. ####

#### Description ####


 Loess plot with density distributions for propensity
 scores and outcomes on top and right, respectively.


#### Usage ####

     
     loess.plot(x, response, treatment, responseTitle = "",
     treatmentTitle = "Treatment",
     percentPoints.treat = 0.1,
     percentPoints.control = 0.01)


#### Arguments ####

vector of propensity scores. the response variable. the treatment varaible as a logical type. the percentage of treatment points to randomly plot. the percentage of control points to randomly plot. the label to use for the y-axis (i.e. the name of the response variable) the label to use for the treatment legend.

#### Value ####


 a ggplot2 figure


#### Seealso ####


 plot.mlpsa


#### Examples ####


    
    require(multilevelPSA)
    require(party)
    data(pisana)
    data(pisa.psa.cols)
    cnt = "USA"  #Can change this to USA, MEX, or CAN
    pisana2 = pisana[pisana$CNT == cnt, ]
    pisana2$treat <- as.integer(pisana2$PUBPRIV)%%2
    lr.results <- glm(treat ~ ., data = pisana2[, c("treat", pisa.psa.cols)], family = "binomial")
    st = data.frame(ps = fitted(lr.results), math = apply(pisana2[, paste("PV", 
        1:5, "MATH", sep = "")], 1, mean), pubpriv = pisana2$treat)
    st$treat = as.logical(st$pubpriv)
    loess.plot(st$ps, response = st$math, treatment = st$treat, percentPoints.control = 0.4, 
        percentPoints.treat = 0.4)

![plot of chunk loess.plot-example](loess.plot-example.png) 
