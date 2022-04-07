---
layout: default	
title: multilevelPSA
subtitle: Visualizing Missing Data
published: true
status: publish
submenu: multilevelPSA
---
 
Missingness is a common issue when analyzing large datasets. Moreover, logistic regression which is a common method to estimate propensity scores requires there to be no missing data. The `multilevelPSA` package includes a function `missing.plot` to provide a visualization to help understand the nature and extent of missingness within and across the levels of interest. The following example requires the [`pisa`](/pisa) package in addition to the `multilevelPSA` package since the North America subset of PISA included in the `multilevelPSA` package does not have any missing data (missing data has been imputed using the `mice` package).
 

    require(multilevelPSA)
    require(pisa)
    data(pisa.student)
    data(pisa.psa.cols)
    student = pisa.student[, c("CNT", pisa.psa.cols)]
    student$CNT = as.character(student$CNT)
    missing.plot(student, student$CNT)

![plot of chunk missingplot](/images/figure/missingplot.png) 

