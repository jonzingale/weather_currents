	require 'byebug'

	class Place
		require 'mechanize'
		require 'xmlsimple'

		BASE_URL = 'http://w1.weather.gov/xml/current_obs/KSAF.xml'.freeze

		attr_reader :geocoords, :agent
		attr_accessor :temp, :humidity, :page, :pressure, :dewpoint

		def initialize
			@agent = Mechanize.new
			agent.follow_meta_refresh = true # new data
			agent.keep_alive = false # no time outs
			@page = agent.get(BASE_URL)
			xml_data
		end

		def xml_data
      response = XmlSimple.xml_in(page.body.to_s)
			# response.keys.each{|k| puts "#{k} = response['#{k}']" }

      temp = response['temp_f'][0].to_f
      wind_mph = response['wind_mph'][0].to_f
      # location = response['location'][0].to_f

      latitude = response['latitude'][0].to_f
      longitude = response['longitude'][0].to_f

      # protect against missing keys!
      # windchill_f = response['windchill_f'][0].to_f
      station_id = response['station_id'][0].to_f
      dewpoint_f = response['dewpoint_f'][0].to_f
			pressure_in = response['pressure_in'][0].to_f
			visibility_mi = response['visibility_mi'][0].to_f
			wind_mph = response['wind_mph'][0].to_f
			relative_humidity = response['relative_humidity'][0].to_f
			observation_time = response['observation_time'][0].to_f

			@temp = temp
			@humidity = relative_humidity
			@pressure = pressure_in
			@dewpoint = dewpoint_f
			@geocoords = [longitude, latitude]
		end
	end

	# uncomment when testing.
	# santa_fe = Place.new
