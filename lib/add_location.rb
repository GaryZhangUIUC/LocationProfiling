require 'mysql'  
require 'json'
require 'rubygems'
require 'openssl'
require 'geokit'
con = Mysql.new('harrier02.cs.illinois.edu', 'pawar2', 'change_me#', 'test')  
city=", Champaign, IL"
locations=[]
File.open("../data/locations.txt", "r") do |f|
  f.each_line do |line|
    locations<<line.strip
  end
end

locations.each do |location|
	p location
	geo=Geokit::Geocoders::GoogleGeocoder.geocode(location+city)
	lat=geo.lat
	lon=geo.lng
	region = "Champaign, IL, USA"
	con.query("insert into locations (name, region, lat, lon) values ('#{location}', '#{region}', #{lat}, #{lon})")
	sleep(1)
end