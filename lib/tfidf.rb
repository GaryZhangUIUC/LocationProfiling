require_relative './tweet_words'
include TweetWords

class TfIdf
	attr_accessor :tf
	attr_accessor :idf
	attr_accessor :tf_idf

	# locations = [location_profile...]
	def initialize(locations)
		@idf = {}			# {word:idf}
		@df = {}			# {word:df}
		@tf = {}			# {l_id=>{word=>tf, ...}}
		@tf_idf = {}	# {l_id=>{word=>tf*idf, ...}}
		@locations_count = locations.length
		calc_tfidf(locations)
	end
	
	private
	def calc_tfidf(locations, threshold = 0)
		locations.each do |location|
			tweets_count = location.weighted_tweets.length
			l_id = location.l_id
			@tf[l_id] = {}
			l_tf = @tf[l_id]
			location_words = []
			location.weighted_tweets.each do |tweet|
				tweet_words = []
				TweetWords.clean_up(tweet[0].text).each do |word|
					# if this word already appeared in the tweet, do not count again
					unless tweet_words.include?(word)
						l_tf.has_key?(word) ? l_tf[word]+=tweet[1] : l_tf[word] = tweet[1]
						tweet_words<<word
					end
					unless location_words.include?(word)
						@df.has_key?(word) ? @df[word]+=1 : @df[word] = 1
						location_words<<word
					end
				end
			end
			l_tf.each do |word, tf|
				l_tf[word] = 0 if tf<=2 #(tf*1.0)/tweets_count < threshold
			end
		end
		gen_idf()
		gen_tfidf()
	end

	def gen_idf
		@df.each do |word, df|
			@idf[word] = 1 + Math.log(@locations_count / (df + 1.0))
		end
	end

	def gen_tfidf
		@tf.each do |l_id, tfs|
			@tf_idf[l_id] = {}
			l_tf_idf = @tf_idf[l_id]
			tfs.each do |word, tf|
				l_tf_idf[word] = tf*@idf[word]
			end
		end
	end

	def method_name
		
	end
end