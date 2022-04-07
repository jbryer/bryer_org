---
title: "Converting a list to a data frame"
author: "Jason Bryer"
date: 2013-01-30T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers"]
---

There are many situations in R where you have a `list` of `vector`s that you need to convert to a `data.frame`. This question has been addressed over at [StackOverflow](http://stackoverflow.com/questions/4227223/r-list-to-data-frame) and it turns out there are many different approaches to completing this task. Since I encounter this situation relatively frequently, I wanted my own S3 method for `as.data.frame` that takes a `list` as its parameter. I should note that it only works with atomic vectors (i.e. logical, integer, numeric, complex, character and raw). If any one of the elements in the `list` are of some other class type, the function will call `NextMethod`. However, on my R instance at least, this will end up calling `as.data.frame.default` which will in turn throw an error.

To use the function you can source the function directly from Gist using the `source_gist` function in the `devtools` package.

	require(devtools)
	source_gist(4676064)

Or you can download the code at [https://gist.github.com/4676064](https://gist.github.com/4676064)

#### Example One

In this first example we have a list with two vectors, each with the same length and the same names.

	> test1 <- list( c(a='a',b='b',c='c'), c(a='d',b='e',c='f'))
	> as.data.frame(test1)
	  a b c
	1 a b c
	2 d e f

#### Example Two

In this example we have a list of two vectors, same length, but only one has names. The function in this case will use the names from the first vector with names for the column names of the data frame.

	> test2 <- list( c('a','b','c'), c(a='d',b='e',c='f'))
	> as.data.frame(test2)
	  a b c
	1 a b c
	2 d e f

#### Example Three

This example has two named vectors, but only have one overlapping named element.

	> test3 <- list('Row1'=c(a='a',b='b',c='c'), 'Row2'=c(a='d',var2='e',var3='f'))
	> as.data.frame(test3)
	     a    b    c var2 var3
	Row1 a    b    c <NA> <NA>
	Row2 d <NA> <NA>    e    f

#### Example Four

This is an example of what to avoid, three vectors of differing lengths and not named. The number of columns in the resulting data frame will be equal to the longest vector. For vectors less than that, `NA`s will be filled in on the right most columns. This method will also print a warning.

	> test4 <- list('Row1'=letters[1:5], 'Row2'=letters[1:7], 'Row3'=letters[8:14])
	> as.data.frame(test4)
	     Col1 Col2 Col3 Col4 Col5 Col6 Col7
	Row1    a    b    c    d    e <NA> <NA>
	Row2    a    b    c    d    e    f    g
	Row3    h    i    j    k    l    m    n
	Warning message:
	In as.data.frame.list(test4) :
	  The length of vectors are not the same and do not are not named, the results may not be correct.

#### Example Five

Another example of equal length vectors.

	> test5 <- list(letters[1:10], letters[11:20])
	> as.data.frame(test5)
	  X1 X2 X3 X4 X5 X6 X7 X8 X9 X10
	1  a  b  c  d  e  f  g  h  i   j
	2  k  l  m  n  o  p  q  r  s   t

#### Example Six

This example shows the warning (and likely error too) that occurs when all of the elements of the list are not atomic vectors.

	> test6 <- list(list(letters), letters)
	> as.data.frame(test6)
	Error in as.data.frame.default(test6, row.names = NULL, optional = FALSE) :
	  cannot coerce class '"list"' into a data.frame
	In addition: Warning message:
	In as.data.frame.list(test6) : All elements of the list must be a vector.
