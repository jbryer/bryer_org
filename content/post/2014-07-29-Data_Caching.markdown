---
title: "Data Caching"
author: "Jason Bryer"
date: 2014-07-29T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers"]
---

Data caching is not new. It is often necessary to save intermediate data files when the process of loading and/or manipulating data takes a considerable amount of time. This problem is further complicated when working with dynamic data that changes regularly. In these situations it often sufficient to use data that is current with in some time frame (e.g. hourly, daily, weekly, monthly). One solution is to use a time-based job scheduler such as `cron`. However, that requires access and knowledge of Unix systems. The alternative, is to check for the "freshness" of a cached dataset each time it is requested. If is "stale," then the data cached is refreshed with more up-to-date data. The `DataCache` package implements this approach in R. Moreover, on Unix systems (including Mac OS X), the refreshing will be done in the background. That is, when requesting data from the cache, if it is stale, the function will return the latest available data while the cache is updated in the background. This is particularly useful when using R in a web environment (e.g. [Shiny Apps](http://shiny.rstudio.com)) where it is not ideal to have the user wait for data be loaded to begin interacting with the app.

The latest version of the `DataCache` package can be downloaded from Github using the `devtools` package.


```r
devtools::install_github('jbryer/DataCache')
```

For this example, we wish to periodically load weather data using the `weatherData` package. The `getDetailedWeather` function provides hourly temperature updates. To start, we will load the `DataCache` and `weatherData` packages.


```r
library('DataCache')
library('weatherData')
```

The only required parameter for the `data.cache` function is the `FUN` parameter which defines the data to be loaded. This function should return a named `list` where each element of the list will be assigned to specified environment when loaded. That is, if the function returns `list(foo='bar')` then the object `foo` will be assigned in the working envirnoment (note that this can be modified using the `envir` parameter).


```r
#' Load data for a single day for the given airport.
#' @param station_id three letter airport code.
#' @return a list with a data frame names `weather.XXX` where `XXX` is the three
#'         letter airport code.
loadWeatherData <- function(station_id='ALB') {
	results <- list(getDetailedWeather(station_id, Sys.Date()))
	names(results) <- paste0('weather.', station_id)
	return(results)
}
```

To get started, simply call `data.cache` with the data loading function. This function will block on the first execution (i.e. you will have to wait until the first dataset is loaded). On subsequent executions, the `data.cache` function will check to see if the most recent cached data is stale. If it is stale, it will start a new background process to load the data and return the most recent data. Once the background process completes, `data.cache` will start returning the updated data.

Note for Windows users: Forking is not available on Windows systems using the `parallel` package. Therefore data cannot be loaded in the background. As a result, the `data.cache` function will wait for the refreshed data to load each time it becomes stale.

The `data.cache` returns invisibly (i.e. will not be printed if not assinged to a variable, see `?invisible` for more details) the timestamp of the data returned.


```r
(cache.date1 <- data.cache(loadWeatherData))
```

```
No cached data found. Loading intial data...
```

```
[1] "2014-07-29 18:03:53 EDT"
```

```r
head(weather.ALB)
```

```
                 Time TemperatureF
1 2014-07-29 00:51:00         62.1
2 2014-07-29 01:51:00         61.0
3 2014-07-29 02:51:00         61.0
4 2014-07-29 03:51:00         61.0
5 2014-07-29 04:51:00         60.1
6 2014-07-29 05:51:00         59.0
```

The `cache.info` function provides a summary of all the cached data files. It will also provide columns (which can be set using the `stale` parameter) indicating whether that data file is stale according to various time periods.


```r
cache.info()
```

```
                          file             created age_mins hourly_stale
1 Cache2014-07-29 18:03:53.rda 2014-07-29 18:03:53   0.1842        FALSE
  daily_stale weekly_stale monthly_stale yearly_stale
1       FALSE        FALSE         FALSE        FALSE
```

Old data caches can easily be loaded this way. For example, the following will load the first data cache created:


```r
cinfo <- cache.info()
load(cinfo[nrow(cinfo),]$file)
```

There are a number of frequencies available for defining when a dataset becomes stale. They are:

* `hourly` - Data will become stale each hour. This uses the `hour` function from the `lubrdiate` package. Therefore, data will become stale at the top of each hour.
* `daily` - Data will become stale each day (i.e. at midnight).
* `weekly` - Data will become stale each week. The day of week will vary depending on what day of the week January 1st occurs.
* `montly` - Data will become stale each month (i.e. on the 1st of the month).
* `yearly` - Data will become stale each year (i.e. on January 1st).
* `nMinutes` - Data will become stale if last loaded more than *n* minutes ago.
* `nHours` - Data will become stale if last loaded more than *n* hours ago.
* `nDays` - Data will become stale if last laoded more than *n* days ago.

You can define your own frequency. Simply define a function that takes one parameter, `timestamp`, and returns a logical where `TRUE` indicates the data loaded at `timestamp` is stale.

We can see that the `weather.ALB` data frame is now available in the working environent.


```r
ls()
```

```
[1] "cache.date1"     "loadWeatherData" "package"         "weather.ALB"
```

We will wait 60 seconds so that the cache becomes stale. We will also call `data.cache` twice in a row to show that they will each return the same cached data, but the second call will not spawn a new background process to refresh the data.


```r
Sys.sleep(60)
(cache.date2 <- data.cache(loadWeatherData, frequency=nMinutes(1)))
```

```
Loading more recent data, returning lastest available.
```

```
[1] "2014-07-29 18:03:53 EDT"
```

```r
(cache.date3 <- data.cache(loadWeatherData, frequency=nMinutes(1)))
```

```
Data is being loaded by another process. The process has been running for 0.121761083602905 seconds. If this is an error delete cache/Cache.lck
Loading more recent data, returning lastest available.
```

```
[1] "2014-07-29 18:03:53 EDT"
```

It is easy to have multiple data caches. Using the same `loadWeatherData` function we will create a spearate data cache for weather data from JFK.


```r
data.cache(loadWeatherData, cache.name='NRT', station_id='NRT')
```

```
No cached data found. Loading intial data...
```

```r
head(weather.NRT)
```

```
                 Time TemperatureF
1 2014-07-29 00:00:00         69.8
2 2014-07-29 00:30:00         68.0
3 2014-07-29 01:00:00         68.0
4 2014-07-29 01:30:00         68.0
5 2014-07-29 02:00:00         66.2
6 2014-07-29 02:30:00         66.2
```

```r
cache.info(cache.name='NRT')
```

```
                        file             created age_mins hourly_stale
1 NRT2014-07-29 18:05:04.rda 2014-07-29 18:05:04  0.03819        FALSE
  daily_stale weekly_stale monthly_stale yearly_stale
1       FALSE        FALSE         FALSE        FALSE
```
