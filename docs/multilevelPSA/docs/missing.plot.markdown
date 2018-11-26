---
layout: default
title: multilevelPSA
subtitle: Multilevel Propensity Score Analysis
submenu: multilevelPSA
---

#### `missing.plot`: Returns a heat map graphic representing missinging of variables grouped by
 the given grouping vector. ####

#### Description ####


 NOTE: This is an experimental function and the results
 may vary depending on the nature of the dataset.


#### Usage ####

     
     missing.plot(x, grouping, grid = FALSE,
     widths = c(unit(3, "null"), unit(1, "inches")),
     heights = c(unit(1, "inches"), unit(3, "null")),
     color = "red", ...)


#### Arguments ####

a data frame containing the variables to visualize missingness a vector of length nrow(vars) corresponding to how missing will be grouped by whether to draw a grid between tiles the ratio of the widths of the heatmap and histogram. the ratio of the heights of the heatmap and histogram. the color used for indicating missingness. currently unused.

#### Value ####


 a ggplot2 expression


#### Seealso ####


 plot.mlpsa


