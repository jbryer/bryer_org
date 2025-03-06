---
title: "User Input using tcl/tk"
author: "Jason Bryer"
date: 2012-08-13T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers"]
---

I was inspired by Kay Cichini  recent post on creating a a tcl/tk dialog box for users to enter variable values. I am going to have a use for this very soon so took some time to make it a bit more generic. What I wanted is a function that takes a vector (of variable names) of arbitrary length, create a dialog box for an input for each, and return the values in a list. While I was at it I also provided an optional separate vector for the labels (defaults to the variable names) that the user will see and a vector of functions used to convert the text input into another data format (e.g. convert characters to numeric values). Obviously using built in functions works great but one could also easily exploit this feature to write custom data validation functions. The function is hosted on Gist and embedded bellow. Here are some very basic examples:

Dialog box with two variables.

	> vals <- varEntryDialog(vars=c('Variable1', 'Variable2'))

![](http://jason.bryer.org/images/VariableUI1.jpg)

	> str(vals)
	List of 2
	$ Variable1: chr "value 1"
	$ Variable2: chr "value 2"

Dialog box with two variables, custom labels, and converts one to an integer.

	> vals <- varEntryDialog(vars=c('Var1', 'Var2'), labels=c('Enter an integer:', 'Enter a string:'), fun=c(as.integer, as.character))

![](http://jason.bryer.org/images/VariableUI2.jpg)

	> str(vals)
	List of 2
	$ Var1: int 5
	$ Var2: chr "abc"

Dialog box with validation.

	> vals <- varEntryDialog(vars=c('Var1'), labels=c('Enter an integer between 0 and 10:'), fun=c(
	function(x) {
	     x <- as.integer(x)
	     if(x >= 0 & x <= 10) {
	         return(x)
	     } else {
	         stop("Why didn't you follow instruction!\nPlease enter a number between 0 and 10.")
	     }
	 } ))

![](http://jason.bryer.org/images/VariableUI3.jpg)

![](http://jason.bryer.org/images/VariableUI4.jpg)

![](http://jason.bryer.org/images/VariableUI5.jpg)

	> str(vals)
	List of 1
	$ Var1: int 2

User inputs a comma separated list that is split into a character vector.

	> vals <- varEntryDialog(vars=c('Var1'),
	     labels=c('Enter a comma separated list of something:'),
	     fun=c(function(x) {
	         return(strsplit(x, split=','))
	 }))

![](http://jason.bryer.org/images/VariableUI6.jpg)

	> vals$Var1
	[[1]]
	[1] "a" "b" "c"
	> str(vals)
	List of 1
	$ Var1:List of 1
	..$ : chr [1:3] "a" "b" "c"
