#!/usr/bin/ruby

class Tweet
  attr_reader :t_id
  attr_reader :user
  attr_reader :created_at
  attr_reader :gps
  attr_reader :text
  def initialize(t_id, user, created_at, gps, text)
    @t_id = t_id
    @user = user
    @created_at = created_at
    @gps = gps
    @text = text
  end
end
