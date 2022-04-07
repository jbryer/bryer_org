---
layout: default
title: multilevelPSA
subtitle: Multilevel Propensity Score Analysis
submenu: multilevelPSA
---

#### `mlpsa.distribution.plot`: Plots distribution for either the treatment or comparison group. ####

#### Description ####


 Plots distribution for either the treatment or comparison
 group.


#### Usage ####

     
     mlpsa.distribution.plot(x, treat, fill.colours = NULL,
     flip = TRUE, label = treat, level2.label = NULL,
     legendlab = NULL, axis.text.size = 8, ...)


#### Arguments ####

the results of [`mlpsa`](mlpsa.html) . the group to plot. This must be one of the two levels of the treatment variable. if specified, the colors to use for level 2 points. if TRUE, the level 2 clusters will be on the y-axis and the outcome variable on the x-axis. Otherwise reversed. the label to use for the axis. the axis label for the level 2 indicators. the label for the legend, or NULL to exclude a legend. the size of the axis text currently unused.

#### Seealso ####


 plot.mlpsa


