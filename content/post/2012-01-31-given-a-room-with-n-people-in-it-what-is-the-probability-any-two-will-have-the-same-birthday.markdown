---
title: "Given a room with n people in it, what is the probability any two will have the same birthday?"
author: "Jason Bryer"
date: 2012-01-31T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers"]
---

Revisiting a fun puzzle I remember first encountering as an undergraduate. Nice example of creating a plot in R using ggplot2. I also plot the probability of someone in the room having the same birthday as you.

![img](http://jason.bryer.org/images/BirthdayProblem.png)

	## See http://en.wikipedia.org/wiki/Birthday_problem for an explanation  of the problem
	require(ggplot2)
	require(reshape)

	theme_update(panel.background=theme_blank(),
				 panel.grid.major=theme_blank(),
				 panel.border=theme_blank())

	birthday <- function(n) {
		1 - exp( - n^2 / (2 * 365) )
	}

	myBirthday <- function(n) {
		1 - ( (365 - 1) / 365 ) ^ n
	}

	d = 200
	df = data.frame(n=1:d, AnyTwoSame=birthday(1:d), SameAsMine=myBirthday(1:d))
	df = melt(df, id.vars='n')

	ggplot(df, aes(x=n, y=value, colour=variable)) + geom_line() + scale_colour_hue('') +
		xlab('Number of People in Group') + ylab('Probability')
