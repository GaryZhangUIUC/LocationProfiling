#!/usr/bin/ruby

class GPS
  attr_reader :longitude
  attr_reader :latitude
  def initialize(longitude, latitude)
    @longitude = longitude
    @latitude = latitude
  end
  def get_distance_from(target)
    lo_diff = @longitude - target.longitude
    la_diff = @latitude - target.latitude
    (lo_diff ** 2 + la_diff ** 2) ** 0.5
  end
end

# Now using above class to create objects
object1 = GPS.new(1, 1)
object2 = GPS.new(2, 2)
dist = object1.get_distance_from(object2)
puts dist
