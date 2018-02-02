library(blogdown)

# blogdown::install_hugo(force = TRUE)
# blogdown::install_theme(theme = "gcushen/hugo-academic")
# blogdown::new_site(theme = "gcushen/hugo-academic")

blogdown::new_post(title = 'Test Post',
				   author = 'Jason Bryer', kind = 'post',
				   slug = NULL,
				   file = NULL,
				   date = Sys.Date())

blogdown::serve_site(port = 2112)
blogdown::stop_server()
blogdown::build_site()

# When updating stops, try running `hugo` in the terminal.

blogdown::hugo_version()
devtools::install_github('rstudio/blogdown')
blogdown::update_hugo()
