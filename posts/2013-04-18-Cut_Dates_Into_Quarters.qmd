---
title: "Cut Dates into Quarters"
author: "Jason Bryer"
date: 2013-04-18T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers"]
---

Frequently I need to recode a date column to quarters. For example, at [Excelsior College](http://www.excelsior.edu) we have continuous enrollment so we report new enrollments per quarter. To complicate things a bit, our fiscal year starts in July so that July, August, and September represent the first quarter, January, February, and March are actually the third quarter. But sometimes we do need need to report out based upon calendar years (i.e. where January is in the first quarter). I am sure this is pretty common practice in many disciplines. There are probably other ways to do this in R (please comment below about other methods), but could not find one that satisfies my needs.

We can begin by `source`ing the function from [Gist](https://gist.github.com/jbryer/5412193) using the `devtools` package.

	require(devtools)
	source_gist(5412193)

Create a vector of `Dates`.

	> dates <- as.Date(c('2013-04-03','2012-03-30','2011-10-31',
	                   '2011-04-14','2010-04-22','2004-10-04',
	                   '2000-02-29','1997-12-05','1997-04-23',
	                   '1997-04-01'))

The default is to use the typical academic fiscal year with the year staring July 1.

	> getYearQuarter(dates)
	 [1] FY2013-Q4 FY2012-Q3 FY2012-Q2 FY2011-Q4 FY2010-Q4 FY2005-Q2 FY2000-Q3 FY1998-Q2 FY1997-Q4
	[10] FY1997-Q4
	65 Levels: FY1997-Q4 < FY1998-Q1 < FY1998-Q2 < FY1998-Q3 < FY1998-Q4 < FY1999-Q1 < ... < FY2013-Q4

However, it easy to use get a quarters within a calendar year.

	> getYearQuarter(dates, firstMonth=1)
	 [1] FY2013-Q2 FY2012-Q1 FY2011-Q4 FY2011-Q2 FY2010-Q2 FY2004-Q4 FY2000-Q1 FY1997-Q4 FY1997-Q2
	[10] FY1997-Q2
	65 Levels: FY1997-Q2 < FY1997-Q3 < FY1997-Q4 < FY1998-Q1 < FY1998-Q2 < FY1998-Q3 < ... < FY2013-Q2

You can also alter the format of the levels using the `fy.prefix`, `quarter.prefix`, and `sep` parameters.

	> getYearQuarter(dates, 1, '', '', '')
	 [1] 20132 20121 20114 20112 20102 20044 20001 19974 19972 19972
	65 Levels: 19972 < 19973 < 19974 < 19981 < 19982 < 19983 < 19984 < 19991 < 19992 < ... < 20132

Lastly, the function by default will create a level for each quarter between the minimum and maximum dates in the date vector passed in. You can override the range for defining the levels with the `level.range` parameter. If the specified range is smaller than the range of the passed in vector, the function will print a warning because values outside that range will be returned as `NA`.

	> getYearQuarter(dates, level.range=as.Date(c('2010-01-01','2013-01-01')))
	 [1] <NA>      FY2012-Q3 FY2012-Q2 FY2011-Q4 FY2010-Q4 <NA>      <NA>      <NA>      <NA>
	[10] <NA>
	13 Levels: FY2010-Q3 < FY2010-Q4 < FY2011-Q1 < FY2011-Q2 < FY2011-Q3 < FY2011-Q4 < ... < FY2013-Q3
	Warning message:
	In getYearQuarter(dates, level.range = as.Date(c("2010-01-01", "2013-01-01"))) :
	  The range of x is greater than level.range. Values outside level.range will be returned as NA.

Here is a link to the [Gist](https://gist.github.com/jbryer/5412193) or copy-and-paste from below.

	#' Returns the year (fiscal or calendar) and quarter in which the date appears.
	#'
	#' This function will cut the given date vector into quarters (i.e. three month
	#' increments) and return an ordered factor with levels defined to be the quarters
	#' between the minimum and maximum dates in the given vector. The levels, by
	#' default, will be formated as \code{FY2013-Q1}, however the \code{FY} and \code{Q}
	#' can be changed using the \code{fy.prefix} and \code{quarter.prefix} parameters,
	#' respectively.
	#'
	#' @param x vector of type \code{\link{Date}}.
	#' @param firstMonth the month corresponding to the first month of the fiscal year.
	#'        Setting \code{firstMonth=1} is equivalent calenadar years.
	#' @param fy.prefix the character string to paste before the year.
	#' @param quarter.prefix the character string to paste before the quarter.
	#' @param sep the separater between the year and quarter.
	#' @param level.range the range to use for defining the levels in the returned
	#'        factor.
	#' @export
	#' @examples
	#' 	dates <- as.Date(c('2013-04-03','2012-03-30','2011-10-31',
	#' 	                   '2011-04-14','2010-04-22','2004-10-04',
	#' 	                   '2000-02-29','1997-12-05','1997-04-23',
	#' 	                   '1997-04-01'))
	#' 	getYearQuarter(dates)
	#' 	getYearQuarter(dates, firstMonth=1)
	#' 	getYearQuarter(dates, 1, '', '', '')
	#' 	\dontrun{
	#' 	getYearQuarter(dates, level.range=as.Date(c('2010-01-01','2013-01-01')))
	#' 	}
	getYearQuarter <- function(x,
						   firstMonth=7,
						   fy.prefix='FY',
						   quarter.prefix='Q',
						   sep='-',
						   level.range=c(min(x), max(x)) ) {
		if(level.range[1] > min(x) | level.range[2] < max(x)) {
			warning(paste0('The range of x is greater than level.range. Values ',
						   'outside level.range will be returned as NA.'))
		}
		quarterString <- function(d) {
			year <- as.integer(format(d, format='%Y'))
			month <- as.integer(format(d, format='%m'))
			y <- ifelse(firstMonth > 1 & month >= firstMonth, year+1, year)
			q <- cut( (month - firstMonth) %% 12, breaks=c(-Inf,2,5,8,Inf),
			      labels=paste0(quarter.prefix, 1:4))
			return(paste0(fy.prefix, y, sep, q))
		}
		vals <- quarterString(x)
		levels <- unique(quarterString(seq(
			as.Date(format(level.range[1], '%Y-%m-01')),
			as.Date(format(level.range[2], '%Y-%m-28')), by='month')))
		return(factor(vals, levels=levels, ordered=TRUE))
	}
