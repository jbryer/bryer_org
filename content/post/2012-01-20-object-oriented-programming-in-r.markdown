---
title: "Object Oriented Programming in R"
author: "Jason Bryer"
date: 2012-01-20T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers"]
---

As someone who was a Java programmer for many years learning R's object oriented programming framework has been frustrating to say the least. I like the simplicity of S3 but find it limiting when you wish to write methods that change the underlying data elements. That is, printing, summarizing, and plotting work great because they generally do not require changes to the data in the class passed to it. After much experimenting it occurred to me that perhaps I could achieve a more Java like behavior by adding functions to the class. For simple things this works great. To make it even more flexible I found that if you change the list to an environment before assigning the class allows one to change lists within the list.

The following example models the framework for an email class (without actually doing anything useful). That is, I want a class that contains an email address and name and the ability to send email. I would also like to save a history of the emails sent. As can be seen, functions that work with atomic variables are pretty straight forward. Working with lists require (well maybe required, if you know of a better way leave a comment) using the assign function. This may not produce the cleanest source code but (IMHO) provides a better experience for the user.

###### Constructor

	EmailClass <- function(name, email) {
		nc = list(
			name = name,
			email = email,
			get = function(x) nc[[x]],
			set = function(x, value) nc[[x]] <<- value,
			props = list(),
			history = list(),
			getHistory = function() return(nc$history),
			getNumMessagesSent = function() return(length(nc$history))
		)
		#Add a few more methods
		nc$sendMail = function(to) {
			cat(paste("Sending mail to", to, 'from', nc$email))
			h <- nc$history
			h[[(length(h)+1)]] <- list(to=to, timestamp=Sys.time())
			assign('history', h, envir=nc)
		}
		nc$addProp = function(name, value) {
			p <- nc$props
			p[[name]] <- value
			assign('props', p, envir=nc)
		}
		nc <- list2env(nc)
		class(nc) <- "EmailClass"
		return(nc)
	}

###### Define S3 generic method for the print function.
	print.EmailClass <- function(x) {
		if(class(x) != "EmailClass") stop();
		cat(paste(x$get("name"), "'s email address is ", x$get("email"), sep=''))
	}

###### Test code
	test <- EmailClass(name="Jason", "jason@bryer.org")
	test$addProp('hello', 'world')
	test$props
	test
	class(test)
	str(test)
	test$get("name")
	test$get("email")
	test$set("name", "Heather")
	test$get("name")
	test
	test$sendMail("jbryer@excelsior.edu")
	test$getHistory()
	test$sendMail("test@domain.edu")
	test$getNumMessagesSent()

	test2 <- EmailClass("Nobody", "dontemailme@nowhere.com")
	test2
	test2$props
	test2$getHistory()
	test2$sendMail('nobody@exclesior.edu')
