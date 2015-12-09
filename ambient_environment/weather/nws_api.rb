
#!/usr/bin/env ruby 
	require 'byebug'

	TOKEN = 'wvLwKMPNpxlWzKtegSBvuVjygWhgJjnu'
	CITY_DATA = [['santa fe','87501',[441, 372],'KSAF']].freeze
	BASE_URL = 'http://www.ncdc.noaa.gov/cdo-web/api/v2/stations'.freeze

	class Place
		require 'mechanize'
		require 'xmlsimple'

		attr_reader :name, :zipcode, :coords, :geocoords, :agent, :source_id
		attr_accessor :temp, :humidity, :page, :pressure, :dewpoint

		def initialize name, zipcode, coords, source_id
			@name, @zipcode, @coords, @source_id = name, zipcode, coords, source_id

			@agent = Mechanize.new
			agent.follow_meta_refresh = true # new data
			agent.keep_alive = false # no time outs
			@page = agent.get('http://w1.weather.gov/xml/current_obs/KSAF.xml')	
			xml_data
		end

		def xml_data
      response = XmlSimple.xml_in(page.body.to_s)
			# response.keys.each{|k| puts "#{k} = response['#{k}']" }
byebug
      temp = response['temp_f'][0].to_f
      wind_mph = response['wind_mph'][0].to_f
      # location = response['location'][0].to_f

      latitude = response['latitude'][0].to_f
      longitude = response['longitude'][0].to_f

      windchill_f = response['windchill_f'][0].to_f
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

	@cities = CITY_DATA.map{|data| Place.new(*data) }
	@cities.each{|city| city.xml_data}

byebug ; 4

	# working curl
	# curl 'http://www.ncdc.noaa.gov/cdo-web/api/v2/stations' -H 'token:wvLwKMPNpxlWzKtegSBvuVjygWhgJjnu'

	# agent = Mechanize.new
	# agent.pre_connect_hooks << lambda do |agent, request|
	#    request['token'] = 'wvLwKMPNpxlWzKtegSBvuVjygWhgJjnu'
	#  end
# http://www.ncdc.noaa.gov/cdo-web/api/v2/datatypes/{id}
  # response = agent.get('http://www.ncdc.noaa.gov/cdo-web/api/v2/datatypes/KSAF')