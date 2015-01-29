require_relative './lib/em_framework'
require_relative './lib/gps'
require_relative './lib/location_profile'
include EMFramework
require 'yaml'

gps = GPS.new(-88.2269172, 40.1124997)
locations = EMFramework.run(gps, 500, 500, 1)
# open output.yaml to see location objects 
File.open("./data/output.yaml", "w") { |file| file.write(YAML.dump(locations)) }
# print out top 10 keywords for a location
locations.each{|location| pp location.l_name, location.get_keywords(10)}
