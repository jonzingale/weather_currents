# optimizations
# components, set color ahead?
require (File.expand_path('blinky', File.dirname(__FILE__)))
require (File.expand_path('pretty_blinks', File.dirname(__FILE__)))

def setup			
	size(1000,1000) ; background 0
	bs = [@width,@height].map{|s| s * 3 / 16}

	frame_rate 1
	@blinky = Blinky.new(*bs)
end

def draw
	pretty_print(@blinky.board)
	@blinky.go_team
end

# def frame_rates
	# frame rates below are for pretty_print
	# frame_rate_hash = {1200 => 1, 1000 => 2, 800 => 3}
	# fr = (7 - @height / Math.log(@height**30)).to_i
	# frame_rate fr
# end