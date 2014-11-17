module TweetWords
	
	def clean_up(str)
		stop_words = []
		f = File.open('../data/stopWords.txt', 'r')
		f.each_line do |line|
		  stop_words<<line.strip
		end	
	  array=str.downcase.split(' ').delete_if{|s|s.start_with?('@')}.map{|s| s.gsub(/[^[:alnum:]]/, '')} #remove punctuations
	  array.delete_if{|s| s==''||s.start_with?('http')||s.start_with?('@')||s=~ /\A[-+]?[0-9]*\.?[0-9]+\Z/||stop_words.include?(s)||s.length<3 }
	end

end