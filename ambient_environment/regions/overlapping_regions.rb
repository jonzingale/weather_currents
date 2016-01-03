
	BASE_PATH = "/Users/Jon/Desktop/crude/weather_currents/ambient_environment/regions".freeze
	Test1 = "#{BASE_PATH}/region_images/test_1.png"
	Test2 = "#{BASE_PATH}/region_images/test_2.png"

	def setup
		size(displayWidth, displayHeight)
    frame_rate 2

    # make sure these exist
		@image = loadImage Test2
		@overlay = loadImage Test1

		# PIobject preserving alpha value!
		@pg = createGraphics(width,height)
		draw_idea
	end

	def draw_idea
	  @pg.beginDraw
	  @pg.colorMode(HSB,360,100,100,100)
	  @pg.fill(200,100,100,100)
	  @pg.background(0,0,0,0)

	  @pg.text_font(create_font("SanSerif",100))
	  @pg.text('This is the Shit!!',400,300)
	  @pg.endDraw

	  archive
	end

	def archive	# save with transparency.
		@i.nil? ? (sleep 2 ; @pg.save(Test1)) : @i = true
	end

	def draw
		image(@image,0,0)
		image(@overlay,0,0)
	end
