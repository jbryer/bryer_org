---
title: "Gambler's Run with Shiny"
author: "Jason Bryer"
date: 2013-05-08T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers"]
---

I finally had an opportunity to play with [Shiny](http://rstudio.com/shiny), and I am very impressed. I have created a [Github Project](http://github.com/jbryer/ShinyApps) so head over there for the source code. There are a number of ways to distribute Shiny apps. If you are running R (and mostly likely you are if you are reading this), you can download and run Shiny apps using the `runApp` (if already downloaded), `runGitHub`, `runGist`, or `runUrl` functions. RStudio also make the [Shiny Server](http://rstudio.github.io/shiny/tutorial/#deployment-web) available and you can also [request an account](https://rstudio.wufoo.com/forms/shiny-server-beta-program/) on their servers. Also be sure to check out the excellent [tutorial](http://rstudio.github.io/shiny/tutorial/) on Shiny.

First, install `shiny` and `shinyIncubator` (for the `ActionButton`) packages, preferably the development versions.

	require(devtools)
	install_github('shiny', 'rstudio')
	install_github('shiny-incubator', 'rstudio')
	require(shiny)

#### Gambler's Run ####

This simple app that lets you simulate a sequence of random events, for example coin flips, and plot the cummulative sum. This app allows you choose the odds of winning, the number of games to simulate, and the number of simulations to display simultaneously.

![Gambler Shiny App](https://raw.github.com/jbryer/ShinyApps/master/screens/gambler.png)

To run the app locally:

	shiny::runGitHub('ShinyApps', 'jbryer', subdir='gambler')

Or from the [RStudio server](http://spark.rstudio.com/jbryer/gambler) (note that RStudio does not guarantee the server will always be up so this link may or may not work).

#### Lottery Tickets ####

Similar to the `gambler` app, this simulates buying a series of lottery tickets with varying odds of winning different amounts. Each previous run is saved and plotted in light grey to show how the current run compares to past runs.

![Lottery Tickets Shiny App](https://raw.github.com/jbryer/ShinyApps/master/screens/lottery.png)

To run the app locally:

	shiny::runGitHub('ShinyApps', 'jbryer', subdir='lottery')

Or from the [RStudio server](http://spark.rstudio.com/jbryer/lottery) (note that RStudio does not guarantee the server will always be up so this link may or may not work).

Just to try out all the ways to distribute Shiny apps, I also created a [Gist](https://gist.github.com/jbryer/5525690) for this app.

	shiny::runGist("5525690")
