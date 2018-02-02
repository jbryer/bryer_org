---
title: "Rgitbook Package for Using R Markdown with Gitbook"
author: "Jason Bryer"
date: 2014-04-22T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers"]
---

Last week I [published an R script](http://jason.bryer.org/posts/2014-04-18/Gitbook_with_R_Markdown.html) to interface with [Gitbook](http://www.gitbook.io/). I received some positive feedback and decided to include all the code in an R package. This also allowed me to make some nice additions including default support for MathJax. It is currently available on Github and can be installed using `devtools`:

	devtools::install_github('jbryer/Rgitbook')

I have only tested this on Mac OS X, so please provide suggestions or issues on other systems. And of course, I wrote the documentation using the Gitbook framework. That is available here: [jason.bryer.org/Rgitbook](http://jason.bryer.org/Rgitbook)
