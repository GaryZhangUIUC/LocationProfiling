#/usr/bin/ruby

class LocationProfile
  attr_reader :l_id
  attr_reader :l_name
  attr_reader :gps
  attr_accessor :weighted_keywords
  attr_accessor :weighted_tweets
  def initialize(l_id, l_name, gps, )
    @l_id = l_id
    @l_name = l_name
    @gps = gps
    @weighted_keywords = nil
    @weighted_tweets = nil
  end
  def get_keyword_sim(target)
    sim = 0
    weighted_keywords.each do |keyword, weight|
      if target.weighted_keywords.has_key?(keyword)
        sim += weight * target.weighted_keywords[keyword]
      end
    end
  end
  def get_distance_sim
  
  end
end
