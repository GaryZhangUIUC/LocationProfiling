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
	def calc_tfidf(locations)
		locations.each do |location|
			l_tf = @tf[l_id]
			l_id = location.l_id
			l_tf = {}
			location_words = []
			location.tweets.each do |tweet|
				tweet_words = []
				TweetWords.clean_up(tweet[0].text).each do |word|
					# if this word already appeared in the tweet, do not count again
					unless tweet_words.include?(word)
						l_tf.has_key?(word) ? l_tf[word]+=tweet[1] : l_tf[word] = tweet[1]
						tweet_words<<word
					end
					unless location_words.include?(word)
						@df.has_key?(word) ? @tf[word]+=1 : @tf[word] = 1
						location_words<<word
					end
				end
			end
		end
		gen_idf()
		gen_tfidf()
	end

	def gen_idf
		@df.each do |word, df|
			@idf[word] = 1 + log(@locations_count / (df + 1.0))
		end
	end

	def gen_tfidf
		@tf.each do |l_id, tfs|
			l_tf_idf = @tf_idf[l_id]
			tfs.each do |word, tf|
				l_tf_idf[word] = tf*@df[word]
			end
		end
	end


end