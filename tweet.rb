#!/usr/bin/ruby
require "tweet_words"
class Tweet
  attr_reader :t_id
  attr_reader :u_id
  attr_reader :created_at
  attr_reader :gps
  attr_reader :text
  attr_reader :weighted_keywords
  attr_reader :keyword_size
  def initialize(t_id, u_id, text, gps, created_at)
    @t_id = t_id
    @u_id = u_id
    @created_at = created_at
    @gps = gps
    @text = text
    @weighted_keywords = nil
    @keyword_size = nil
    generate_keywords()
  end
  def generate_keywords()
    keywords = TweetWords.clean_up(@text)
    @weighted_keywords = {}
    @keyword_size = 0
    keywords.each do |keyword|
      if @weighted_keywords.has_key?(keyword)
        @keyword_size += 2 * @weighted_keywords[keyword] + 1
        @weighted_keywords[keyword] += 1
      else
        @keyword_size += 1
        @weighted_keywords[keyword] = 1
      end
    end
    @keyword_size **= 0.5
  end
end
