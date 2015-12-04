		NEARS = [-1,0,1].product([-1,0,1]).select{|i| i!=[0,0]}
		def setup
			background(0)
			size(2000,2000) # TEST
			@wide,@high = [45,45] # cant seem to handle non-squares

			@board = line_board
			no_fill ; strokeWeight(1) ; @i = 0
			frame_rate 1
		end

		def line_board
			them = (0...@wide).map{ (0...@high).map{0}}
			ones = (0...@wide).map{1}
			(them << ones).shuffle
		end

		def rand_line
			if @i % 14 == 13
				rows = @board.drop(1)
				ones = (0...@wide).map{rand 2}
				(rows + ones).shuffle
			else
				@board
			end
		end

		def pretty_print(board)
			board.each_with_index do |row,c_dex|
				e_size = 30 # augmentation size

				row.each_with_index do |c,r_dex|
					stroke(c*rand(255),c*rand(255),c*rand(255))
					x,y = [r_dex,c_dex].map{|i|i*e_size+100}

					#mosaic
					middle_vals = [x,y,x,y].map{|coord| s = e_size*3 ; coord+(s/2-rand(s)) }
					curb = [x,y]+middle_vals+[x,y]
					fill(c*rand(255),c*rand(255),c*rand(255))
					bezier(*curb)
				end
			end
		end

		def cell_at(row,col,board) ; board[row][col] ; end
		def neighborhood(row,col,board) # better way to rid of [0,0] ? 
			NEARS.map{|ns| n,m = ns; cell_at((row+n) % @wide,(col+m) % @high,board) }
		end

		def blink(state,neigh)
			sum = neigh.inject :+
			sum == 3 ? 1 : (sum==2&&state==1) ? 1 : 0 
		end	
		
		def blink_once(board)
			b,bs = [:take,:drop].map{|f|board.send(f,@wide)}
			board.empty? ? [] : blink_once(bs).unshift(b)
		end

		def go_team(board)
			beers = (0...@wide).inject([]){|is,i| is + (0...@high).map{|j| [i,j]} }
			b_row = beers.map do |xy|
				b_params = xy << board
				blink cell_at(*b_params), neighborhood(*b_params)
			end		
			blink_once(b_row)
		end

		def draw
			@i += 1 ; clear
			pretty_print(@board)

			@board = rand_line

			@board = go_team(@board)
		end
