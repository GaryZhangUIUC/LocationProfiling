#!/usr/bin/ruby
require_relative "./db_accessor"
require_relative './tfidf'
require_relative './tweet'
require_relative './gps'
require_relative './location_profile'
include DB
require 'pp'

module EMFramework
  DIST_ALPHA = 1.0
  DIST_BETA = 1000.0
  DIST_WEIGHT = 0.5
  KEYWORD_WEIGHT = 0.5
  def get_locations(center, l_radius)
    get_locations_by_distance(center, l_radius)
  end
  def get_tweets(center, t_radius)
    get_tweets_by_distance(center, t_radius)
  end

  def init_lcoations(center, t_radius, l_radius)
    locations = get_locations(center, l_radius)
    locations.each do |location|
      tweets = get_tweets(center, t_radius)
      location.weighted_tweets = tweets.map { |tweet| [tweet, 1] }
    end
    update_location(locations)
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
    tfidf = TfIdf.new(loc_set)
    loc_set.each do |location|
      location.weighted_keywords = tfidf.tf_idf[location.l_id]
    end
    loc_set
  end
  def run(center, l_radius, t_radius, num_iter)
    locations = init_lcoations(center, t_radius, l_radius)
    tweets = get_tweets(center, t_radius)
    locations_count = locations.length
    tweets_count = tweets.length
    p "#{locations_count} locations, #{tweets_count} tweets"
    for iter_num in 1..num_iter
      p "Iteration #{iter_num}"
      locations = bind_tweets(tweets, locations)
      p "#{iter_num}.bine_tweets"
      locations = update_location(locations)
      p "#{iter_num}.update_location"
    end
    locations
  end
end
