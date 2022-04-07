---
title: "Interactive SQL in R"
author: "Jason Bryer"
date: 2013-01-12T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers"]
---

I recently taught a very basic introduction to SQL workshop and needed a way to have participants interact with SQL statements. Obviously there are lots of tools to interface with a database, but since we are all R users I thought it would be nice to be able interact without leaving R. Although this interface is fairly basic, the fact that we can type in a SQL statement and get the results as an R data frame provides all the advantages of having data in R. Moreover, I found this to be an interesting exercise in see the power of R as programming language, not just as statistical software. The function described here is part of the [`sqlutils`](/sqlutils) package which was created to manage a library of SQL files. More information about that is provided on the [project page](/sqlutils) and I will likely have a forthcoming blog post too.

First we need to create a database to interact with. In this example we will use the `students` data frame from the [`retention`](/retention) package. We will save this data frame into a SQLite database using the RSQLite package. The R code to setup the database is provided as a demo in the package. Type `demo('isql')` to start.

	require(sqlutils)
	require(RSQLite)
	require(retention)
	data(students)
	students$CreatedDate = as.character(students$CreatedDate)
	m <- dbDriver("SQLite")
	tmpfile <- tempfile('students.db', fileext='.db')
	conn <- dbConnect(m, dbname=tmpfile)
	dbWriteTable(conn, "students", students[!is.na(students$CreatedDate),])

We begin an interactive SQL environment with the `isql` function. The only required parameter is `conn` which is the connection to the database that SQL statements will be executed. The `sql` parameter is optional and sets the initial SQL statement for the session that can be edited or executed.

	> hist <- isql(conn=conn, sql=getSQL('StudentSummary'))
	Interactive SQL mode (type quit to exit, help for available commands)...
	SQL>
	help
	   Command      Description
	   ___________  ______________________________________________________
	   quit         quit interactive mode
	   help         display this message
	   sql          enter SQL statement
	   edit         edit SQL in a separate text window
	   print        print the last entered SQL statement
	   exec         execute that last entered SQL statement
	   result       prints the last results
	   save [name]  save the last executed query to the global environment
	SLQ>
	print
	SELECT CreatedDate, count(StudentId) AS count FROM students GROUP BY CreatedDate ORDER BY CreatedDate
	SLQ>
	edit

![SQL Edit Window](/images/isql-edit-window.png)

	SLQ>
	print
	SELECT CreatedDate, count(StudentId) AS count FROM students GROUP BY CreatedDate ORDER BY CreatedDate
	SLQ>
	exec
	Executing SQL...
	118 rows of 2 variables returned
	SLQ>
	save
	Data frame sql.results saved to global environment
	SLQ>
	quit

The `isql` function returns the history of the session invisibly (that is the results will not be printed but can be assigned to a variable). There are two elements in the returned list, `commands` is a character vector listing all the commands entered and `sql` is a character vector containing all the SQL statements entered.

	> names(hist)
	[1] "sql"      "commands"

