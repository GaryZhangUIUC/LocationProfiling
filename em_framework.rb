#!/usr/bin/ruby

module EMFramework
  DIST_ALPHA = 1.0
  DIST_BETA = 1000.0
  DIST_WEIGHT = 0.5
  KEYWORD_WEIGHT = 0.5
  def get_locations(center, l_radius)
  end
  def get_tweets(center, t_radius)
  end
  def bind_tweets(tweets, loc_set, dist_weight=DIST_WEIGHT, keyword_weight=KEYWORD_WEIGHT)
    loc_set.each do |location|
      location.weighted_tweets = []
    end
    tweets.each do |tweet|
      max_sim = 0
      max_loc = nil
      loc_set.each do |location|
        keyword_sim = location.get_keyword_sim(tweet)
        dist_sim = location.get_distance_sim(tweet, DIST_ALPHA, DIST_BETA)
        sim = keyword_sim * keyword_weight + dist_sim * dist_weight
        if sim > max_sim
          max_sim = sim
          max_loc = location
        end
      end
      if max_loc != nil
        max_loc.weighted_tweets.push([tweet, 1.0])
      end
    end
    loc_set
  end
  def update_location(loc_set)
  end
  def run(center, l_radius, t_radius, num_iter)
    locations = get_locations(center, l_radius)
    tweets = get_tweets(center, t_radius)
    for iter_num in 1..num_iter
      locations = bind_tweets(tweets, locations)
      locations = update_location(locations)
    end
    locations
  end
end
