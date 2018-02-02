---
title: "Retrieving RSS Feeds Using Google Reader"
author: "Jason Bryer"
date: 2012-01-13T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers"]
---

I have been working on a new package <a href="https://github.com/jbryer/makeR">makeR</a> to help manage Sweave projects where you wish to create multiple versions of documents that are based on a single source. For example, I create lots of monthly and quarterly reports using Sweave and the only differences between versions are a few variables. I have used GNU make and Apache ANT but wanted a 100% R solution. I will have more to write about that project in a few weeks. In the meantime I needed an example I could use publicly which led me to thinking about analyzing R-Bloggers. I wanted to use the RSS feed to get the frequency of posts and the tags and categories used. However, R-Bloggers, like most blogs, limits the RSS feeds to the latest few. Google Reader however keeps them all (or at least a lot more). The only downside is that you need to have a Google Reader account. The source code is hosted on Gist and provided below.

##### Setup: retrieve the RSS feed and save it.
	source('https://raw.github.com/gist/1606595/269d61dfcc7930f5275a212e11f3c43771ab2591/GoogleReader.R')

	rbloggers = getRSSFeed(feedURL="http://r-bloggers.com/feed",
				   email="GOOGLE READER EMAIL",
				   passwd="GOOGLE READER PASSWORD",
				   posts=5000)
	entries = rbloggers[which(names(rbloggers) == "entry")]
	length(entries)
	saveXML(rbloggers, file='rbloggers.xml')

	#This will create a data frame with some of the information from the RSS feed
	posts = data.frame(title=character(0), author=character(0),
					   link=character(0), stringsAsFactors=FALSE)
	posts[1:length(entries),1:ncol(posts)] = NA
	posts$published = as.Date(NA)
	posts.categories = list()
	for(i in 1:length(entries)) {
		entry = entries[[i]]
		posts[i,]$title = unclass(xmlChildren(entry[['title']])$text)$value
		posts[i,]$author = unclass(xmlChildren(entry[['author']][['name']])$text)$value
		posts[i,]$link = xmlAttrs(entry[['link']])[['href']]
		posts[i,]$published = as.Date(substr(unclass(
			xmlChildren(entry[['published']])$text)$value, 1, 10))
		categories = entry[which(names(entry) == "category")]
		posts.categories[[i]] = list()
		if(length(categories) > 1) { #Ignore the first category as it is used for Google Reader
			l = list()
			for(j in 2:length(categories)) {
				l[(j-1)] = xmlAttrs(categories[[j]])[['term']]
			}
			posts.categories[[i]] = l
		}
	}

##### We'll use Paul Bleicher's calendarHeat function to visualize the number of posts per day
	source('https://raw.github.com/tavisrudd/r_users_group_1/master/calendarHeat.R')
	cal = as.data.frame(table(posts$published))
	cal$Var1 = as.Date(cal$Var1)
	calendarHeat(cal$Var1, cal$Freq, color="r2b", varname="Number of Posts on R-Bloggers.com")

![img](http://jason.bryer.org/images/RBloggersCalendar.png)

##### Create a word cloud

	require(wordcloud)
	ctab = unlist(posts.categories)
	ctab = unlist(strsplit(ctab, ' '))
	ctab = as.data.frame(table(ctab))
	ctab = ctab[-which(ctab$ctab == 'Uncategorized'),]
	wordcloud(ctab$ctab, ctab$Freq, min.freq=10)

![img](http://jason.bryer.org/images/RBloggersWordCloud.png)

######The getRSSFeed function. Note that this function is included in the [`makeR`](http://jason.bryer.org/makeR) package.

	require(XML)
	require(RCurl)

	#' This function ruturns an XML tree of the RSS feed from the given URL.
	#'
	#' This function utilizes the (unofficial) Google Reader API to retrieve RSS
	#' feeds. The advantage of access RSS feeds through the Google Reader API is that
	#' you are not limited by the number of entries a website may included in their
	#' feed. That is, Google maintains generally maintains a complete history of
	#' entries from the RSS feed.
	#'
	#' Note that the contents of the results will be limited by what the website
	#' provides in their feeds. That is, Google does not contain more information
	#' per entry then what the website originally provided. If the initial feed
	#' contained only excerpts of the article, the feed from Google will too only
	#' contain excerpts. Be aware though that for sites that do provide the complete
	#' contents of posts will result in potentially very large downloads.
	#'
	#' @param feedURL the full URL to the RSS feed.
	#' @param email the email address for the Google Reader account
	#' @param passwd the password for the Google Reader account
	#' @param posts the number of posts to return
	#' @return the root \code{XMLNode} for the RSS feed.
	#' @seealso \code{\link{/xmlRoot}} for the format of the returned XML tree
	#' @export
	#' @example
	#' \dontrun{
	#' rbloggers = getRSSFeed(feedURL="http://r-bloggers.com/feed",
	#'     email="USERNAME@gmail.com", passwd="PASSWORD")
	#' }
	#' @author Jason Bryer <\email{jason@@bryer.org}x>
	getRSSFeed <- function(feedURL, email, passwd, posts=1000) {
		#Authenticate with Google
		curlHandle = getCurlHandle(cookiefile="rcookies", ssl.verifyhost=FALSE, ssl.verifypeer=FALSE)
		x = postForm("https://www.google.com/accounts/ClientLogin",
					 accountType="GOOGLE",
					 service="reader",
					 Email=email,
					 Passwd=passwd,
					 source="makeR",
					 curl = curlHandle)
		gtoken = unlist(strsplit(x, "\n"))
		parsed.gtoken <- unlist(strsplit(gtoken[3], "Auth="))
		if (length(parsed.gtoken) >= 2) {
			auth.token <- unlist(strsplit(gtoken[3], "Auth="))[[2]]
		} else {
			stop("Authentication failed.")
		}
		google.auth <- paste("GoogleLogin auth=", auth.token, sep='')

		#Function to retrieve up to 1000 posts
		getDoc <- function(n, c=NULL) {
			feedURL = paste("http://www.google.com/reader/atom/feed/", feedURL, "?n=", n,
							ifelse(is.null(c), "", paste("&c=", c, sep='')),
							sep='')
			feed = getURL(feedURL, .encoding = 'UTF-8', followlocation=TRUE,
						  httpheader=c("Authorization"=google.auth),
						  curl=curlHandle)
			doc = xmlTreeParse(feed, asText=TRUE)
			return(xmlRoot(doc))
		}

		root = NULL
		continueValue = NULL
		for(i in 1:ceiling(posts / 1000)) {
			r = getDoc(n=ifelse(i == ceiling(posts / 1000), (posts-1) %% 1000 + 1, 1000),
					   c=continueValue)
			if(is.null(root)) {
				root = r
			} else {
				entries = which(xmlSApply(r, xmlName) == 'entry')
				if(length(entries) > 0) {
					root = addChildren(root, kids=r[entries])
				}
			}
			if(is.null(r[['continuation']])) {
				break #No more posts to retrieve
			} else {
				continueValue = unclass(xmlChildren(r[['continuation']])$text)$value
			}
		}
		return(root)
	}
