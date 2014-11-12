package group.forward.locationprofiling;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class EMFramework {
	private List<Tweet> tweets;
	private Map<Long, LocationProfile> locations;

	private int numIterations = 100;
	
	private double initializationClosenessThreshold = Math.exp(-0.001);
	
	private double distanceWeight = 0.5;
	private double keywordSimilarityWeight = 0.5;
	
	public EMFramework(GPS center, double r1, double r2) {
		locations = retrieveLocations(center, r1);
		tweets = retrieveTweets(center, r2);
	}
	private Map<Long, LocationProfile> retrieveLocations(GPS center, double r1) {
		// get locations using center and radius
		return new HashMap<Long, LocationProfile>();
	}
	private List<Tweet> retrieveTweets(GPS center, double r2) {
		// get tweets using center and radius
		return new ArrayList<Tweet>();
	}
	public void run() {
		initializeLocations();
		updateLocations();
		for (int iter = 0; iter < numIterations; iter++) {
			bindTweets();
			updateLocations();
		}
		saveToJSON("result.json");
	}
	private void initializeLocations() {
		for (Tweet tweet : tweets) {
			List<Long> nearestLocations = null;
			double maxCloseness = -1;
			for (LocationProfile lp : locations.values()) {
				double dist = tweet.gps.getDistanceFrom(lp.gps);
				double closeness = Math.exp(-dist);
				if (closeness > maxCloseness) {
					maxCloseness = closeness;
					nearestLocations = new ArrayList<>();
					nearestLocations.add(lp.locationId);
				} else if (closeness == maxCloseness) {
					nearestLocations.add(lp.locationId);
				}
			}
			if (maxCloseness < initializationClosenessThreshold) {
				continue;
			}
			for (long locationId : nearestLocations) {
				locations.get(locationId).tweets.add(tweet);
				locations.get(locationId).tweetWeights.put(tweet.tweetId, 
						(double) 1 / nearestLocations.size());
			}
		}
	}
	private void bindTweets() {
		for (LocationProfile lp : locations.values()) {
			lp.tweets = new ArrayList<>();
			lp.tweetWeights = new HashMap<>();
		}
		for (Tweet tweet : tweets) {
			List<Long> closestLocations = null;
			double maxSim = -1;
			for (LocationProfile lp : locations.values()) {
				double dist = tweet.gps.getDistanceFrom(lp.gps);
				double keywordSim = getKeywordSimilarity(tweet.keywords, lp.keywords);
				double sim = distanceWeight * Math.exp(-dist) +
						keywordSimilarityWeight * keywordSim;
				if (sim > maxSim) {
					maxSim = sim;
					closestLocations = new ArrayList<>();
					closestLocations.add(lp.locationId);
				} else if (sim == maxSim) {
					closestLocations.add(lp.locationId);
				}
			}
			for (long locationId : closestLocations) {
				locations.get(locationId).tweets.add(tweet);
				locations.get(locationId).tweetWeights.put(tweet.tweetId, 
						(double) 1 / closestLocations.size());
			}
		}
	}
	private double getKeywordSimilarity(Set<String> keywords1,
			Set<String> keywords2) {
		int cooccur = 0;
		for (String keyword : keywords1) {
			if (keywords2.contains(keyword)) {
				cooccur += 1;
			}
		}
		return (double) cooccur / (Math.sqrt(keywords1.size() * keywords2.size()));
	}
	private void updateLocations() {
		// update the keywords of locations using the current location profiles
	}
	private void saveToJSON(String fileName) {
		try {
			JSONArray ja = new JSONArray();
			for (LocationProfile lp : locations.values()) {
				JSONObject jo = lp.toJSON();
				ja.put(jo);
			}
			Writer writer = new PrintWriter(fileName);
			writer.write(ja.toString(2));
			writer.close();
		} catch (JSONException | IOException e) {
			e.printStackTrace();
		}
	}
	public static void main(String[] args) {
		HashMap<Long, Double> m = new HashMap<>();
		m.put(123L, 0.1);
		m.put(321L, 0.01);
		JSONObject jo = new JSONObject();
		jo.put("map", m);
		System.out.println(jo.toString());
	}
}
