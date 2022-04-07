---
layout: default
title: multilevelPSA
subtitle: Multilevel Propensity Score Analysis
submenu: multilevelPSA
---

Bryer, J.M., & Pruzek, R.M. (2011). Abstract: An international comparison of private and public schools using multilevel propensity score methods and graphics. *Multivariate Behavioral Research*. *46*,6, 1010-1011.

> As can be seen from the recent Special Issue of MBR on propensity score analysis (PSA) methods, the use of PSA has gained increasing popularity for estimating causal effects in observational studies. However, PSA use with multilevel or clustered data has been limited, and to date there seems to have been no development of specialized graphics for such data. This paper introduces the [`multilevelPSA`](http://jbryer.github.com/multilevelPSA) package for R that provides cluster-based functions for estimating propensity scores as well as graphics to exhibit results for multilevel data. This work extends to the multilevel case the framework for visualizing propensity score analysis introduced by Helmreich and Pruzek (2009). International data from the Programme for International Student Assessment (Organization for Economic Co-operation and Development, 2009) are comprehensively examined to compare private with public schools on reading, mathematics, and science outcomes after adjusting for covariate differences in the multilevel context.

> Particularly for analyses of large data sets, focusing on statistical significance is limiting. As can readily be seen, overall results favor “private” over “public” schools, at least for end of secondary school math achievement. But the graphics provide a more nuanced understanding of the nature and magnitude of adjusted differences for countries. Furthermore, the graphics are readily interpreted by a nontechnical audience. Broadly speaking, it is seen that modern graphics can enhance and extend conventional numerical summaries by focusing on details of what data have to say for multilevel comparisons of many countries based on propensity score methods.

#### Multilevel PSA Assessment Plot: 2009 PISA Math
![Math multilevelPSA Asssessment Plot](Math-CircPSA.png "Multilevel PSA Assessment Plot: Math")

>FIGURE 1. Multilevel assessment plot for the math assessment given at the end of secondary school. Each point corresponds to overall adjusted means for stratifications using conditional inference trees. Size of each point corresponds to number of students sampled within each country. Points are projected to a “cross” on the line in the lower left representing the distribution of difference scores. Overall mean difference and confidence interval represented by dashed line parallel to the unit line indicates a small overall positive effect for private schools.