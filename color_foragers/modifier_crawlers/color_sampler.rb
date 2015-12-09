# Todo
# crawl color gradients
# find best_possible RGB
# color matchers
# energy curves (equipotential)
# Winston points out that Euclidean metric
#    might not be what I want as it matches
#    luminosity most likely.
# If not close enough, give up and walk
# a second guesser that emulates shaking the mouse!!
# CHI SQUARE AND PIXELATORS

require (File.expand_path('./color_crawlers', File.dirname(__FILE__)))



	def setup
		text_font create_font("SanSerif",25) ; no_stroke
		@img = loadImage("/Users/Jon/Desktop/CIE_1931.png")
		@jmg = loadImage("/Users/Jon/Desktop/scans/imgo_daniel.jpeg")
		# @img = loadImage("/Users/Jon/Desktop/scans/apollonius.jpg");

		# width, height
		size(1400,1080) #HOME
		# size(1920,1080) #JackRabbit
		background(20) ; frame_rate 30
		@w,@h = [width,height].map{|i|i/2.0}
  	@walker = [@w+400,@h-200] ; @m = [235,18,85] ; @i = 0
	end

	def trigs(theta)#:: Theta -> R2
	  %w(cos sin).map{|s| eval("Math.#{s} #{theta}")}
	end

	def rootsUnity(numbre)#::Int -> [trivalStar]
		(0...numbre).map{|i|trigs(i*2*PI/numbre)}
	end

	def rgb_converter(m=0,n=0)
		k = get(m,n)
		r = 256 + k/(256**2)
		g = k/256 % 256
		b = k % 256
		[r,g,b]
	end

	def	mouseMoved#Dragged#Clicked
		@m = rgb_converter(mouseX,mouseY)
	end

	def diff(w)#::R^3->R^3->Distance
		norm = w.transpose.map{|p|p.inject(:-)**2}
		Math.sqrt(norm.inject :+)
	end
	
		# better neighborhoods and guesses
		# sum along rays?
		# spider_plant like sporing?
		# diff of the diff?
		# remember the last n and if jostling make e_ball smaller.
		# modifiers: slash_n_burn(replaces with distant color);cultivator(smooths landscape);sorter
		# collaborative crawlers: scratch my back . .
		# grasshopper
		# CHI SQUARE ROTATOR.
###########
	def walker_y(p=@walker) # center of mass 
		# center of mass, not very robust, bug when all nears are the same.
		pair = @high_pair.nil? ? @walker : @high_pair
		e_ball = rand(100) # <- novel idea

		neighborhood = rootsUnity(17)+[[0,0]]
		rgb_weights = neighborhood.map do |s|
			unital_color = pair.zip(s).map{|p,r|p+r*e_ball}
			diff([rgb_converter(*unital_color), @m])
		end

		weight_total = rgb_weights.inject(0,:+)
		aTTw = neighborhood.zip(rgb_weights).inject([]) do |s,abw| 
			s << abw[0].map{|i|i*abw[1]}
		end.transpose.map{|i|i.inject :+}
		norm = aTTw.map{|i|-i*10/weight_total}
		@high_pair = norm.zip(pair).map{|rp|rp.inject :+}

		fill(255,255,255) ; text('y',*@high_pair)
	end

	def walker_z(p=@walker) # least difference
		pair = @low_pair.nil? ? @walker : @low_pair
		e_ball = rand(100) # <- novel idea

		@low_pair = (rootsUnity(17)+[[0,0]]).min_by do |s|
			unital_color = pair.zip(s).map{|p,r|p+r*e_ball}
			diff([rgb_converter(*unital_color), @m])
		end.zip(pair).map{|rp|rp.inject :+}

		fill(0,0,0) ; text('z',*@low_pair)
	end

	def walker_w(p=@walker) # modifier
		pair = @mod_pair.nil? ? @walker : @mod_pair
		e_ball = rand(300) # <- novel idea

		@mod_pair = (rootsUnity(17)+[[0,0]]).min_by do |s|
			unital_color = pair.zip(s).map{|p,r|p+r*e_ball}
			diff([rgb_converter(*unital_color), @m])
		end.zip(pair).map{|rp|rp.inject :+}

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
		fill(0,0,0) ; text('w',*@mod_pair)
	end
#######
	def images
		if @i < 1
			image(@jmg,10,10) # left picture
			scale(0.3) ; image(@img, 1.8*width, 10) ; scale(10/3.0) #CIE
			# scale(0.6) ; image(@img, width-450, 10) ; scale(5/3.0) #APOLLONIUS
			save('/Users/Jon/Desktop/test.png')
			@loaded = loadImage("/Users/Jon/Desktop/test.png")
		else
			image(@loaded,0,0)
		end
	end
##########
	def draw
		images ; @i = 1
		@mod_pair.nil? ? nil : set(*@mod_pair,0)
		@loaded = get

		# color ellipse
		fill(*@m,250) ; ellipse(width-300,height-300,200,200);
		fill(255,255,255) ; text("#{@m}",width-480,height-150)

		# best guess ellipse
		it = @low_pair.nil? ? @m : rgb_converter(*@low_pair)
		fill(*it,200) ; ellipse(width-200,height-300,200,200)
		fill(255,255,255) ; text("#{it}",width-340,height-250)

		walker_z
		walker_y
		walker_w
	end
