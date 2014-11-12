package group.forward.locationprofiling;

import java.util.HashSet;
import java.util.Set;

import org.json.JSONObject;


public class Tweet {
	public long tweetId;
	public String content;
	public GPS gps;
	public Set<String> keywords = new HashSet<>();
	public Tweet(long tweetId, String content, GPS gps) {
		this.tweetId = tweetId;
		this.content = content;
		this.gps = gps;
	}
	public JSONObject toJSON() {
		JSONObject jo = new JSONObject();
		jo.put("tweetId", this.tweetId);
		jo.put("content", this.content);
		jo.put("GPS", this.gps.toJSON());
		jo.put("keywords", this.keywords);
		return jo;
	}
}
