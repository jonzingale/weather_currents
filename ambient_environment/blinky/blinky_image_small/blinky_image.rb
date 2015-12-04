# The goal here is modify an image with blinkiness.
# 
require (File.expand_path('blinky_test', File.dirname(__FILE__)))
require (File.expand_path('pretty_blinks', File.dirname(__FILE__)))
# load_java_library "opengl"
# include_package "processing.opengl"
IMAGES_PATH = File.expand_path('blinky_images', File.dirname(__FILE__)).freeze

CHRISTMAP = "#{IMAGES_PATH}/russ_garden.jpg".freeze
CHRISTMAP_TEMP = "#{IMAGES_PATH}/russ_garden.jpg".freeze

	attr_reader :loaded
	def setup
		text_font create_font("SanSerif", 20)
		size = 675, 900 ; size(*size)
		@w, @h = @width/2.0, @height/2.0
		background 0 ; @i, @t = 0, 1

		no_stroke ; frame_rate 0.2 # really fast for small boards.
		bs = [670] * 2
		# bs = [335] * 2 # for pixels of size 2
		
		# bs = [@height/2.0, @height/2.0]
		# no_stroke ; frame_rate 0.1 # really slow for big boards.

		@loaded = loadImage(CHRISTMAP) ; image(@loaded,0,0)
		@blinky = Blinky.new(*bs) ; @blinky.image_board(scan_image)
	end

	def rgb_converter(m=0,n=0)
		k = get(m,n)
		r = 256 + k/(256**2)
		g = k/256 % 256
		b = k % 256
		[r,g,b,100]
	end

	def scan_image# scans images to pass to a board as state.
		e_size = 1 # must mirror the logistic_print somehow.
		@blinky.board.map.with_index do |row,c_dex|
			row.map.with_index do |c,r_dex|
				params = [r_dex * e_size + 0, c_dex * e_size + 0]
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
			save(CHRISTMAP_TEMP)
			loaded = loadImage(CHRISTMAP_TEMP)
			image(loaded,0,0)
		end
	end

	# def mouseMoved
	# 	coords = [(mouseX or 10),(mouseY or 10)]
	# 	fill(20); rect(50,50,200,100)
	# 	fill(123,90,90,255)
	# 	text("#{rgb_converter(*coords)}",100,100)
	# end
