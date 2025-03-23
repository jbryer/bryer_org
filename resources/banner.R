library(ggplot2)

banner_image <- function(
		title,
		date = format(Sys.Date(), '%B %d, %Y'),
		url = 'www.bryer.org',
		out_file,
		width = 900,
		height = 600
) {
	course_logo <- png::readPNG("~/Dropbox (Personal)/Projects/Bryer_org/website_hex.png") |>
		grid::rasterGrob(interpolate = TRUE)

	p <- ggplot2::ggplot() +
		ggplot2::annotate(geom = 'text', label = likert:::label_wrap_mod(title, width = 35),
						  x = 0, y = 6.0, color = '#0033A1',
						  hjust = 0, size = 30, size.unit = 'pt', fontface = 'bold') +
		ggplot2::annotate(geom = 'text', label = date, x = 0, y = 3.5, color = '#0033A1',
						  hjust = 0, size = 22, size.unit = 'pt') +
		ggplot2::annotate(geom = 'text', label = url, x = 10, y = 0, color = '#FF9822',
						  hjust = 1, size = 20, size.unit = 'pt', fontface = 'bold',
						  family = 'mono') +
		ggplot2::annotation_custom(course_logo, xmin = 7, xmax = 10, ymin = 0, ymax = 10) +
		ggplot2::xlim(0, 10) + ggplot2::ylim(0, 10) +
		ggplot2::geom_point() +
		ggplot2::theme_void() +
		ggplot2::theme(plot.background = ggplot2::element_rect(fill = 'white'))
	ggplot2::ggsave(filename = out_file,
					plot = p,
					width = width,
					height = height,
					units = 'px',
					dpi = 72,
					device = 'png')
}

hex_logo <- function(
		title,
		out_file = paste0('projects/', title, ".png")
) {
	p_blank <- ggplot(mtcars, aes(x = wt, y = mpg)) + geom_blank() + theme_void()

	sticker(
		# "Headshot_Cartoon_nobackground.png",
		p_blank,
		package = title,
		p_size = 14,
		p_x = 1.0,
		p_y = 1.3,
		url = 'www.bryer.org',
		u_color = 'white',
		u_size = 8,
		u_x = 1.05,
		u_y = 0.15,
		h_fill = "#C4D458",
		h_color = "#1F4C5F",
		s_x = 1,
		s_y = 0.75,
		s_width = .25,
		s_height = .25,
		filename = out_file
	)
}
