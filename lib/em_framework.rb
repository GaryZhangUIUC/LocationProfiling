#!/usr/bin/ruby
require_relative "./db_accessor"
require_relative './tfidf'
require_relative './tweet'
require_relative './gps'
require_relative './location_profile'
require_relative './stat'
include DB
include Stat
require 'pp'

module EMFramework
  def get_locations(center, l_radius)
    get_locations_by_distance(center, l_radius)
  end

  def get_tweets(center, t_radius)
    get_tweets_by_distance(center, t_radius)
  end

  def init_lcoations(locations, init_t_radius)
    locations.each do |location|
      tweets = get_tweets(location.gps, init_t_radius)
      location.weighted_tweets = tweets.map { |tweet| [tweet, 1] }
    end
    update_location(locations)
  end
 
  def bind_tweets(tweets, loc_set)
    loc_set.each do |location|
      location.weighted_tweets = []
    end
    tweets.each do |tweet|
      max_sim = 0
      max_loc = nil
      loc_set.each do |location|
        keyword_sim = location.get_keyword_sim(tweet)
        dist_weight = 0.5
        if location.l_id != -1
          dist_weight = location.get_dist_weight(tweet, 40)
        end
        # when multiple feature, recommend this way to consider each feature
        # then put top 1 of each feature into a candidate list
        # then push to the list with certain prob
        sim = keyword_sim * dist_weight
        if sim > max_sim
          max_sim = sim
          max_loc = location
        end
      end
      if max_loc != nil
        max_loc.weighted_tweets.push([tweet, 1.0])
      else
        loc_set.last.weighted_tweets.push([tweet, 1.0])
      end
    end
    loc_set
  end

  def update_location(loc_set)
    tfidf = TfIdf.new(loc_set)
    loc_set.each do |location|
      location.weighted_keywords = tfidf.tf_idf[location.l_id]
    end
    loc_set
  end

  def run(center, l_radius, t_radius, num_iter)
    locations = get_locations(center, l_radius)
    locations = init_lcoations(locations, 100)
    tweets = get_tweets(center, t_radius)
    locations_count = locations.length
    tweets_count = tweets.length
    p "#{locations_count} locations, #{tweets_count} tweets"
    locations << LocationProfile.new(-1, "Background Location Profile", nil)
    for iter_num in 1..num_iter
      p "Iteration #{iter_num}"
      p "#{iter_num}.bind_tweets"
      # locations = bind_tweets(tweets, locations)
      p "#{iter_num}.update_locations"
      locations = update_location(locations)
    end
    locations
  end
end
