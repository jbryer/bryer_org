---
title: "Comparing two data frames with different number of rows"
author: "Jason Bryer"
date: 2013-01-24T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers"]
---

I posted a question over on [StackOverflow](http://stackoverflow.com/questions/14485040/is-there-an-efficient-way-of-comparing-two-data-frames) on an efficient way of comparing two data frames with the same column structure, but with different rows. What I would like to end up with is an *n* x *m* logical matrix where *n* and *m* are the number of rows in the first and second data frames, respectively; and the value at the *i*th row and *j*th column indicates whether all the values from row *i* from data frame one is equal to row *j* from data frame two. To provide some context, this will be used in a propensity score matching algorithm to identify candidate matches that match exactly on any number of covariates. In addition to the approaches I had, [joran](http://stackoverflow.com/users/324364/joran) provided an approach using the `Vectorize` function (thanks again as I learned another nice function). I decided to put three approaches to a race...

To understand what I need, I'll start with a small example with two data frames, one with 4 rows, the other with 3, and each has two variables, one logical and the other numeric. As an aside, I only need this to work for integers, factors, characters, and logical types therefore avoiding issues of comparing numerics.


	> df1 <- data.frame(row.names=1:4, var1=c(TRUE, TRUE, FALSE, FALSE), var2=c(1,2,3,4))
	> df2 <- data.frame(row.names=5:7, var1=c(FALSE, TRUE, FALSE), var2=c(5,2,3))
	> df1
	   var1 var2
	1  TRUE    1
	2  TRUE    2
	3 FALSE    3
	4 FALSE    4
	> df2
	   var1 var2
	5 FALSE    5
	6  TRUE    2
	7 FALSE    3

First, let's consider the case when there is only one variable:

	> system.time({
	+ 	df3 <- sapply(df2$var1, FUN=function(x) { x == df1$var1 })
	+ 	dimnames(df3) <- list(row.names(df1), row.names(df2))
	+ })
	   user  system elapsed
	      0       0       0
	> df3
	      5     6     7
	1 FALSE  TRUE FALSE
	2 FALSE  TRUE FALSE
	3  TRUE FALSE  TRUE
	4  TRUE FALSE  TRUE

This is pretty straight forward. Now I want the same type of result, but to compare more than one column (in the final implementation I need to handle any number of columns so not necessarily limited to one or two).

The first approach uses nested apply functions.

	> system.time({
	+ 	m1 <- t(as.matrix(df1))
	+ 	m2 <- as.matrix(df2)
	+ 	df4 <- apply(m2, 1, FUN=function(x) { apply(m1, 2, FUN=function(y) { all(x == y) } ) })
	+ })
	   user  system elapsed
	  0.001   0.000   0.001
	> df4
	      5     6     7
	1 FALSE FALSE FALSE
	2 FALSE  TRUE FALSE
	3 FALSE FALSE  TRUE
	4 FALSE FALSE FALSE

Secondly, using the `Vectorize` and `outer` functions.

	> system.time({
	+ 	foo <- Vectorize(function(x,y) { all(df1[x,] == df2[y,]) })
	+ 	df5 <- outer(1:nrow(df1), 1:nrow(df2), FUN=foo)
	+ })
	   user  system elapsed
	  0.005   0.000   0.006
	> df5
	      [,1]  [,2]  [,3]
	[1,] FALSE FALSE FALSE
	[2,] FALSE  TRUE FALSE
	[3,] FALSE FALSE  TRUE
	[4,] FALSE FALSE FALSE

Lastly, we'll create a new character vector by pasting the other variables together.

	> system.time({
	+ 	df1$var3 <- apply(df1, 1, paste, collapse='.')
	+ 	df2$var3 <- apply(df2, 1, paste, collapse='.')
	+ 	df6 <- sapply(df2$var3, FUN=function(x) { x == df1$var3 })
	+ 	dimnames(df6) <- list(row.names(df1), row.names(df2))
	+ })
	   user  system elapsed
	  0.000   0.000   0.001
	> df6
	      5     6     7
	1 FALSE FALSE FALSE
	2 FALSE  TRUE FALSE
	3 FALSE FALSE  TRUE
	4 FALSE FALSE FALSE

We can already see with this small example that the `Vectorize` approach is the slowest. However, let's try a larger example. First we'll create two data frames, one with 1,000 rows and the second with 1,500. The resulting matrix will be 1,000 x 1,500.

	set.seed(2112)
	df1 <- data.frame(row.names=1:1000,
					  var1=sample(c(TRUE,FALSE), 1000, replace=TRUE),
					  var2=sample(1:10, 1000, replace=TRUE) )
	df2 <- data.frame(row.names=1001:2500,
					  var1=sample(c(TRUE,FALSE), 1500, replace=TRUE),
					  var2=sample(1:10, 1500, replace=TRUE))

Nested `apply` functions approach:

	> system.time({
	+ 	m1 <- t(as.matrix(df1))
	+ 	m2 <- as.matrix(df2)
	+ 	df4 <- apply(m2, 1, FUN=function(x) { apply(m1, 2, FUN=function(y) { all(x == y) } ) })
	+ })
	   user  system elapsed
	 10.807   0.043  11.096

`Vectorize` approach:

	> system.time({
	+ 	foo <- Vectorize(function(x,y) { all(df1[x,] == df2[y,]) })
	+ 	df5 <- outer(1:nrow(df1), 1:nrow(df2), FUN=foo)
	+ })
	   user  system elapsed
	390.904   0.808 392.134

Combined columns approach:

	> system.time({
	+ 	df1$var3 <- apply(df1, 1, paste, collapse='.')
	+ 	df2$var3 <- apply(df2, 1, paste, collapse='.')
	+ 	df6 <- sapply(df2$var3, FUN=function(x) { x == df1$var3 })
	+ 	dimnames(df6) <- list(row.names(df1), row.names(df2))
	+ })
	   user  system elapsed
	  0.421   0.000   0.422

The combined column approach is by far the fasted way, and it makes good since. It is a bit surprising (at least to me), how much worse the `Vectorize` and `outer` functions are. Moreover, I am a bit concerned about potential issues with the `paste` method and doing comparisons on those results. Please feel free to leave comments below if there are other approaches.
