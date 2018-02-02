---
title: "Function to Simplify Loading and Installing Packages"
author: "Jason Bryer"
date: 2014-02-20T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers"]
---

One of the more tedious parts of working with R is maintaining my R library. To make my R scripts reproducible and sharable, I will install packages if they are not available. For example, the top of my R scripts tend to look something like this:

	if(!require(devtools) | !require(ggplot2) | !require(psych) | !require(lme4) | !require(benchmark)) {
		install.packages(c('devtools','ggplot2','psych','lme4','benchmark'))
	}

This has worked fine for some time, but I felt there was a better approach. First, note that if any one package doesn't load (usually because it is not installed), all the packages are installed. I could separate the if statement so there is one per package, but then I have even more lines in my R script. Instead, I have written a function that will load each package separately and install only those that are not present. And optionally will even update packages using the `update` parameter. For example, I can now replace the above with one call to `package`:

	> package(c('devtools','ggplot2','psych','lme4','benchmark'))

The output is minimal by default (set `quiet=FALSE` to get all the messages printed by `require` and `install.packages`). Even though `verbose=TRUE` by default, the only messages it will print is to indicate that a newer version of a package is available or that the package is not available on the repositories. In place of output to the console, a data frame is returned with a summary of what packages have been loaded and/or installed along with the loaded and available versions. Here are the results from the command above:

	A newer version of lme4 is available (current=1.0.5; available=1.0.6)

	          loaded installed loaded.version available.version
	devtools    TRUE     FALSE          1.4.1             1.4.1
	ggplot2     TRUE     FALSE        0.9.3.1           0.9.3.1
	psych       TRUE     FALSE        1.4.2.3           1.4.2.3
	lme4        TRUE     FALSE          1.0.5             1.0.6
	benchmark   TRUE      TRUE          0.3.5             0.3.5

Note that if I had specified `update=TRUE` (it is `FALSE` by default) the `lme4` package would have been automatically updated.

In summary, I have collapsed what usually takes several lines within my R scripts to just one line, or two if you need to source this function. However, I just source this function in my `.Rprofile` so that it is always available. The only potential downside is that this is not part of base R and requires anyone you share your R scripts with to also have this function available.

The sourse code is on Gist here: [https://gist.github.com/jbryer/9112634](https://gist.github.com/jbryer/9112634)
With `devtools` installed you can just source function using:

	> source_gist(9112634)

<script src="https://gist.github.com/jbryer/9112634.js"></script>
