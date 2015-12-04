# The goal here is modify an image with blinkiness.
# 
require (File.expand_path('blinky', File.dirname(__FILE__)))
attr_reader :loaded

IMAGES_PATH = File.expand_path('blinky_images', File.dirname(__FILE__)).freeze
CHRISTMAP = "#{IMAGES_PATH}/sunset.jpg".freeze
CHRISTMAP_TEMP = "#{IMAGES_PATH}/sunset_tmp.jpg".freeze

	attr_reader :e_size
	def setup
		text_font create_font("SanSerif", 20)
		size = [1080,1080].map{|t| t/1} ; size(*size)
		@w, @h = @width/2.0, @height/2.0
		background 0 ; @i, @t = 0, 1

		no_stroke ; frame_rate 2 # really fast for small boards.
		# bs = [1080] * 2
		bs = [100] * 2 # for pixels of size 2
		
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
		e_size = 10 # must mirror the logistic_print somehow.
		@blinky.board.map.with_index do |row,c_dex|
			row.map.with_index do |c,r_dex|
				params = [r_dex * e_size + 0, c_dex * e_size + 0]
				rgb_converter(*params)
			end
		end
	end

	def draw
		sunset_print @blinky.board
		@blinky.go_team
		images if @t < 1# just once
	end

	def sunset_print(board) # get or pixel?
		e_size = 10 # must be the same as the grabber somehow.
		board.each_with_index do |row,c_dex|
			row.each_with_index do |c,r_dex|
				params = [r_dex*e_size+0, c_dex*e_size+0] + [e_size] * 2
				fill(*c) ; ellipse *params
			end
		end
	end

	def images
		if @i == 0 ; @t += 1
			# saves, loads, then displays.
			save(CHRISTMAP_TEMP)
			loaded = loadImage(CHRISTMAP_TEMP)
			image(loaded,0,0)
		end
	end
