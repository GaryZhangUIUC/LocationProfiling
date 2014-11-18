require_relative './lib/em_framework'
require_relative './lib/gps'
require_relative './lib/location_profile'
include EMFramework

gps = GPS.new(-88.2269172, 40.1124997)
locations = EMFramework.run(gps, 200, 300, 2)
p locations
locations.each do |location|
	p location.weighted_keywords
end