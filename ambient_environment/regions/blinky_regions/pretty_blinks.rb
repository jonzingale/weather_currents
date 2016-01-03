# A place to put pretty_prints for blinky
def pretty_print(board)
	e_size = 5
	board.each_with_index do |row, c_dex|
		row.each_with_index do |c, r_dex|
			params = [r_dex,c_dex].map{|i|i*e_size+20} + [e_size]*2
			rgb = (1..3).map{|i| c*(rand 255)}
			fill(*rgb) ; ellipse(*params)
		end
	end
end

def star_print(board) # get or pixel?
	e_size = 1 # must be the same as the grabber somehow.
	board.each_with_index do |row,c_dex|
		row.each_with_index do |c,r_dex|
			params = [r_dex*e_size+0, c_dex*e_size+0] + [e_size] * 2
			fill(*c) ; ellipse *params
		end
	end
end