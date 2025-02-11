library(blogdown)

# blogdown::install_hugo(force = TRUE)
# blogdown::install_theme(theme = "gcushen/hugo-academic")
# blogdown::new_site(theme = "gcushen/hugo-academic")

# blogdown::new_post(title = 'Test Post',
# 				   author = 'Jason Bryer', kind = 'post',
# 				   slug = NULL,
# 				   file = NULL,
# 				   date = Sys.Date())


options(blogdown.hugo.version = "0.54.0")

blogdown::serve_site(port = 2112)
blogdown::stop_server()

blogdown::build_site(build_rmd = TRUE)

# When updating stops, try running `hugo` in the terminal.

blogdown::find_hugo('all')
blogdown::install_hugo(version = '0.54.0', use_brew = FALSE, extended = TRUE)
blogdown::install_hugo(version = "0.54.0", extended = TRUE, os = 'macOS', arch = '64bit')

blogdown::hugo_version()
devtools::install_github('rstudio/blogdown')
blogdown::update_hugo()

# blogdown::install_theme('wowchemy/starter-academic')


blogdown::check_site()

