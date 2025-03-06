library(hexSticker)

# Generate hex logo for website
sticker(
	"Headshot_Cartoon_nobackground.png",
	# p_blank,
	package = '',
	p_size = 14,
	p_x = 1.0,
	p_y = 1.3,
	url = 'www.bryer.org',
	u_color = 'white',
	u_size = 10,
	u_x = 1.0,
	u_y = 0.1,
	h_fill = "#C4D458",
	h_color = "#1F4C5F",
	s_x = 1,
	s_y = 1,
	s_width = 0.9,
	s_height = 0.9,
	white_around_sticker = TRUE,
	filename = 'website_hex.png'
)

# Generate project hex logos for those without.
projects <- c('DTedit', 'ipeds', 'multilevelPSA', 'naep', 'pisa', 'qualtrics', 'ruca', 'sqlutils', 'timeline')

p_blank <- ggplot(mtcars, aes(x = wt, y = mpg)) + geom_blank() + theme_void()

for(i in projects) {
	sticker(
		# "Headshot_Cartoon_nobackground.png",
		p_blank,
		package = i,
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
		filename = paste0('projects/', i, ".png")
	)
}

