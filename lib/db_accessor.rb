module DB

	def db_connection
		con = Mysql.new('harrier02.cs.illinois.edu', 'pawar2', 'change_me#', 'test')
	end

	def get_tweets_by_distance(gps, rad)
		db_connection()
		lag = gps.lat
		lon = gps.lon
		rs = con.query("SELECT text, userid,lat,lon,tweetid, ((ACOS(SIN(#{lat} * PI() / 180) * SIN(lat * PI() / 180) + COS(#{lat} * PI() / 180) * COS(lat * PI() / 180) * COS((#{lon}-lon) * PI() / 180)) * 180 / PI()) * 60 * 1.1515) AS `distance` FROM `tweets` HAVING `distance`<=#{rad} ORDER BY `distance` ASC")
		tweets = []
		rs.each_hash { |h| 
			tweets<<Tweet.new

			{'text'=>h['text'].force_encoding("utf-8"), 'lat'=>h['lat'],'lon'=>h['lon']}
		}
	end

	def get_tweets_init(gps, rad)
		
	end

	def get_locations_by_distance(gps, rad)
		
	end
end