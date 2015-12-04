# Blinky Lights for blinky images.

# require 'benchmark'
# Benchmark.bm do |x|
#   x.report{('A'..'Z').inject([]){|ws,t| ws+('A'..'Z').map{|s|s+t} }}
#   x.report{y = ('a'..'z').to_a ; y.product(y).map{|s,t| s+t } }
# end

class Blinky
	NEARS = [-1,0,1].product([-1,0,1]).select{|i| i!=[0,0]}

	attr_accessor :board
	def initialize(width=20,height=20)
		@width, @height = width, height
		@board = rand_board # default
		@i = 0
	end

	def pretty_print
		@board.each do |row|
			puts row.join('').gsub(/[01]/, '0' => '   ', '1' => ' * ')
		end
	end

	# gets a board from scan_image
	def image_board(color_board) ; @board = color_board ; end

	def weighted_board
		@board = (0...@width).map do |i|
			(0...@height).map do |j|
				([1] * 1 + [0] * 9)[rand 10]
			end
		end
	end

	def rand_board
		(0...@width).map{|i| (0...@height).map{|j| rand 2 } }
	end
	
	def cell_at(row,col) ; @board[row][col] ; end

	def neighborhood(row,col) # generalize this
		NEARS.map{|ns| cell_at((row+ns[0]) % @width, (col+ns[1]) % @height) }
	end

	# # generalize this
	# def blink(state,neigh)
	# 	sum = neigh.inject :+
	# 	sum == 3 ? 1 : (sum==2&&state==1) ? 1 : 0 
	# end


### rgb_blink, find a way to ignore black?
	def blink(color_state,neigh)
		state = is_white?(color_state) ? 0 : 1
		sum = neigh.map{|n| is_white?(n) ? 0 : 1}.inject :+
		good_neighs = neigh.reject{|n| n[0] == 255 }
		avg = good_neighs.empty? ? 0 : good_neighs.map(&:first).inject(:+)/3

		state==0&&is_black?(color_state) ? [0] * 3 :
		state==0&&sum==3 ? [avg] * 3  :
		state==1&&(sum==3||sum==2) ? color_state : [255] * 3
	end

	# tinker here for ranges.
	def is_white?(colors) ; colors.first > 200 ; end
	def is_black?(colors) ; colors.first < 200 ; end

	# def blink(color_state,neigh)
	# 	state = is_white?(color_state) ? 0 : 1
	# 	sum = neigh.map{|n| is_white?(n) ? 0 : 1}.inject :+
	# 	good_neighs = neigh.reject{|n| n[0] == 255 }
	# 	avg = good_neighs.empty? ? 0 : good_neighs.map(&:first).inject(:+)/3

	# 	state==0&&sum==3 ? [avg] * 3  :
	# 	state==1&&(sum==3||sum==2) ? color_state : [255] * 3
	# end
###

	def update(board)
		b = board.take @width
		bs = board.drop @width
		@board = board.empty? ? [] : update(bs).unshift(b)
	end
	
	def go_team
		beers = (0...@width).inject([]) do |is,i| 
			is + (0...@height).map{|j| blink cell_at(i,j), neighborhood(i,j)}
		end
		update(beers)
	end

	# faster version?
	# def go_team(board)
	# 	beers = (0...@wide).inject([]){|is,i| is + (0...@high).map{|j| [i,j]} }
	# 	b_row=beers.map do |xy|
	# 		b_params = xy<<board
	# 		blink(cell_at(*b_params),neighborhood(*b_params))
	# 	end		
	# 	blink_once(b_row)
	# end

	def run_blinky
		while @i<10**5
			sleep(0.3)
			system("clear")
			pretty_print
			go_team
		end
	end
end

# for testing.
# blinky = Blinky.new
# blinky.run_blinky
