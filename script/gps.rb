#!/usr/bin/ruby

class GPS
  attr_reader :lon
  attr_reader :lat
  def initialize(lon, lat)
    @lon = lon
    @lat = lat
  end
  def get_distance_from(target)
    lon_diff = @lon - target.lon
    lat_diff = @lat - target.lat
    (lon_diff ** 2 + lat_diff ** 2) ** 0.5
  end
end
