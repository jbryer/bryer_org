---
layout: default
title: multilevelPSA
subtitle: Multilevel Propensity Score Analysis
submenu: multilevelPSA
---

#### `difftable.plot`: This function produces a ggplot2 figure contianing the mean differences for
 each level two, or cluster. ####

#### Description ####


 This function produces a ggplot2 figure contianing the
 mean differences for each level two, or cluster.


#### Usage ####

     
     difftable.plot(x, fill.colours = NULL, legendlab = NULL,
     ...)


#### Arguments ####

the results of [`mlpsa`](mlpsa.html) . the colours to use for each level two. the label to use for the legend, or NULL to exclude. currently unused.

#### Value ####


 a ggplot2 figure


