# The goal here is modify a transluscent image with blinkiness.
require (File.expand_path('blinky', File.dirname(__FILE__)))

	Eball = 3.freeze
	TRANSPARENT = -16777216.freeze
	IMAGES_PATH = File.expand_path('./', File.dirname(__FILE__)).freeze
	StarImage = "#{IMAGES_PATH}/star.png".freeze
	StarImageTEMP = "#{IMAGES_PATH}/star_tmp.png".freeze

	attr_reader :loaded
	def setup
		text_font create_font("SanSerif", 10)
		colorMode(HSB,360,100,100,100)
		size = 670, 670 ; size(*size)
		@w, @h = @width/2.0, @height/2.0
		background 0 ; @i = 0
		bs = boards_n_rates 3

		@star_image = loadImage(StarImage)
		image(@star_image, 30, 10)
		@blinky = Blinky.new(*bs)
		@blinky.image_board(scan_image)
	end

	def boards_n_rates(e_size)
		no_stroke ; frame_rate 1 #<--- RATE
		bs = [223] * 2 # 335

		# no_stroke ; frame_rate 0.3
		# bs = [670] * 2 # 335
	end

	def transluscent?(m=0,n=0) ; get(m,n) == TRANSPARENT ; end

	# puts a color at each i,j pair.
	def scan_image# scans images to pass to a board as state.
		@blinky.board.map.with_index do |row, c_dex|
			row.map.with_index do |c, r_dex|
				params = [r_dex * Eball + 0, c_dex * Eball + 0]
				transluscent?(*params) ? 0 : 100
			end
		end
	end

	# TODO: create a product object of region (static array)
	# and board (dynamic array), and write a binary operation
	# to combine them.
	def star_print(board) # get or pixel?
		board.each_with_index do |row, c_dex|
			row.each_with_index do |c, r_dex|
				params = [r_dex*Eball+0, c_dex*Eball+0] + [Eball] * 2
				# since both image_board and blinky_board have the same dimensions.
				# an obvious OPTIMIZATION	is to combine the content of both arrays
				# into the same array. Also OPTIMIZATION, don't consider quiescents.
				# 3 states to consider: quiescent, active, off.
				color_bool = @blinky.image[c_dex][r_dex]
				fill(210+rand(100),100,50+50*c, color_bool) ; ellipse *params
			end
		end
	end

	def draw
		clear
		star_print @blinky.board
		@blinky.go_team
		# images
	end

	# def images
	# 	if @t.nil? ; @t = 0
	# 		# saves, loads, then displays.
	# 		save(StarImageTEMP)
	# 		loaded = loadImage(StarImageTEMP)
	# 		image(loaded,0,0)
	# 	end
	# end

	# def rgb_converter(m=0,n=0)
	# 	k = get(m,n)
	# 	if k == TRANSPARENT
	# 		[0] * 4
	# 	else
	# 		r = 256 + k/(256**2)
	# 		g = k/256 % 256
	# 		b = k % 256
	# 		[r, g, b, 100]
	# 	end
	# end