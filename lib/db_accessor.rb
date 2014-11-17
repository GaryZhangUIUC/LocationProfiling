require '.gps'
module DB


	def db_connection
		con = Mysql.new('harrier02.cs.illinois.edu', 'pawar2', 'change_me#', 'test')
	end

	def get_tweets_by_distance(gps, rad)
		db_connection()
		lag = gps.lat
		lon = gps.lon
		rs = con.query("SELECT text, userid,lat,lon,tweetid, created, ((ACOS(SIN(#{lat} * PI() / 180) * SIN(lat * PI() / 180) + COS(#{lat} * PI() / 180) * COS(lat * PI() / 180) * COS((#{lon}-lon) * PI() / 180)) * 180 / PI()) * 60 * 1.1515) AS `distance` FROM `tweets` HAVING `distance`<=#{rad} ORDER BY `distance` ASC")
		rows_to_tweets(rs)
	end

	def get_tweets_direct_mention(location_name, gps, rad)
		db_connection()
		lag = gps.lat
		lon = gps.lon
		rs = con.query("SELECT text, userid,lat,lon,tweetid, created, ((ACOS(SIN(#{lat} * PI() / 180) * SIN(lat * PI() / 180) + COS(#{lat} * PI() / 180) * COS(lat * PI() / 180) * COS((#{lon}-lon) * PI() / 180)) * 180 / PI()) * 60 * 1.1515) AS `distance` FROM `tweets` WHERE LOWER(text) RLIKE '[^A-z0-9]#{location_name}[^A-z0-9]' HAVING `distance`<=#{rad}  ORDER BY `distance` ASC")
		rows_to_tweets(rs)
	end

	def rows_to_tweets
		tweets = []
		rs.each_hash { |h| 
			gps = GPS.new(h['lon'], h['lat'])
			tweets<<Tweet.new(h['tweetid'], h['userid'], h['text'], gps, Time.at(h['created']))
		}
		tweets
	end

	def get_locations_by_distance(gps, rad)
		db_connection()
		lag = gps.lat
		lon = gps.lon
		rs = con.query("SELECT name,id,lat,lon,region ((ACOS(SIN(#{lat} * PI() / 180) * SIN(lat * PI() / 180) + COS(#{lat} * PI() / 180) * COS(lat * PI() / 180) * COS((#{lon}-lon) * PI() / 180)) * 180 / PI()) * 60 * 1.1515) AS `distance` FROM `locations` HAVING `distance`<=#{rad} ORDER BY `distance` ASC")
		locations = []
		rs.each_hash { |h| 
			gps = GPS.new(h['lon'], h['lat'])
			locations<<LocationProfile.new(h['id'], h['name'], gps)
		}
		tweets
	end
end