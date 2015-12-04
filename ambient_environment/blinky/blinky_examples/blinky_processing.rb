# todo
# get the board size stuff together.
# keep @i as small as it needs to be.
# dream.
		def setup
			background(0)
			# width, height
			# size(1920,1080) #JackRabbit
			# size(1500,900) # Home
			size(800,800)
			@wide,@high = [30,30]
			@board = rand_board ; @i = 0
			no_fill ; strokeWeight(1)
			frame_rate 1 #for original 5 fastest
		end

		def pretty_print(board)
			board.each_with_index do |row,c_dex|
				e_size = 10 # size of augmentation
				row.each_with_index do |c,r_dex|
					# stroke(c*rand(255),c*rand(255),c*rand(255))
					x,y = [r_dex,c_dex].map{|i|i*e_size+100}

					# #original game
					fill(c*rand(255),c*rand(255),c*rand(255))
					ellipse(x,y,e_size,e_size)


					# # crazy ass lines
					# stroke(c*rand(255),c*rand(255),c*rand(255))
					# line(x,y,e_size,e_size)

					# more crazy ass lines
					# curb = [width,x,height,@wide,y,@high,x,y]
					# curb = [width,x,height,y,@wide,@high,x,y]
					# curb = [0,0,x,y,@wide,@high,width,height]
					# curb = [x,y,0,0,width,height,x,y]

					#confetti
					# x,y = [x,y]
					# middle_vals = [x,y,x,y].map{|i| s = e_size*4 ; i+rand(s)-(s/2) }
					# curb = [x,y]+middle_vals+[x,y]
					# stroke(c*rand(255),c*rand(255),c*rand(255))
					# fill(c*rand(255),c*rand(255),c*rand(255))
					# bezier(*curb)
				end
			end
		end
		
		def rand_board
			(0...@wide).map{|i| (0...@high).map{|j| rand(2)} }
		end
		
		def cell_at(row,col,board) ; board[row][col] ; end
		
		def neighborhood(row,col,board)
			nears = (-1..1).inject([]){|is,i| is + (-1..1).map{|j| [i,j]} }
			nears = nears.select{|i| i!=[0,0]}
			nears.map{|ns| n,m = ns ; cell_at((row+n) % @wide,(col+m) % @high,board) }
		end
			
		def blink(state,neigh)
			sum=neigh.inject(0){|sum,i| sum+i}
			sum == 3 ? 1 : (sum==2&&state==1) ? 1 : 0 
		end	
		
		def coord_it(board)
			beers = (0...@wide).inject([]){|is,i| is << (0...@high).map{|j| [i,j]} }
			board.zip(beers).inject([]) do |bs,crazy|
				states,coords = crazy
				bs + states.zip(coords).map{|them| s,cd = them ; cd.unshift(s)}
			end
		end
		
		def blink_once(board)
			b = board.take(@wide)
			bs = board.drop(@wide)
			board.empty? ? [] : blink_once(bs).unshift(b)
		end

		def go_team(board)
			beers = (0...@wide).inject([]){|is,i| is + (0...@high).map{|j| [i,j]} }
			b_row=beers.map do |xy|
				b_params = xy<<board
				blink(cell_at(*b_params),neighborhood(*b_params))
			end		
			blink_once(b_row)
		end

		def draw
			@i += 1
			pretty_print(@board)
			@board = go_team(@board)
		end
