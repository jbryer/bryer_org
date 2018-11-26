---
layout: default
title: multilevelPSA
subtitle: Multilevel Propensity Score Analysis
submenu: multilevelPSA
---

#### `getStrata`: Returns a data frame with two columns corresponding to the level 2 variable
 and the leaves from the conditional inference trees. ####

#### Description ####


 Returns a data frame with two columns corresponding to
 the level 2 variable and the leaves from the conditional
 inference trees.


#### Usage ####

     
     getStrata(party.results, data, level2)


#### Arguments ####

the results of  [`mlpsa.ctree`](mlpsa.ctree.html) the data frame to merge results to the name of the level 2 variable.

#### Value ####


 a data frame


#### Seealso ####


 mlpsa.ctree


