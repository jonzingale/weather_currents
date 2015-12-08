# The goal here is show a map of the united states
# and to show, by scraping, how various cities 'warm up'
# as the day begins and 'cool down' as the sun sets.

# diff in humidity as bent line?
# barometric, windspeed, altitude?

# maybe it would be good to persist data so that
# at a mouse_wheel roll one can see data at various scales.
	DateNow = DateTime.now.strftime('%B %d, %Y').freeze
	StartTime = Time.now.strftime('%l:%M %P').freeze

	LAT_LON_REGEX = /lat=-?(\d+\.\d+)&lon=-?(\d+\.\d+)/.freeze
	CURRENT_TEMP_SEL = './/p[@class="myforecast-current-lrg"]'.freeze
	CURRENT_CONDS_SEL = './/div[@id="current_conditions_detail"]/table/tr'.freeze

	ROOT = File.expand_path('.', File.dirname(__FILE__)).freeze
	USA_MAP = "#{ROOT}/us_maps/us_topographic.jpg".freeze # 1152 × 718
	USA_MAP_TEMP = "#{ROOT}/us_maps/us_topographic_tmp.jpg".freeze

	PHI = 1.618033988749895.freeze
	SECONDS = 1200.freeze # 20 min
	DataPt = 5.freeze

	CITY_DATA = [['santa fe','87505',[441, 372]],
					  	 ['helena','59601',[455,177]],
							 ['bullhead city','86429',[302, 374]],
							 # ['cleveland','44107',[1041, 251]],
							 # ['monroe','98272',[355, 130]],
							 # ['quakertown','18951',[1147, 230]],
							 # ['new orleans','70112',[956,571]],
							 # ['austin','78705',[700,554]],
							 # ['bad lands','57750',[617,224]],
							 # ['albuquerque','87101',[420,407]],
							 # ['san francisco','94101',[197,279]],
							 # ['bismarck','58501',[706,190]],
							 # ['everglades','34139',[1347,707]],
							 # ['annapolis','21401',[1182,301]],
							 # ['detroit','48201',[1000,253]],
							 # ['phoenix','85001',[327,420]],
							 ['atlanta','30301',[1065,435]]
							]

	class Place
		require 'mechanize'
		attr_reader :name, :zipcode, :coords, :geocoords, :agent
		attr_accessor :temp, :humidity, :page, :pressure, :dewpoint

		def initialize name, zipcode, coords
			@name, @zipcode, @coords = name, zipcode, coords

			@agent = Mechanize.new
			agent.follow_meta_refresh = true # new data
			agent.keep_alive = false # no time outs
			@page = agent.get('http://www.weather.gov')
			scrape_data

			@geocoords = LAT_LON_REGEX.match(page.uri.to_s)[1..2]
		end

		def data_grabber(tr,regex)
			regex.match(tr.text)
			$1.nil? ? 0 : $1
		end

		def scrape_data
			form = page.form('getForecast')
			form.inputstring = self.zipcode
			@page = form.submit

			# avoids bad pages for now.
			unless @page.at(CURRENT_TEMP_SEL).nil?
				@temp = @page.at(CURRENT_TEMP_SEL).text.to_i

				page.search(CURRENT_CONDS_SEL).each do |tr|
					/humidity/i =~ tr.text ?  @humidity = data_grabber(tr,/(\d+)%/i) :
					/barometer/i =~ tr.text ? @pressure = data_grabber(tr,/(\d+\.\d+)/i) : nil
					/dewpoint/i =~ tr.text ?  @dewpoint = data_grabber(tr,/(\d+).F/i): nil
				end
			end

		end
	end

	attr_reader :cities, :loaded
	def setup
		text_font create_font("SanSerif",17)
		square = [1450, 800, P3D] ; size(*square)
		@w,@h = [square[0]/2] * 2 ; background(0)
		colorMode(HSB,360,100,100)
		no_stroke ; frame_rate 1

		@i, @t = [0 , 1]

		# border color scale
		(0..200).each{|i| fill(scale_temp(i-10),100,100)
											ellipse(i*9,height,20,20) }

		# It would be cool to geocode and place somehow.
		# somekind of linear transformation I suspect.
		# scaling is a bitch, don't touch
		rs = 0.70 ; rotateX(PI/5.0)
		@loaded = loadImage(USA_MAP)
		@loaded.resize(1152*rs,718*rs)
		image(@loaded,350,180)

		@cities = CITY_DATA.map{|data| Place.new(*data) }
		@cities.each{|city| city.scrape_data}
	end

	def counter ; @i = (@i + 1) % SECONDS ; end

	def map_key
		fill(0,0,0,90) ; rect(100,570,160,130)

		fill(0,100,100)
		text("started at #{StartTime}",100,620)

		current_time = Time.now.strftime('%l:%M %P')
		message = "currently #{current_time}"
		text(message,100,645)

		message = "#{(SECONDS/60.0).round(0)} minutes"
		fill(0,0,100)
		text(message,140, 678)
		text(DateNow,100, 590)

		fill(30,100,100) ; rect(100,665,21*PHI,21)
	end

	def archive
		# for achiving a handful of sequential frames
		dated_name = DateTime.now.strftime('%s') # epoch naming
		# dated_name = DateTime.now.strftime('%m_%d_%Y')
		saveFrame("#{ROOT}/oneday/#{dated_name}.jpg")
	end

	def images
		if @i == 0 ; @t += 1
			archive
			cities.each{ |city| city.scrape_data }
			# saves, loads, then displays.
			save(USA_MAP_TEMP)
			loaded = loadImage(USA_MAP_TEMP)
			image(loaded,0,0)
		end
	end

	def scale_temp temp # linear
		scaled = 360 * ((136-temp)/136.to_f)
		translate = scaled - 82 % 360
	end	

	def plot_temps(city)
		x, y = city.coords
 		coords = [x, y-@t*DataPt]
 		hue = scale_temp(city.temp)
		fill(hue,100,100,70)

		bad_coords = coords[1] < 0
		rect(*coords,DataPt*PHI,DataPt) unless bad_coords
	end

	# def plot_humidity

	# end

	def draw
		counter
		map_key

		cities.each do |city|
			plot_temps(city)
		end

		images
	end
