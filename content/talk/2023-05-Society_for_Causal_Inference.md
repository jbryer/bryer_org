+++
date = 2017-01-01T00:00:00  # Schedule page publish date.

title = "Bootstrapping for Propensity Score Analysis"
time_start = 2023-05-24T09:00:00
time_end = 2023-05-26T12:30:00
abstract = "As the popularity of propensity score methods for estimating causal effects in observational studies increase, the choices researchers have for which methods to use has also increased. Rosenbaum (2012) suggested that there are benefits for testing the null hypothesis more than once in observational studies. With the wide availability of high power computers resampling methods such as bootstrapping (Efron, 1979) have become popular for providing more stable estimates of the sampling distribution. This paper introduces the PSAboot package for R that provides functions for bootstrapping propensity score methods. It deviates from traditional bootstrapping methods by allowing for different sampling specifications for treatment and control groups, mainly to ensure the ratio of treatment-to-control observations are maintained. Additionally, this framework will provide estimates using multiple methods for each bootstrap sample. Two examples are discussed: the classic National Work Demonstration and PSID (Lalonde, 1986) study and a study on tutoring effects on student grades."
abstract_short = ""
event = "Society for Causal Inference Annual Meeting"
event_url = "https://sci-info.org/annual-meeting/"
location = "Austin, TX"

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

As the popularity of propensity score methods for estimating causal effects in observational studies increase, the choices researchers have for which methods to use has also increased. Rosenbaum (2012) suggested that there are benefits for testing the null hypothesis more than once in observational studies. With the wide availability of high power computers resampling methods such as bootstrapping (Efron, 1979) have become popular for providing more stable estimates of the sampling distribution. This paper introduces the PSAboot package for R that provides functions for bootstrapping propensity score methods. It deviates from traditional bootstrapping methods by allowing for different sampling specifications for treatment and control groups, mainly to ensure the ratio of treatment-to-control observations are maintained. Additionally, this framework will provide estimates using multiple methods for each bootstrap sample. Two examples are discussed: the classic National Work Demonstration and PSID (Lalonde, 1986) study and a study on tutoring effects on student grades.

______

