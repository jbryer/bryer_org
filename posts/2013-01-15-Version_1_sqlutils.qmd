---
title: "Version 1.0 of sqlutils available on CRAN"
author: "Jason Bryer"
date: 2013-01-15T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers"]
---

Version 1.0 of `sqlutils` has been released to CRAN. The `sqlutils` package is designed to manage a library of SQL files. This package grew out of the needs of an Office of Institutional Research where the vast majority of analysis is conducted on data from our Student Information System (SIS) which is stored in an Oracle database. A lot of our analyses and reports are derived from the same types of datasets but from easily extracted parameters (e.g. date range, program name, status, etc.). We used to store SQL commands in our R scripts but that can become quite cumbersome and in many ways, reduced the ease of reusability which is a major reason for using R in the first place, hence the birth of `sqlutils`. For our purposes we currently have over 40 SQL files that have been well vetted and documented. To share the library we simply add the following to our `.Rprofile` script:

	require(sqlutils)
	sqlPaths('/Path/to/shared/directory')

A [full introduction to the `squtils` package is available here](/sqlutils) as well as on the [Github project page](http://github.com/jbryer/sqlutils). A key advantage to using `sqlutils` is that you can store your queries in plain text files (with a `.sql` file extension) and document them using `roxygen2` style comments. Moreover, R function parameters are used to set parameters within the SQL command. Parameters are defined in SQL files using colon, parameter name, colon (i.e. `:paramName:`) format. Using this framework, it is easy to create a [data dictionary](/sqlutils/datadictionary.html) of the library of SQL files.

Lastly, I wrote about an [interactive SQL](/posts/2013-01-12/Interactive_SQL_in_R.html) mode in R a few days ago. The `isql` function is included in the `sqlutils` package.
