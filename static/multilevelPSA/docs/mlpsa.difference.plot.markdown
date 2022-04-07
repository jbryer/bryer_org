---
layout: default
title: multilevelPSA
subtitle: Multilevel Propensity Score Analysis
submenu: multilevelPSA
---

#### `mlpsa.difference.plot`: Creates a graphic summarizing the differences between treatment and comparison
 groups within and across level two clusters. ####

#### Description ####


 Creates a graphic summarizing the differences between
 treatment and comparison groups within and across level
 two clusters.


#### Usage ####

     
     mlpsa.difference.plot(x, xlab = "Difference Score",
     ylab = NULL, title = NULL, overall.col = "blue",
     overall.ci.col = "green", level2.point.size = NULL,
     level1.points = TRUE, errorbars = TRUE,
     level2.rug.plot = TRUE, jitter = TRUE, reorder = TRUE,
     labelLevel2 = TRUE, sd = NULL, ...)


#### Arguments ####

the results of [`mlpsa`](mlpsa.html) . label for the x-axis, or NULL to exclude. label for the y-aixs, or NULL to exclude. title of the figure, or NULL to exclude. the color of the overall results line. the color of the overall confidence interval. the point size of level 2 points. logical value indicating whether level 1 strata should be plotted. logical value indicating whether error bars should be plotted for for each level 1. logical value indicating whether a rug plot should be plotted for level 2. logical value indicating whether level 1 points should be jittered. logical value indicating whether the level two clusters should be reordered from largest difference to smallest. logical value indicating whether the difference for each level 2 should be labeled. If specified, effect sizes will be plotted instead of difference in the native unit. currently unused.

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
    mlpsa.difference.plot(results.psa.math, sd = mean(student.party$mathscore, na.rm = TRUE))

![plot of chunk mlpsa.difference.plot-example](mlpsa.difference.plot-example.png) 
