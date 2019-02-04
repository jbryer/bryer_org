+++
date = 2017-01-01T18:00:00  # Schedule page publish date.

title = "Intro to Propensity Score Analysis"
time_start = 2019-03-28T18:00:00
time_end = 2019-03-28T20:00:00
abstract = ""
abstract_short = ""
event = "Albany R Users' Group"
event_url = "https://www.meetup.com/Albany-R-Users-Group/events/258674208/"
location = "Albany, NY"

# Is this a selected talk? (true/false)
selected = false

# Projects (optional).
#   Associate this talk with one or more of your projects.
#   Simply enter the filename (excluding '.md') of your project file in `content/project/`.
#projects = ["daacs"]

# Links (optional).
url_pdf = ""
url_slides = ""
url_video = ""
url_code = ""

# Does the content use math formatting?
math = true

# Does the content use source code highlighting?
highlight = true

# Featured image
# Place your image in the `static/img/` folder and reference its filename below, e.g. `image = "example.jpg"`.
#[header]
#image = "Sleeping_Empire.jpg"
#caption = "My caption :smile:"

+++

The use of propensity score methods (Rosenbaum & Rubin, 1983) for estimating causal effects in observational studies or certain kinds of quasi-experiments has been increasing in the social sciences (Thoemmes & Kim, 2011) and in medical research (Austin, 2008) in the last decade. Propensity score analysis (PSA) attempts to adjust selection bias that occurs due to the lack of randomization. Analysis is typically conducted in two phases where in phase I, the probability of placement in the treatment is estimated to identify matched pairs or clusters so that in phase II, comparisons on the dependent variable can be made between matched pairs or within clusters. R (R Core Team, 2012) is ideal for conducting PSA given its wide availability of the most current statistical methods vis-à-vis add-on packages as well as its superior graphics capabilities.

This talk will provide a theoretical overview of propensity score methods as well as illustrations and discussion of PSA applications. Methods used in phase I of PSA (i.e. models or methods for estimating propensity scores) include logistic regression, classification trees, and matching. Discussions on appropriate comparisons and estimations of effect size and confidence intervals in phase II will also be covered. The use of graphics for diagnosing covariate balance as well as summarizing overall results will be emphasized.

______

