	BasePath = "/Users/Jon/Desktop/crude/weather_currents/ambient_environment/regions"
	Test1 = "#{BasePath}/region_images/shapes/test_1.png"
	Test2 = "#{BasePath}/region_images/test_2.png"

	Rectangle = "#{BasePath}/region_images/shapes/rectangle.png"
	Ellipse = "#{BasePath}/region_images/shapes/ellipse.png"
	Star = "#{BasePath}/region_images/shapes/star.png"

	def setup
		size(displayWidth, displayHeight)
    frame_rate 2
    
    # uncomment to generate images
		# draw_idea

		# uncomment to see generated images.
		loadImages
	end

	def loadImages
		@circle = loadImage Ellipse
		@star = loadImage Star
		@rect = loadImage Rectangle

		image(@circle,0,0)
		image(@star,0,0)
		image(@rect,0,0)
	end

	def rootsUnity(n)#::Int -> [Star]
  	(0...n).map{|i| %w(sin cos).map{|s| Math.send(s,6.28*i/n)}}
  end

	def draw_idea
    # make sure these exist
		@image = loadImage Test2
		@overlay = loadImage Test1

		PIobject preserving alpha value!
		@pg = createGraphics(width,height)

	  @pg.beginDraw
	  @pg.colorMode(HSB,360,100,100,100)
	  @pg.background(0,0,0,0)
	  @pg.no_stroke

  	@pg.fill(200,70,100,60) # star
  	rootsUnity(5).each{|s,c| @pg.ellipse(s*150+600,c*150+300,300,300)}

	  @pg.fill(30,100,100,60) # ellipse
	  @pg.ellipse(450,400,400,500)

	  @pg.fill(20,100,100,60) # rectangle
	  @pg.rect(200,400,600,500,0,0,20,100)

	  @pg.endDraw

	  archive
	end

	def archive	# save with transparency.
		@i.nil? ? (sleep 2 ; @pg.save(Star) ; @i = true) : nil 
	end

	def draw
		# sleep(1)
		image(@image,0,0)
		image(@overlay,0,0)
	end
