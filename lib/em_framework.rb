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
  DISTSIM_DIST_LIMIT = 1000.0
  DISTSIM_SIM_LIMIT = 1.0
  DIST_WEIGHT = 0.05
  KEYWORD_WEIGHT = 1
  def get_locations(center, l_radius)
    locations = get_locations_by_distance(center, l_radius)
    locations
  end
  def get_tweets(center, t_radius)
    tweets = get_tweets_by_distance(center, t_radius)
    tweets
  end

  def init_lcoations(center, t_radius, l_radius)
    locations = get_locations(center, l_radius)
    locations.each do |location|
      tweets = get_tweets(center, t_radius)
      location.weighted_tweets = tweets.map { |tweet| [tweet, 1] }
    end
    update_location(locations)
  end
  
  def bind_tweets(dist_sim_array, keyword_sim_array, tweets, loc_set, dist_weight=DIST_WEIGHT, keyword_weight=KEYWORD_WEIGHT)
    loc_set.each do |location|
      location.weighted_tweets = []
    end
    tweets.each do |tweet|
      max_sim = 0
      max_loc = nil
      loc_set.each do |location|
        keyword_sim = location.get_keyword_sim(tweet)
        dist_sim = location.get_distance_sim(tweet, DISTSIM_DIST_LIMIT, DISTSIM_SIM_LIMIT)
        dist_sim_array.push(dist_sim * dist_weight)
        keyword_sim_array.push(keyword_sim * keyword_weight)
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
    dist_sim_array = []
    keyword_sim_array = []
    locations = init_lcoations(center, t_radius, l_radius)
    tweets = get_tweets(center, t_radius)
    for iter_num in 1..num_iter
      locations = bind_tweets(dist_sim_array, keyword_sim_array, tweets, locations)
      locations = update_location(locations)
    end
    dist_mean = Stat.mean(dist_sim_array)
    dist_sd = Stat.standard_deviation(dist_sim_array)
    kw_mean = Stat.mean(keyword_sim_array)
    kw_sd = Stat.standard_deviation(keyword_sim_array)
    puts "dist"
    puts dist_mean.to_s + " " + dist_sd.to_s
    puts "keyword"
    puts kw_mean.to_s + " " + kw_sd.to_s
    locations
  end
end
