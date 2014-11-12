package group.forward.locationprofiling;

import org.json.JSONObject;


public class GPS {
	public double longitude;
	public double latitude;
	public GPS(double longitude, double latitude) {
		this.latitude = latitude;
		this.longitude = longitude;
	}
	public double getDistanceFrom(GPS target) {
		double diffLongitude = this.longitude - target.longitude;
		double diffLatitude = this.latitude - target.latitude;
		return Math.sqrt(Math.pow(diffLongitude, 2) + Math.pow(diffLatitude, 2));
	}
	public JSONObject toJSON() {
		JSONObject jo = new JSONObject();
		jo.put("longitude", this.longitude);
		jo.put("latitude", this.latitude);
		return jo;
	}
}
