---
layout: default
title: multilevelPSA
subtitle: Multilevel Propensity Score Analysis
submenu: multilevelPSA
---

The `multilevelPSA` R package provides functions for estimating and visualizing multilevel propensity score analysis (PSA) models. This package is currently under development in support of my dissertation work. However, the development version can be installed using the `devtools` package.

	require(devtools)
	install_github('multilevelPSA', 'jbryer')
	demo('pisa')
		
![PISA Mathematics](pisaMath.png)

Figure 1. [Multilevel PSA Assessment Plot: PISA Mathematics for Private and Public Schools](pisaMath.pdf)

![PISA Mathematics Difference Plot](pisaMathDiff.png)

Figure 2. [Multilevel PSA Difference Plot: PISA Mathematics for Private and Public Schools](pisaMathDiff.pdf)

![PISA Conditional Inference Tree Plot](pisaTreeHeat.png)

Figure 3. [Multilevel PSA Conditional Inference Trees Heat Plot](pisaTreeHeat.pdf)
