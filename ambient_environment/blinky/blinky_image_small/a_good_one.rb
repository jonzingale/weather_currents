# Blinky Lights for blinky images.
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
	def rand_board ; (0...@width).map{|i| (0...@height).map{|j| rand 2 } } ; end
	def cell_at(row,col) ; @board[row][col] ; end

	def neighborhood(row,col) # generalize this
		NEARS.map{|ns| cell_at((row+ns[0]) % @width, (col+ns[1]) % @height) }
	end

	# rgb_blink, find a way to ignore black?
	def rgb_avg(color_ary)
		good_neighs = color_ary.reject{|n| little_green?(n) }
		good_neighs.transpose.map{|cs| cs.inject(0,:+)/(good_neighs.count)}
	end

	def blink(color_state,neigh)
		state = little_green?(color_state) ? 0 : 1
		sum_neigh_state = neigh.map{|n| little_green?(n) ? 0 : 1 }.inject :+

		# turn off
		state==0&&little_green?(color_state)&&sum_neigh_state<2 ? [0] * 3 << 100 :
		# turn on
		state==0&&sum_neigh_state==3 ? rgb_avg(neigh) :
		# don't change
		middle_green?(color_state) ? color_state :
		# stay on
		state==1&&(sum_neigh_state==3||sum_neigh_state==2) ? color_state : color_state #[0,250,32,100]
	end

	# tinker here for ranges. once something is no longer on it
	# may not know to turn back on correctly.

	# def is_white?(colors) ; colors.first > 220 ; end
	# def is_black?(colors) ; colors.first < 10 ; end
	def much_green?(colors) ; colors[1] > 200 ; end
	def little_green?(colors) ; colors[1] < 100 ; end # 30
	def middle_green?(colors) ; !much_green?(colors)&&!little_green?(colors) ; end

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
