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
    if weighted_keywords.length == 0 || target.weighted_keywords.length == 0
      return 0.0
    end
    sim = 0
    size = 0
    weighted_keywords.each do |keyword, weight|
      size += weight ** 2
      if target.weighted_keywords.has_key?(keyword)
        sim += weight * target.weighted_keywords[keyword]
      end
    end
    sim /= target.keyword_size * size ** 0.5
    sim
  end
  
  def get_distance_sim(target, dist_limit, sim_limit)
    dist = gps.get_distance_from(target.gps)
    if dist < dist_limit
      sim = sim_limit * (1 - (dist / dist_limit) ** 2) ** 0.5
    else
      sim = 0
    end
    sim
  end

  # return top_n keywords for location
  def get_keywords(top_n)
    @weighted_keywords.sort_by {|_key, value| value}.reverse[1..top_n]
  end
end
