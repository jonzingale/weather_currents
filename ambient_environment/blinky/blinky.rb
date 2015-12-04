# Blinky Lights
class Blinky
	NEARS = [-1,0,1].product([-1,0,1]).select{|i| i!=[0,0]}

	attr_accessor :board
	def initialize(width=20,height=20)
		@width, @height = width, height
		@board = rand_board
		@i = 0
	end

	def pretty_print
		@board.each do |row|
			puts row.join('').gsub(/[01]/, '0' => '   ', '1' => ' * ')
		end
	end

	def rand_board
		(0...@width).map{|i| (0...@height).map{|j| rand 2} }
	end
	
	def cell_at(row,col) ; @board[row][col] ; end

	def neighborhood(row,col) # generalize this
		NEARS.map{|ns| cell_at((row+ns[0]) % @width, (col+ns[1]) % @height) }
	end

	# generalize this
	def blink(state,neigh)
		sum = neigh.inject :+
		sum == 3 ? 1 : (sum==2&&state==1) ? 1 : 0 
	end

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
