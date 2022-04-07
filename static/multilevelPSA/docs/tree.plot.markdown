---
layout: default
title: multilevelPSA
subtitle: Multilevel Propensity Score Analysis
submenu: multilevelPSA
---

#### `tree.plot`: Heat map representing variables used in a conditional inference tree across level 2 variables. ####

#### Description ####


 This figure provides a summary of the covariates used
 within each level two cluster along with their relative
 importance. Covariates are listed on the y-axis and level
 two clusters along the x-axis. Cells that are shaded
 indicate that that covariate was present in the
 conditional. The shade of the color represents the
 highest level witin the tree that covariate appeared.
 That is, the darkest color, or depth 1, corresponds to
 the covariate used at the root of the tree, or the first
 split.


#### Usage ####

     
     tree.plot(x, colNames, level2Col, colLabels = NULL,
     color.high = "azure", color.low = "steelblue",
     color.na = "white", ...)


#### Arguments ####

the results of [`mlpsa.ctree`](mlpsa.ctree.html) the columns to include in the graphic the name of the level 2 column. column labels to use. This is a data frame with two columns, the first column should match the values in `trees` and the second column the description that will be used for labeling the variables. color for variables with greater relative importance as determined by occurring sooner in the tree (closer to the root split). color for variables with less relative importance as determined by occurring later in the tree (further from the root split). color for variables that do not occur in the tree. currently unused.

#### Value ####


 a ggplot2 expression


#### Seealso ####


 plot.mlpsa


#### Examples ####


    
    require(party)
    data(pisana)
    data(pisa.colnames)
    data(pisa.psa.cols)
    mlctree = mlpsa.ctree(pisana[, c("CNT", "PUBPRIV", pisa.psa.cols)], formula = PUBPRIV ~ 
        ., level2 = "CNT")

    ## 
  |                                                                       
  |                                                                 |   0%
  |                                                                       
  |======================                                           |  33%
  |                                                                       
  |===========================================                      |  67%
  |                                                                       
  |=================================================================| 100%

    student.party = getStrata(mlctree, pisana, level2 = "CNT")
    tree.plot(mlctree, level2Col = pisana$CNT)

![plot of chunk tree.plot-example](tree.plot-example.png) 
