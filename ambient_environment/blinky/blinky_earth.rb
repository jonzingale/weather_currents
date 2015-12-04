# The goal here is modify an image with blinkiness.
# 
require (File.expand_path('blinky', File.dirname(__FILE__)))
require (File.expand_path('pretty_blinks', File.dirname(__FILE__)))
IMAGES_PATH = File.expand_path('blinky_images', File.dirname(__FILE__)).freeze

LOGMAP = "#{IMAGES_PATH}/LogisticMap.jpg".freeze
LOGMAP_TEMP = "#{IMAGES_PATH}/LogisticMap_tmp.jpg".freeze

PHI = 1.618033988749895.freeze
SECONDS = 2.freeze # 1/2 sec
DataPt = 5.freeze

	attr_reader :loaded
	def setup
		text_font create_font("SanSerif",20)
		size = 1911, 1034 ; size(*size)
		@w, @h = @width/2.0, @height/2.0

		background 0
		colorMode(HSB,360,100,100) #<---- comment out for BlackCloudProduction
		no_stroke ; frame_rate 10 # really slow for big pics.
		# no_stroke ; frame_rate 10 # really slow for big pics.
		@i, @t = 0, 1

		bs = [100, 100]
		# bs = [@height,@height]
		@loaded = loadImage(LOGMAP) ; image(@loaded,0,0)
		@blinky = Blinky.new(*bs)
	end

	def rgb_converter(m=0,n=0)
		k = get(m,n)
		r = 256 + k/(256**2)
		g = k/256 % 256
		b = k % 256
		[r,g,b]
	end

	def mouseMoved
		coords = [(mouseX or 10),(mouseY or 10)]
		fill(20); rect(50,50,200,100)
		fill(123,90,90,255)
		# text("#{coords}",100,100)
		text("#{rgb_converter(*coords)}",100,100)
	end

# try using get. then one can 'get' the whole screen with no params
# saving this may make it possible to color!!!

		# loadPixels
			# set(*@mod_pair,0) #; x,y = @mod_pair.map(&:to_i)
		# 	it = pixels[y*width+x]
		# 	it = 0
		# 	save('/Users/Jon/Desktop/test.png')
		# 	@loaded = loadImage("/Users/Jon/Desktop/test.png")
		# updatePixels
		# text("#{it} is awesome",200,200)


	def draw
		# counter
		# some shit
		logistic_print @blinky.board
		@blinky.go_team

		# fill 0 ; text("#{@h}",200,200)
		images if @t < 1# just once
	end

	def counter ; @i = (@i + 1) % SECONDS ; end

	def images
		if @i == 0 ; @t += 1
			
		# scrape new data here.
			# cities.each{ |city| city.scrape_data }
		# 

			# saves, loads, then displays.
			save(LOGMAP_TEMP)
			loaded = loadImage(LOGMAP_TEMP)
			image(loaded,0,0)
		end
	end


class Board
	attr_accessor :image_board, :rand_board
	def initialize(width=20,height=20)
		@width, @height = width, height
		@board = rand_board
		@i = 0
	end

	def rand_board
		(0...@width).map{|i| (0...@height).map{|j| rand 2} }
	end

	# how might i link to an image?
	def image_board
		(0...@width).map do |i|
			(0...@height).map do |j|
				# ([1]*3+[0]*7)[rand 10]
				rand 2


				# rand 2
			end
		end
	end
end

