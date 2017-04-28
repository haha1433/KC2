package kr.co.koscom.marketdata.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;

public class urlCallController {

	String apiKey = "l7xx2ae2f596a0fc42fb8ec1269514eafe18"; // 발급받은 키값
	URL url = null;
    URLConnection urlConnection = null;
    String marketCode = "kospi";
    
    public String callUrl(String link) throws IOException{
    	StringBuilder urlBuilder = new StringBuilder(link);
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("apikey", apiKey);
        System.out.println("Response code: " + conn.getResponseCode()); // 디버깅
        BufferedReader rd;
        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
        }
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();
        return sb.toString();
    }
}
