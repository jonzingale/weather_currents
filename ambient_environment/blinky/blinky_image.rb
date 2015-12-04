# The goal here is modify an image with blinkiness.
# 
require (File.expand_path('blinky_test', File.dirname(__FILE__)))
require (File.expand_path('pretty_blinks', File.dirname(__FILE__)))
IMAGES_PATH = File.expand_path('blinky_images', File.dirname(__FILE__)).freeze

LOGMAP = "#{IMAGES_PATH}/LogisticMap.jpg".freeze
LOGMAP = "#{IMAGES_PATH}/LogisticMap.jpg".freeze
LOGMAP_TEMP = "#{IMAGES_PATH}/LogisticMap_tmp.jpg".freeze

	attr_reader :loaded
	def setup
		text_font create_font("SanSerif",20)
		size = 1911, 1034 ; size(*size)
		@w, @h = @width/2.0, @height/2.0
		background 0 ; @i, @t = 0, 1

		# no_stroke ; frame_rate 10 # really fast for small boards.
		# bs = [100] * 2
		
		bs = [@height/2.0,@height/2.0]
		no_stroke ; frame_rate 0.1 # really slow for big boards.

		@loaded = loadImage(LOGMAP) ; image(@loaded,0,0)
		@blinky = Blinky.new(*bs) ; @blinky.image_board(scan_image)
	end

	def rgb_converter(m=0,n=0)
		k = get(m,n)
		r = 256 + k/(256**2)
		g = k/256 % 256
		b = k % 256
		[r,g,b]
	end

	def scan_image# scans images to pass to a board as state.
		e_size = 2 # must mirror the logistic_print somehow.
		@blinky.board.map.with_index do |row,c_dex|
			row.map.with_index do |c,r_dex|
				params = [r_dex * e_size + 855, c_dex * e_size + 5]
				rgb_converter(*params)
			end
		end
	end

	def draw
		logistic_print @blinky.board
		@blinky.go_team
		images if @t < 1# just once
	end

	def images
		if @i == 0 ; @t += 1
			# saves, loads, then displays.
			save(LOGMAP_TEMP)
			loaded = loadImage(LOGMAP_TEMP)
			image(loaded,0,0)
		end
	end

	# def mouseMoved
	# 	coords = [(mouseX or 10),(mouseY or 10)]
	# 	fill(20); rect(50,50,200,100)
	# 	fill(123,90,90,255)
	# 	text("#{rgb_converter(*coords)}",100,100)
	# end
