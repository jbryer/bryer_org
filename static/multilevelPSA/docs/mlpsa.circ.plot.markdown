---
layout: default
title: multilevelPSA
subtitle: Multilevel Propensity Score Analysis
submenu: multilevelPSA
---

#### `mlpsa.circ.plot`: Plots the results of a multilevel propensity score model. ####

#### Description ####


 The plot created uses the `ggplot2` framework. As
 such, additional modificaitons can be made. This plot is
 an extension of the `circ.psa` function in the
  `PSAgraphics` package for multilevel models.


#### Usage ####

     
     mlpsa.circ.plot(x,
     xlab = names(multilevelPSA$level2.summary)[4],
     ylab = names(multilevelPSA$level2.summary)[5],
     legendlab = "Level 2", title = NULL,
     overall.col = "blue", overall.ci.col = "green",
     level1.plot = FALSE, level1.point.size = NULL,
     level1.rug.plot = NULL,
     level1.projection.lines = FALSE, level2.plot = TRUE,
     level2.point.size = NULL,
     level2.rug.plot = geom_rug_alt,
     level2.projection.lines = TRUE, level2.label = FALSE,
     unweighted.means = FALSE, weighted.means = FALSE,
     fill.colours = NULL, ...)


#### Arguments ####

the results of [`mlpsa`](mlpsa.html) . label for the x-axis. label for the y-axis. the label for the legend, or NULL to exclude. title for the figure. the color used for the overall results. the color used for the confidence intervals. logical value indicating whether level 1 points should be plotted. the size of level 1 points the geom to use for plotting a level 1 rug. Possible values are geom_rug (for left and bottom), geom_rug_alt (for top and right), or NULL (to exclude). logical value indicating whether level 1 project lines (parallel to the unit line) are drawn. logical value indicating whether level 2 points should be plotted. the size of level 2 points the geom to use for plotting a level 2 rug. Possible values are geom_rug (for left and bottom), geom_rug_alt (for top and right), or NULL (to exclude). logical value indicating whether level 2 project lines (parallel to the unit line) are drawn. logical value indicating whether level 2 points should be labeled. logical value indicating whether horizontal and vertical lines are drawn representing the unweighted (i.e. unadjusted from phase I of PSA) means for each level 2, or cluster. logical value indicating whether horizontal and vertical lines are drawn representing the weighted means for each level 2, or cluster. if specified, the colors to use for level 2 points. currently unused.

#### Seealso ####


 plot.mlpsa


#### Examples ####


    
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
    student.party$mathscore = apply(student.party[, paste0("PV", 1:5, "MATH")], 
        1, sum)/5
    results.psa.math = mlpsa(response = student.party$mathscore, treatment = student.party$PUBPRIV, 
        strata = student.party$strata, level2 = student.party$CNT, minN = 5)
    mlpsa.circ.plot(results.psa.math, legendlab = FALSE)  #+ opts(legend.position='none')

![plot of chunk mlpsa.circ.plot-example](mlpsa.circ.plot-example.png) 
