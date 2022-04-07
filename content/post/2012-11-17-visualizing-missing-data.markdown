---
title: "Visualizing Missing Data"
author: "Jason Bryer"
date: 2012-11-17T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers"]
---

There are several graphics available for visualizing missing data including the [`VIM`](http://cran.r-project.org/web/packages/VIM/index.html) package. However, I wanted a plot specifically for looking at the nature of missingness across variables and a clustering variable of interest to support data preparation in multilevel propensity score models (see the [`multilevelPSA`](http://jbryer.github.com/multilevelPSA) package). The following examples uses data from the Programme of International Student Assessment (PISA; see [`pisa`](http://jbryer.github.com/pisa) package).

The required packages can be downloaded from github. Note that the `pisa` package is approximately 75mb.

	> require(devtools)
	> install_github('multilevelPSA', 'jbryer')
	> install_github('pisa', 'jbryer')

The following will setup the data to be plotted. There is a `pisa.setup.R` script included in the `multilevelPSA` package that is included to assist with a demo there. Among many things, it creates a vector `psa.cols` that defines the variables of interest in performing a propensity score analysis. These are the variables where missingness needs to be addressed.

	> require(multilevelPSA)
	> require(pisa)
	> data(pisa.student)
	> pkgdir = system.file(package='multilevelPSA')
	> source(paste(pkgdir, '/pisa/pisa.setup.R', sep=''))
	> student = pisa.student[,psa.cols]
	> student$CNT = as.character(student$CNT)

And finally, to create the graphic use the `plot.missing` command.

	> plot.missing(student[,c(4:48)], student$CNT)

![Missing Plot for 2009 PISA](http://jason.bryer.org/images/pisa-missing.png)
