module Maths
	PI = 3.1415926.freeze

	def p_norm(p,n,i=0)
		n == 0 ? 0 : n % p**i == 0 ? p_norm(p,n,i+1) : p**(1-i)
	end

	def trigs(theta)#:: Theta -> R2
	  %w(cos sin).map{|s| eval("Math.#{s} #{theta}")}
	end

	def rootsUnity(numbre)#::Int -> [trivalStar]
		(0...numbre).map{|i|trigs(i*2*PI/numbre)}
	end

	def p_adic_diff(desire_n_sensed)# ::[R^3,R^3]->Distance
		r_pair, g_pair, b_pair = desire_n_sensed.transpose

		r_diff = r_pair.inject(:-)
		g_diff = g_pair.inject(:-)
		b_diff = b_pair.inject(:-)

		p_norm(3,r_diff) + p_norm(3,g_diff) + p_norm(3,b_diff)
	end

	# def p_adic_diff(desire_n_sensed)# ::[R^3,R^3]->Distance
	# 	desire_sum, color_sum = desire_n_sensed.map{|colors| colors.inject :+}
	# 	p_norm(3,desire_sum - color_sum)
	# end

	def euclidean_diff(w)# ::[R^3,R^3]->Distance
		norm = w.transpose.map{|p|p.inject(:-)**2}
		Math.sqrt(norm.inject :+)
	end
end


# Chi Sqr rotator wheel and pixelators.

class ColorCrawlers
	include Maths
	attr_reader :desire, :sense, :position, :guess, :name

	def initialize(name,width,height)
		@desire = [100,18,205]
		@position = [width+400,height-200]
		@sense = [[@position,@desire]]
		@guess = 100
		@name = name
	end

	def guess # to see what the distance is.
		@guess = @sense.map do |root,color|
			euclidean_diff([@desire, color])
		end.min
	end

	def desired(mouse_color) ; @desire = mouse_color ; end
	def see(sense) ; @sense = sense ; end

	def look_roots# :: Crawler -> ([STEP],[f(STEP)])
		e_ball = rand(@guess)

		rootsUnity(17).unshift([0,0]).map do |inquiry|
			[inquiry, @position.zip(inquiry).map{|p,r|p+r*e_ball}]
		end
	end

	# motives :: [(Root,Color)]
	def motive_p # least p_adic difference
		step = self.sense.min_by{|r,color| p_adic_diff([@desire, color])}.first
		@position = step.zip(self.position).map{|rp|rp.inject :+}
	end

	def motive_z # least euclidean difference
		step = self.sense.min_by{|r,color| euclidean_diff([@desire, color])}.first
		@position = step.zip(self.position).map{|rp|rp.inject :+}
	end

	def motive_y # center of euclidean mass
		roots, colors = self.sense.transpose
		weights = colors.map{|color| euclidean_diff([@desire,color])}
		total_weight = weights.inject(:+)

		# because small differences are heavier.
		scalars = weights.map{|w| 1 - (w/total_weight)}

		# just to decide faster
		scalars.map!{|r| r * 7}

		roots_lamb = roots.zip(scalars).map(&:flatten) # [x,y,s]
		inner_sum = roots_lamb.map{|x,y,s| [x*s,y*s] } # Pair

		step = inner_sum.transpose.map{|s|s.inject :+} # [xsum,ysum]
		@position = step.zip(self.position).map{|rp|rp.inject :+}
	end

# 	def walker_w(p=@walker) # modifier
# 		pair = @mod_pair.nil? ? @walker : @mod_pair
# 		e_ball = rand(300) # <- novel idea

# 		@mod_pair = (rootsUnity(17)+[[0,0]]).min_by do |s|
# 			unital_color = pair.zip(s).map{|p,r|p+r*e_ball}
# 			diff([rgb_converter(*unital_color), @m])
# 		end.zip(pair).map{|rp|rp.inject :+}

# # try using get. then one can 'get' the whole screen with no params
# # saving this may make it possible to color!!!

# 		# loadPixels
# 			# set(*@mod_pair,0) #; x,y = @mod_pair.map(&:to_i)
# 		# 	it = pixels[y*width+x]
# 		# 	it = 0
# 		# 	save('/Users/Jon/Desktop/test.png')
# 		# 	@loaded = loadImage("/Users/Jon/Desktop/test.png")
# 		# updatePixels
# 		# text("#{it} is awesome",200,200)
# 		fill(0,0,0) ; text('w',*@mod_pair)
# 	end

end



# require 'byebug'
# 	include Maths

# it = ColorCrawlers.new('z',100,199)

# sense = Maths.rootsUnity(12).zip((0...12).map{[rand(255),rand(255),rand(255)]})

# it.see(sense)
# it.motive_y
# byebug ; 4



# a class for color crawlers

	# Todo or some Ideas:
	# better neighborhoods and guesses
	# sum along rays?
	# spider_plant like sporing?
	# diff of the diff?
	# remember the last n and if jostling make e_ball smaller.
	# modifiers: slash_n_burn(replaces with distant color);cultivator(smooths landscape);sorter
	# collaborative crawlers: scratch my back . .
	# grasshopper

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
