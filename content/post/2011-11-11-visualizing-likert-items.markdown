---
title: "Visualizing Likert Items"
author: "Jason Bryer"
date: 2011-11-11T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers"]
---

I have become quite a big fan of graphics that combine the features of traditional figures (e.g. bar charts, histograms, etc.) with tables. That is, the combination of numerical results with a visual representation has been quite useful for exploring descriptive statistics. I have wrapped two of my favorites (build around ggplot2) and included them as part of my <span style="font-family: 'courier new', courier;"><a href="https://github.com/jbryer/irutils">irutils</a></span> R package (currently under development). Here is the code and results utilizing two item from the 2009 <a href="http://www.pisa.oecd.org/">Programme of International Student Assessment</a> (PISA).

	library(devtools)
	install_github('irutils','jbryer')
	library(irutils)
	library(ggplot2)

	data(pisa)
	items29 = pisa[,substr(names(pisa), 1,5) == 'ST25Q']
	names(items29) = c("Magazines", "Comic books", "Fiction", "Non-fiction books", "Newspapers")
	for(i in 1:ncol(items29)) {
	     items29[,i] = factor(items29[,i], levels=1:5,
	     labels=c('Never or almost never', 'A few times a year', 'About once a month',
	          'Several times a month', 'Several times a week'), ordered=TRUE)
	}

	plotHeatmapTable(items29) + opts(title="How often do you read these materials because you want to?")

![img](http://jason.bryer.org/images/PISA29HeatmapTable.png)

	items28 = pisa[,substr(names(pisa), 1,5) == 'ST24Q']
	head(items28); ncol(items28)
	names(items28) = c("I read only if I have to.",
			"Reading is one of my favorite hobbies.",
			"I like talking about books with other people.",
			"I find it hard to finish books.",
			"I feel happy if I receive a book as a present.",
			"For me, reading is a waste of time.",
			"I enjoy going to a bookstore or a library.",
			"I read only to get information that I need.",
			"I cannot sit still and read for more than a few minutes.",
			"I like to express my opinions about books I have read.",
			"I like to exchange books with my friends")
	for(i in 1:ncol(items28)) {
		items28[,i] = factor(items28[,i], levels=1:4,
			labels=c('Strongly disagree', 'Disagree', 'Agree', 'Strongly Agree'), ordered=TRUE)
	}

	plotBarchartTable(items28, low.color='maroon', high.color='burlywood4')

![img](http://jason.bryer.org/images/PISA28BarchartTable1.png)

![img](http://jason.bryer.org/images/PISA28BarchartTable2.png)

