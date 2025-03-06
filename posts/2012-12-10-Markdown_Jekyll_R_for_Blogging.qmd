---
title: "Using (R) Markdown, Jekyll, & Github for a Website"
author: "Jason Bryer"
date: 2012-12-10T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers"]
---

#### Introduction

[Markdown](http://daringfireball.net/projects/markdown/syntax) has been growing in popularity for writing documents on the web. With the introduction of [R Markdown](http://www.rstudio.com/ide/docs/authoring/using_markdown) (see also [Jeromy Anglim's post](http://jeromyanglim.blogspot.com/2012/05/getting-started-with-r-markdown-knitr.html) on getting started with R Markdown) and [knitr](http://yihui.name/knitr/), R Markdown has simplified the publishing of R analysis on the web. I recently converted my website from [Wordpress](http://wordpress.org) to [Jekyll](https://github.com/mojombo/jekyll). Jekyll is a "static site generator" and is the framework used by [GitHub Pages](http://pages.github.com). You can view the complete source for this website on Github at [https://github.com/jbryer/jbryer.github.com](https://github.com/jbryer/jbryer.github.com).

I have outlined two approaches for integrating R Markdown within the Jekyll framework. The first approach implements a [Jekyll Converter](https://github.com/mojombo/jekyll/wiki/Plugins) that will convert `rmd` files (the default but configurable) when Jekyll processes the site. The second uses a shell script and R function to convert `rmd` files to a plain Markdown file that Jekyll can then process. This approach is necessary when using GitHub Pages because user plugins are not supported.

#### Approach One: Using a Jekyll Converter

First, we need to install [RinRuby](https://sites.google.com/a/ddahl.org/rinruby-users/) to call R from Ruby. In the terminal, execute:

	gem install rinruby

Create `rmarkdown.rb` and place it in the `_plugins` folder. The convert class follows and can be [downloaded here](https://github.com/jbryer/jbryer.github.com/blob/master/_plugins/rmarkdown.rb).

	module Jekyll
		class RMarkdownConverter < Converter
			safe true
			priority :low

	    def setup
	      return if @setup
	      require 'rinruby'
	      @setup = true
	    rescue
	      STDERR.puts 'do `gem install rinruby`'
	      raise FatalException.new("Missing dependency: rinruby")
	    end

	    def matches(ext)
  	      ext =~ /rmd/i
	    end

	    def output_ext(ext)
	      '.html'
	    end

	    def convert(content)
	      setup
	      R.eval "require(knitr)"
	      R.assign "content", content
	      R.eval "content <- (knitr::knit2html(text = content, fragment.only = TRUE))"
	      R.pull "content"
	    end
	  end
	end

In order to use the `rmd` file extension (see the `ext =~ /rmd/i` line to change the extension used) you need to specify the markdown file extension in the `_config.yml` configuration file. Otherwise Jekyll will attempt to process `rmd` files as plain Markdown files. This also means that you cannot use `md` file extension for markdown files. See this discussion on [StackOverflow](http://stackoverflow.com/questions/13793858/jekyll-converter-for-r-markdown).

	markdown_ext: markdown

Once created, `RMarkdownConverter` will convert `rmd` files to `html` each time Jekyll runs.

#### Approach Two: Pre-process R Markdown Files

This approach is necessary for [Github Pages](http://pages.github.com) since [plugins are not supported](https://github.com/mojombo/jekyll/issues/325). Using this approach, we can convert the R Mardown file to plain Markdown using the R script below. The converted Markdown file will be saved in the same directory so that Jekyll can then convert the resulting file. For simplicity, I place the [`rmarkdown.r`](https://github.com/jbryer/jbryer.github.com/blob/master/rmarkdown.r) function in the root directory of my site (alternatively you can place this in your `.Rprofile` file in your home directory). I then call `rmd.sh` (also located in the root directory) to first, determine the directory where the script is be executed from, and two, call the `convertRMarkdown` function. This function will process all R Markdown files (`.rmd` by default) in the current working directory (which can be set explicitly with the `dir` parameter or by the `rmd.sh` script) and convert them to plain markdown (with `.markdown` file extension by default). Once converted, Jekyll will the process the resulting file(s). This file can be [downloaded here](https://github.com/jbryer/jbryer.github.com/blob/master/rmarkdown.r).

	#' This R script will process all R mardown files (those with in_ext file extention,
	#' .rmd by default) in the current working directory. Files with a status of
	#' 'processed' will be converted to markdown (with out_ext file extention, '.markdown'
	#' by default). It will change the published parameter to 'true' and change the
	#' status parameter to 'publish'.
	#'
	#' @param dir the directory to process R Markdown files.
	#' @param out_ext the file extention to use for processed files.
	#' @param in_ext the file extention of input files to process.
	#' @param recursive should rmd files in subdirectories be processed.
	#' @return nothing.
	#' @author Jason Bryer <jason@bryer.org>
	convertRMarkdown <- function(dir=getwd(), images.dir=dir, images.url='/images/',
	           out_ext='.markdown', in_ext='.rmd', recursive=FALSE) {
	  require(knitr, quietly=TRUE, warn.conflicts=FALSE)
	  files <- list.files(path=dir, pattern=in_ext, ignore.case=TRUE, recursive=recursive	)
	  for(f in files) {
	    message(paste("Processing ", f, sep=''))
	    content <- readLines(f)
	    frontMatter <- which(substr(content, 1, 3) == '---')
	    if(length(frontMatter) == 2) {
	      statusLine <- which(substr(content, 1, 7) == 'status:')
	      publishedLine <- which(substr(content, 1, 10) == 'published:')
	      if(statusLine > frontMatter[1] & statusLine < frontMatter[2]) {
	        status <- unlist(strsplit(content[statusLine], ':'))[2]
	        status <- sub('[[:space:]]+$', '', status)
	        status <- sub('^[[:space:]]+', '', status)
	        if(tolower(status) == 'process') {
	          #This is a bit of a hack but if a line has zero length (i.e. a
	          #black line), it will be removed in the resulting markdown file.
	          #This will ensure that all line returns are retained.
	          content[nchar(content) == 0] <- ' '
	          message(paste('Processing ', f, sep=''))
	          content[statusLine] <- 'status: publish'
	          content[publishedLine] <- 'published: true'
	          outFile <- paste(substr(f, 1, (nchar(f)-(nchar(in_ext)))), out_ext, sep='')
	          render_markdown(strict=TRUE)
	          opts_knit$set(out.format='markdown')
	          opts_knit$set(base.dir=images.dir)
	          opts_knit$set(base.url=images.url)
	          try(knit(text=content, output=outFile), silent=FALSE)
	        } else {
	          warning(paste("Not processing ", f, ", status is '", status,
	                  "'. Set status to 'process' to convert.", sep=''))
	        }
	      } else {
	        warning("Status not found in front matter.")
	      }
	    } else {
	      warning("No front matter found. Will not process this file.")
	    }
	  }
	  invisible()
	}

Here is the source to the [`rmd.sh`](https://github.com/jbryer/jbryer.github.com/blob/master/rmd.sh) shell script for calling the `convertRMarkdown` function. This file can be [downloaded here](https://github.com/jbryer/jbryer.github.com/blob/master/rmd.sh).

	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	Rscript -e "source('$DIR/rmarkdown.r'); convertRMarkdown(images.dir='$DIR/images')"

##### YAML Front Matter

There are two parameters you can specify in the [YAML Front Matter](https://github.com/mojombo/jekyll/wiki/YAML-Front-Matter) to alter how the `convertRMarkdown` function handles particular files. First, the `published` parameter should be set to `false` so that Jekyll will not attempt to process the file. The `convertRMarkdown` function will change this parameter to `true` in the resulting Markdown file. The second parameter, `status`, must be set to `process` for the `convertRMarkdown` function to convert the file. This is useful when working a draft of a document and you wish to not have the file converted.

	published: false
	status: process

Lastly, one difficulty with Jekyll is the [inclusion of images in posts](http://stackoverflow.com/questions/10363812/local-post-assets-with-jekyll). The default behavior assumes that all images will be saved in the `/images` directory. This can of course be configured using parameters to `convertRMarkdown` and `knitr` options.

#### Example

The source for this post can be downloaded from [GitHub](https://github.com/jbryer/jbryer.github.com/blob/master/_posts/). In this example we will analyze the reading attitude items for North America from the [Programme of International Student Assessment](http://www.pisa.oecd.org) using the [`likert`](http://jason.bryer.org/likert) package. The first R chuck will load and recode the data.


    require(likert)
    data(pisana)

    ## Warning: data set 'pisana' not found

    items <- pisana[,c(
    	'ST24Q01', #Only if I have to
    	'ST24Q02', #Favourite hobbies
    	'ST24Q03', #Talk about books
    	'ST24Q04', #Hard to finish
    	'ST24Q05', #Happy as present
    	'ST24Q06', #Waste of time
    	'ST24Q07', #Enjoy library
    	'ST24Q08', #Need information
    	'ST24Q09', #Cannot sit still
    	'ST24Q10', #Express opinions
    	'ST24Q11'  #Exchange
    	)]

    ## Error: object 'pisana' not found

    names(items) <- c("I read only if I have to.",
    		"Reading is one of my favorite hobbies.",
    		"I like talking about books with other people.",
    		"I find it hard to finish books.",
    		"I feel happy if I receive a book as a present.",
    		"For me, reading is a waste of time.",
    		"I enjoy going to a bookstore or a library.",
    		"I read only to get information that I need.",
    		"I cannot sit still and read for more than a few minutes.",
    		"I like to express my opinions about books I have read.",
    		"I like to exchange books with my friends")

    ## Error: object 'items' not found

    for(i in 1:ncol(items)) {
    	items[,i] <-  factor(items[,i], levels=c(1,2,3,4), ordered=TRUE,
    		labels=c('Strongly Disagree', 'Disagree', 'Agree', 'Strongly Agree'))
    }

    ## Error: object 'items' not found

    l <- likert(items, grouping=pisana$CNT)

    ## Error: object 'items' not found

Once the `likert` has been called we can print the summary.


    options(width=120)
    summary(l)

    Error: object 'l' not found

And of course, we can include plots.


    plot(l, centered=TRUE)

    ## Error: object 'l' not found

#### Final Thoughts

The conversion from Wordpress wasn't necessarily trivial, but the benefits of using Jekyll have made the conversion worth while. The ability to embed R code within the site's content makes writing posts about R much easier than executing R code, copy and paste to Wordpress (or Gists), and publishing in a database back system for a site that changes relatively infrequently. I will soon be publishing results from a large study and this exercise has shown that R Markdown is an ideal solution.

Laslty, I must give a big thanks to [Tal Galili](http://www.r-statistics.com/) who maintains [R-Bloggers](http://r-bloggers.com) for his help and patience as I worked out the issues getting the RSS feed to work with his platform.
