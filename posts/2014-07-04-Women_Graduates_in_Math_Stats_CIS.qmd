---
title: "Women Graduates in Math, Statistics, and Computer Information Systems"
author: "Jason Bryer"
date: 2014-07-04T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers", "Education"]
---

One of the more interesting talks at this year's [useR! Conference](http://user2014.stat.ucla.edu/) was the [heR Panel](https://github.com/skoval/her2014) discussing the role of women in the R community. They estimate that fewer than 15% of package authors are women. One of the points brought up was that this is less than the percentage of women in statistics. Perhaps this is more related to the computer science aspect of R that that of statistics. By way of comparison, the [United States Department of Labor](http://www.dol.gov) estimates there are between 7.5% (computer network architects) and 39.5% (web developers) of computer related fields. This as compared to women holding 47% of all occupations ([source](http://www.dol.gov/wb/stats/Computer-information-technology.htm)).

<img src='https://raw.githubusercontent.com/skoval/her2014/master/women_represent.png' width='50%' alt='R Package Maintainers' />

(Stephanie Kovalchik, https://github.com/skoval/her2014/blob/master/representation.R)

Here, I am going to provide another data point to help think about this issue. Specifically, what percentage of math, statistics, and computer information systems baccalaureate degrees do women earn. Using the [`ipeds`](https://github.com/jbryer/ipeds) package I wrote a while back to get data from the Integrated Postsecondary Education Data System (IPEDS), we can quickly get data for the last 13 years of degrees awarded.

First, this histogram depicts the total number of Baccalaureate Degrees awarded in CIS, Math, and Statistics. Interestingly we see there is a steady increase in math and statistics degrees, whereas there was quite a dip in CIS degrees in the mid 2000s (perhaps due to the dot com bubble burst?).

![Number of Baccalaureate Degrees Awarded by Year](/images/ipeds-degrees.png)

The following figure shows the percentage of those Baccalaureate Degrees awarded to women. For comparison, I have included a line showing the total percentage of Baccalaureate Degrees awarded to women. The bad news, there is still a ways to go to shrink the gender gap. Math and statistics is doing better, but not as bad as CIS degrees. The worse news, it appears there is a downward trend in the percentage of Baccalaureate Degrees awarded to women in CIS.

![Percent of Female Percent of Female Baccalaureate Degrees Awarded\n',
				   'by Year for CIS, Math, and Statistics Majors Degrees Awarded by Year for CIS, Math, and Statistics Majors](/images/ipeds-degrees-gender.png)

The source code is on [Gist](https://gist.github.com/jbryer/11ad6956dff589ec4f3c):

<script src="https://gist.github.com/jbryer/11ad6956dff589ec4f3c.js"></script>
