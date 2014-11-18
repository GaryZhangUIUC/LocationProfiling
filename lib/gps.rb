#!/usr/bin/ruby

class GPS
  attr_reader :lon
  attr_reader :lat
  PI = 3.1415926
  def initialize(lon, lat)
    @lon = lon.to_f
    @lat = lat.to_f
  end
  def get_distance_from(target)
    lat1 = lat
    lon1 = lon
    lat2 = target.lat
    lon2 = target.lon
    
    lat_diff = (lat1 - lat2) * PI / 180.0
    lon_diff = (lon1 - lon2) * PI / 180.0
    lat_sin = Math.sin(lat_diff / 2.0) ** 2
    lon_sin = Math.sin(lon_diff / 2.0) ** 2
    first = Math.sqrt(lat_sin + Math.cos(lat1 * PI / 180.0) * Math.cos(lat2 * PI / 180.0) * lon_sin)
    result = Math.asin(first) * 2 * 6378137.0
    result
  end
end
