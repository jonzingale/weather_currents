# For Light Shows Perhaps
# 
require (File.expand_path('blinky', File.dirname(__FILE__)))
require (File.expand_path('pretty_blinks', File.dirname(__FILE__)))
IMAGES_PATH = File.expand_path('blinky_images', File.dirname(__FILE__)).freeze

LOGMAP = "#{IMAGES_PATH}/LogisticMap.jpg".freeze # 1911.52, 1352.0
LOGMAP_TEMP = "#{IMAGES_PATH}/LogisticMap_tmp.jpg".freeze
SECONDS = 2.freeze # 1/2 sec

	attr_reader :loaded
	def setup
		text_font create_font("SanSerif",90)
		size = 1911, 1352 ; size(*size)
		@w,@h = 500, 500

		background 0 ; fill 0
		colorMode(HSB,360,100,100)
		no_stroke ; frame_rate 1
		@i, @t = 0, 1

		@loaded = loadImage(LOGMAP)
		image(@loaded,0,0)

		bs = [@width,@height].map{|s| s * 3 / 16}
		@blinky = Blinky.new(*bs)
	end

	def draw
		pretty_print(@blinky.board)
		cs = get(1200,1200)
		text("#{cs}",100,400)

		text("#{[@i,@t]}",100,100)
		images if @t < 1
	end

	def images
		if @i == 0 ; @t += 1
			# saves, loads, then displays.
			save(LOGMAP_TEMP)
			loaded = loadImage(LOGMAP_TEMP)
			image(loaded,0,0)
		end
	end
