---
title: "Reading Codebook Files in R"
author: "Jason Bryer"
date: 2013-01-10T21:13:14-05:00
categories: ["R"]
tags: ["R", "R-Bloggers"]
---

One issue I continuously encounter when starting to work with a new dataset is that of the codebook. In general, I prefer to load a codebook into R like any other data source, specifically as a data frame. And ideally, one data frame to provides the variable names with descriptions and any other meta data available, and a separate list of named vectors that can be used to recode factors. Although there is no standard format for codebooks, most follow a similar format. This post outlines the [`parse.codebook`](https://gist.github.com/4497585) function that will read codebooks that have the following features:

* Each line in the file provides information about a variable (which I refer to as a variable row), or the mapping of factor (which I refer to as a level row).
* Variable rows start on the left edge (that is, there is a non-whitespace character at position 1 of the row).
* Level rows do not start on the left edge (that is, there is a whitespace character at position 1 of the row, for example a tab or space).
* Rows are either fixed (see `?read.fwf` for more information as to specifics) or character delimited (e.g. comma, colon, etc.).

Although all codebooks may not strictly adhere to these rules, it is often trivial, even if not a bit tedious, to reformat the file to adhere to these rules. Also, blank lines are permissible and will simply be ignored.

If the codebook file adheres to these rules, the `parse.codebook` function will parse the file and return an object of type `codebook` that inherits from `data.frame`, therefore all the data frame functions are valid (e.g. `head`, `nrow`, `names`, etc.). This data frame contains all the information about the variables vis-a-vis the variable rows. Information about factor levels are stored in a `list` as an `attribute` of the returned object which can be retrieved using `attr(mycodebook, 'levels')`. Example from the [Common Core of Data](http://nces.ed.gov/ccd/) and the [American Community Survey](http://www.census.gov/acs/www/) are provided below.

#### Installation

The `source.codebook` function is currently provided on [Gist](https://gist.github.com/4497585). You can either download the R script file or source it directly from Gist using the `devtools` package.

	require(devtools)
	source_gist(4497585)

##### Parameters

The `parse.codebook` has a number of parameters to indicate the format of variable and level rows. The function will handle both character delimited rows and fixed with rows. Therefore, either `var.sep` or `var.widths` must be specified as well as `level.sep` or `level.widths`. The available parameters are:

* `file` codebook file name.
* `var.names` the name of the columns for variable rows.
* `level.names` the name of the columns for level rows.
* `var.sep` the separator for variable rows.
* `level.sep` the separator for level rows.
* `level.indent` character vector providing character(s) at the beginning of the line that indicate the line represents a factor level. Each element should have 1 character as only the first character of the line is compared.
* `var.name` the name in `var.names` that represents the variable name. This should be a valid R variable name as this will be the column name in the corresponding data file, as well as the name used in the `list` of levels stored as an attribute to the returned object.

#### Example One: Common Core of Data

The [Common Core of Data](http://nces.ed.gov/ccd/) (CCD) is a dataset provided by the [National Center for Education Statistics](http://nces.ed.gov/) that provides information about K-12 schools in the United States. The codebook provided is in plain text and required two modifications: One, general file information at the top of the file was deleted, and two, any descriptions that spanned lines need to be modified so the are on only one line. Here are the first 15 lines of the modified file, the full file can be downloaded at [here](http://jason.bryer.org/codebooks/ccdCodebook.txt)

	SURVYEAR      1      AN     Year corresponding to survey record.

	NCESSCH       2      AN     Unique NCES public school ID (7-digit NCES agency ID (LEAID) + 5-digit NCES school ID (SCHNO).

	FIPST         3      AN     American National Standards Institute (ANSI) state code..

	                             01  =  Alabama
	                             02  =  Alaska
	                             04  =  Arizona
	                             05  =  Arkansas
	                             06  =  California
	                             08  =  Colorado
	                             09  =  Connecticut
	                             10  =  Delaware
	                             11  =  District of Columbia

This codebook uses fixed withs for variable rows, and separators (using the equal sign) for level rows (although it also possible to use fixed with for level rows as well). First, we will parse the file:

	ccd.codebook <- parse.codebook('ccdCodebook.txt',
					var.names=c('variable','order','type','description'),
					level.names=c('level','label'),
					level.sep='=',
					var.widths=c(13, 7, 7, Inf) )

Here are the first six rows of the returned data frame.

	> head(ccd.codebook)
	  linenum variable order type                                                                                    description isfactor
	1       1 SURVYEAR     1   AN                                                           Year corresponding to survey record.    FALSE
	2       3  NCESSCH     2   AN Unique NCES public school ID (7-digit NCES agency ID (LEAID) + 5-digit NCES school ID (SCHNO).    FALSE
	3       5    FIPST     3   AN                                      American National Standards Institute (ANSI) state code..     TRUE
	4      67    LEAID     4   AN                                                          NCES local education agency (LEA) ID.    FALSE
	5      69    SCHNO     5   AN                                                                                NCES school ID.    FALSE
	6      71     STID     6   AN                                                       State?s own ID for the education agency.    FALSE

In addition to the columns corresponding to `var.names`, the function also returns a `linenum` and `isfactor` column. The former is an integer corresponding to the line number in the original file from which this row was parsed. This is useful for tracking down issues in the parsing or text formatting. The `isfactor` is a logical column indicating whether there are factor levels specified for that variable. Factor levels can be retrieved as follows:

	> ccd.var.levels <- attr(ccd.codebook, 'levels')
	> names(ccd.var.levels)
	[1] "FIPST"  "TYPE"   "STATUS" "TITLEI" "STITLI" "MAGNET" "CHARTR" "SHARED"
	> ccd.var.levels[['TYPE']]
	  linenum level                    label
	1     103     1           Regular school
	2     105     2 Special education school
	3     107     3        Vocational school
	4     109     4 Other/alternative school
	5     111     5       Reportable program

#### Example Two: American Community Survey

The [American Community Survey](http://www.census.gov/acs/www/) is the current version of the Census Long Form. The codebook provided by the United Census Bureau is in PDF format, but is easily converted to a plain text file. This file required more modification that the CCD file described above, mostly removing line numbers that pasted over from the PDF as well as ensuring that descriptions did not span lines. The final modified version can be downloaded (here)[http://jason.bryer.org/codebook/acsPersonCodebook.txt]. Here are the first 10 lines of the file:

	SPORDER .Person number
	ST .State Code
		01 .Alabama/AL
		02 .Alaska/AK
		04 .Arizona/AZ
		05 .Arkansas/AR
		06 .California/CA
		08 .Colorado/CO
		09 .Connecticut/CT
		10 .Delaware/DE

For this codebook file, all rows are character delimited on ` .` (space period). We parse the file as follows:

	acs.codebook <- parse.codebook('acsPersonCodebook.txt',
					   var.names=c('var','desc'),
					   level.names=c('level','label'),
					   var.sep=' .', level.sep=' .')

The first six lines of the returned data frame are:

	> head(acs.codebook)
	      var                                                                                desc linenum isfactor
	1 SPORDER                                                                       Person number       1    FALSE
	2      ST                                                                          State Code       2     TRUE
	3  ADJINC Adjustment factor for income and earnings dollar amounts (6 implied decimal places)      55    FALSE
	4   PWGTP                                                                     Person's weight      56    FALSE
	5    AGEP                                                                                 Age      57    FALSE
	6     CIT                                                                  Citizenship status      58     TRUE

And factor levels:

	> var.levels <- attr(acs.codebook, 'levels')
	> names(var.levels)
	 [1] "ST"      "CIT"     "COW"     "DRAT"    "ENG"     "GCM"     "JWRIP"   "JWTR"    "MAR"     "MARHM"
	[11] "MARHT"   "MARHW"   "MIG"     "MIL"     "NWAV"    "RELP"    "SCH"     "SCHG"    "SCHL"    "SEX"
	[21] "WKL"     "WKW"     "WRK"     "ANC"     "ANC1P"   "ANC2P"   "DECADE"  "DIS"     "DRIVESP" "ESP"
	[31] "ESR"     "FOD1P"   "6402"    "FOD2P"   "HICOV"   "HISP"    "INDP"    "JWAP"    "JWDP"    "LANP"
	[41] "MIGSP"   "MSP"     "NAICSP"  "NOP"     "OCCP02"  "OCCP10"  "PAOC"    "POBP"    "POWSP"   "PRIVCOV"
	[51] "PUBCOV"  "QTRBIR"  "RAC1P"   "RAC2P"   "RAC3P"   "SFN"     "SFR"     "SOCP00"  "SOCP10"  "VPS"
	[61] "WAOB"    "FHINS3C" "FHINS4C" "FHINS5C"
	> var.levels[['CIT']]
	  linenum level                                                                        label
	1      59     1                                                             Born in the U.S.
	2      60     2 Born in Puerto Rico, Guam, the U.S. Virgin Islands, or the Northern Marianas
	3      61     3                                            Born abroad of American parent(s)
	4      62     4                                               U.S. citizen by naturalization
	5      63     5                                                    Not a citizen of the U.S.

#### Conclusion

Although a standard codebook format doesn't exist, most adopt a similar format. I have outlined the `parse.codebook` function that, with minimal reformatting of the original codebook file, be used to read a codebook into R. This is tremendously useful as we can now merge in variable descriptions when creating tables and figures, as well as recode factors with their longer descriptions in an automated fashion.
