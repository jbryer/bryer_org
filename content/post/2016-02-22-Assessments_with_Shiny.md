---
title: "Conducting Assessments and Surveys with Shiny"
author: "Jason Bryer"
date: 2016-02-22T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers"]
---

This post describes a framework for using Shiny for conducting, grading, and providing feedback for assessments. This framework supports any multiple choice format including multiple choice tests or Likert type surveys. A demo is available at [jbryer.shinyapps.io/ShinyAssessmentTest](https://jbryer.shinyapps.io/ShinyAssessmentTest/) or can be run locally as a [Github Gist](https://gist.github.com/jbryer/a6fb5a3b1d5fd56cff64):

```
runGist('a6fb5a3b1d5fd56cff64')
```

Key features of this framework include:

* Assessments take over the entire user interface for a distraction free assessment.
* Creating an assessment requires:
	* A vector of item stems.
	* A data frame with item choices.
	* A function that will process the results.
* Button or link to start the assessment.


### Example

Let's walk through the statistics assessment example. The first step is to define the multiple choice items, here defined in a CSV file.

```
> math.items <- read.csv('items.csv', stringsAsFactors=FALSE)
> names(math.items)
[1] "Item"   "Stem"   "Answer" "A"      "B"      "C"      "D"      "E"     
```

We will also define a function that will be called when the user completes the assessment. This function needs to have one parameter named `results`. This parameter is a character vector of the user responses. The values are either `NA` if there was no response, or the column name of the `item.choices` defined below (here A through E). In this example, the results will be stored in a `reactiveValues` object so that the UI will refresh with new results.

```
assmt.results <- reactiveValues(
	math = logical(),
	mass = integer(),
	reading = logical()
)

saveResults <- function(results) {
	assmt.results$math <- results == math.items$Answer
}
```

Next, we create an assessment by calling the `ShinyAssessment` function.

```
test <- ShinyAssessment(input, output, session,
		name = 'Statistics',
		item.stems = math.items$Stem,
		item.choices = math.items[,c(4:8)],
		callback = saveResults,
		start.label = 'Start the Statistics Assessment',
		itemsPerPage = 1,
		inline = FALSE)
```

The first three parameters, `input`, `output`, and `session` are simply passed from `shinyServer`. The other parameters you can set are:

* `name` The name of the assessment. This should be a name that follows R's naming rules (i.e. does not start with a number, no spaces, etc).
* `callback` The function called when the user submits the assessment. Used for saving the results.
* `item.stems` A character vector or list with the item stems. If a list, any valid Shiny UI output is allowed (e.g. `p`, `div`, `fluidRow`, etc.). For character vectors HTML is allowed.
* `item.choices` A data frame with the item answers. For items that have fewer choices than the total number of columns, place \code{NA} in that column's value. The results will be passed to the \code{callback} function as named list where the value is the name of the column selected.
* `start.label` The label used for the link and button created to start the assessment.
* `itemsPerPage` The number of items to display per page.
* `inline` If `TRUE`, render the choices inline (i.e. horizontally).
* `width` The width of the radio button input.
* `cancelButton` Should a cancel button be displayed on the assessment.

Users start an assessment with a link or button using `uiOutput(test$link.name)` or `uiOutput(test$button.name)`, respectively.

In order for the assessment to take over the entire user interface, the UI must be built on the server side in the `server.R` file. In this case, the UI resides in the `output$ui` object:

```
output$ui <- renderUI({
	if(SHOW_ASSESSMENT$show) { # The assessment will take over the entire page.
		fluidPage(width = 12, uiOutput(SHOW_ASSESSMENT$assessment))
	} else { 
		# This is the normal Shiny UI code here.
	}
})
```

As a result, the `ui.r` script has only one line of code.

```
shinyUI(fluidPage( uiOutput('ui') ))
```

This is one of two limitations of this approach. The other limitation is the creation of the `SHOW_ASSESSMENT` object. In order for the UI to know to show the assessment, a global variable must be set (i.e. `SHOW_ASSESSMENT$show`). To accomplish this, the `ShinyAssessment` function creates and sets the value of an object in the calling environment. This is generally considered bad practice (Note: if you know of another approach to avoid this behavior, please let me know in the comments below). Multiple assessments are supported as subsequent calls to `ShinyAssessment` first look to see if the `SHOW_ASSESSMENT` object has been created.


### Conclusion

It is up to the developer to define the `callback` function is to score and save results. There are a lot of R packages that support databases including [`RODB`](https://cran.r-project.org/web/packages/RODBC/index.html), [`RMySQL`](http://cran.r-project.org/web/packages/RMySQL/index.html), [`ROracle`](http://cran.r-project.org/web/packages/ROracle/index.html), [`RJDBC`](http://cran.r-project.org/web/packages/RJDBC/index.html), [`rsqlite`](https://cran.r-project.org/web/packages/RSQLite/index.html), and [`RPostgreSQL`](https://cran.r-project.org/web/packages/RPostgreSQL/index.html)). Be sure to check out [Dean Attali's article about persisting data storage](http://shiny.rstudio.com/articles/persistent-data-storage.html) in Shiny apps, especially if you plan to deploy to shinyapps.io.

I have also modified [Huidong Tian's](http://withr.me/authentication-of-shiny-server-application-using-a-simple-method/) R script for adding user authentication to the open source version of Shiny to allow for users to create accounts. With authenticated user accounts users can retrieve their assessment results across different sessions. The source code is here: [gist.github.com/jbryer/e17c5587a43188258ee5](https://gist.github.com/jbryer/e17c5587a43188258ee5)


This function represents the first version of an assessment framework for Shiny. Since this is in place that might be useful for other Shiny users, especially those using R and teaching, I wanted to share to get feedback and suggestions on improvement. For instance, currently this function only supports a fixed number of items presented in predefined order. In the future, this function will be modified to utilize IRT models and allow for computer adaptive testing.
