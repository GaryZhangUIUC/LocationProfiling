package group.forward.locationprofiling;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONObject;

public class LocationProfile {
	public long locationId;
	public String locationName;
	public GPS gps;
	public Set<String> keywords = new HashSet<>();
	public List<Tweet> tweets = new ArrayList<>();
	public Map<Long, Double> tweetWeights = new HashMap<>();
	public LocationProfile(long locationId, String locationName, GPS gps) {
		this.locationId = locationId;
		this.locationName = locationName;
		this.gps = gps;
	}
	public JSONObject toJSON() {
		JSONObject jo = new JSONObject();
		jo.put("locationId", this.locationId);
		jo.put("locationName", this.locationName);
		jo.put("GPS", gps.toJSON());
		jo.put("keywords", this.keywords);
		JSONArray tweetJa = new JSONArray();
		for (Tweet tweet : tweets) {
			tweetJa.put(tweet.toJSON());
		}
		jo.put("tweets", tweetJa);
		jo.put("tweetWeights", this.tweetWeights);
		return jo;
	}
}
