---
title: "Graphic Parameters (symbols, line types, and colors) for ggplot2"
author: "Jason Bryer"
date: 2012-04-27T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers"]
---

Following up on [John Mount's post](http://www.win-vector.com/blog/2012/04/how-to-remember-point-shape-codes-in-r/comment-page-1/#comment-6354) on remembering symbol parameters in ggplot2, I decided to give it a try and included symbols, line types, and colors (based upon Earl Glynn's wonderful [color chart](http://research.stowers-institute.org/efg/R/Color/Chart/index.htm)).  Code follows below.

	require(ggplot2)
	require(grid)

	theme_update(panel.background=theme_blank(),
				 panel.grid.major=theme_blank(),
				 panel.border=theme_blank())

	#Borrowed (i.e. stollen) from http://research.stowers-institute.org/efg/R/Color/Chart/ColorChart.R
	getColorHexAndDecimal <- function(color) {
		if(is.na(color)) {
			return(NA)
		} else {
			c <- col2rgb(color)
			return(sprintf("#%02X%02X%02X   %3d %3d %3d", c[1],c[2],c[3], c[1], c[2], c[3]))
		}
	}

##### Symbols

	ggplot(data=data.frame(x=c(0:25))) + geom_point(size=10, aes(x=x,y=x,shape=x)) +
		facet_wrap(~ x, scales='free') + xlab('') + ylab('') +
		scale_shape_identity() +
		opts(axis.text.x=theme_blank(), axis.text.y=theme_blank(),
			axis.ticks=theme_blank(), legend.position='none')
	ggsave('symbols.png')

<img src='http://jason.bryer.org/images/symbols-894x1024.png' width='90%'>

##### Line types

	ggplot(data=data.frame(x=c(1:6))) + geom_hline(size=2, aes(yintercept=x, linetype=x)) +
		scale_linetype_identity() +
		xlab(NULL) + ylab(NULL) + xlim(c(0,100)) +
		opts(axis.text.x=theme_blank(), axis.ticks=theme_blank(), legend.position='none')
	ggsave('linetypes.png', width=6.5, height=2)


<img src='http://jason.bryer.org/images/linetypes1-1024x315.png' width='90%'>

##### Colors
	df = data.frame(x=rep(1:26, 26), y=rep(1:26, each=26))
	df$c = NA
	df[1:length(colors()),'c'] = colors()
	df$n = NA
	df[1:length(colors()),'n'] = 1:length(colors())
	df$r = df$g = df$b = NA
	df[1:length(colors()),c('r','g','b')] = t(col2rgb(colors()))
	df$text = ifelse(apply(df[,c('r','g','b')], 1, sum) > (255*3/2), 'black', 'white')
	df$hex = lapply(df$c, getColorHexAndDecimal)
	df$hex2 = paste(format(df$n, width=3), format(df$c, width=(max(nchar(df$c))+1)), format(df$hex, width=(max(nchar(df$hex))+1)))

	ggplot(df, aes(x=x, y=y, fill=c, label=n)) + geom_tile() + geom_text(aes(colour=text), size=3) +
		scale_fill_identity() +
		scale_colour_identity() +
		xlab(NULL) + ylab(NULL) +
		opts(axis.text.x=theme_blank(), axis.ticks=theme_blank(), plot.margin=unit(c(0,0,0,0), "cm"),
			 axis.text.y=theme_blank(), axis.ticks=theme_blank(), legend.position='none')
	ggsave('colors.png')

<img src='http://jason.bryer.org/images/colors1-894x1024.png' width='90%'>

This last one is only the first 100 elements in colors(). Use the script file to generate the remaining plots if you like.

	ggplot(df[1:100,], aes(x=1, y=n, fill=c, label=hex2, colour=text)) +
		geom_tile() + geom_text(family = 'mono') +
		scale_fill_identity() +
		scale_colour_identity() +
		xlab(NULL) + ylab(NULL) +
		opts(axis.text.x=theme_blank(), axis.ticks=theme_blank(), plot.margin=unit(c(0,0,0,0), "cm"),
			 axis.text.y=theme_blank(), axis.ticks=theme_blank(), legend.position='none')

![Colors](http://jason.bryer.org/images/colors100-384x1024.png)

