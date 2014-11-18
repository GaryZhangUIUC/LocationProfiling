#/usr/bin/ruby

class LocationProfile
  attr_reader :l_id
  attr_reader :l_name
  attr_reader :gps
  attr_accessor :weighted_keywords
  attr_accessor :weighted_tweets
  def initialize(l_id, l_name, gps)
    @l_id = l_id
    @l_name = l_name
    @gps = gps
    @weighted_keywords = nil
    @weighted_tweets = nil
  end

  def get_keyword_sim(target)
    sim = 0
    size = 0
    weighted_keywords.each do |keyword, weight|
      size += weight ** 2
      if target.weighted_keywords.has_key?(keyword)
        sim += weight * target.weighted_keywords[keyword]
      end
    end
    sim /= target.keyword_size * size ** 2
    sim
  end
  
  def get_distance_sim(target, alpha, beta)
    dist = gps.get_distance_from(target.gps)
    if dist < beta - 1.0 / alpha
      sim = alpha - 1.0 / (beta - dist)
    else
      sim = 0
    end
    sim
  end
end
