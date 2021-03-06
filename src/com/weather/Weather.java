package com.weather;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.key.ApiKey;

public class Weather {
	String curCondition;
	String curPlace;
	String curTemp;
	String conditionDescription; //구름조금;
	String curIcon;
	
    public WeatherData getWeather(String lat, String lon){
    	WeatherData nowWeather = null;
        try{
        	
        	//서울시청의 위도와 경도
            
            ApiKey Apikey = new ApiKey();
            String APIKEY = Apikey.getOpenWeather();
            
            //OpenAPI call하는 URL
            String urlstr = "https://api.openweathermap.org/data/2.5/weather?"
                        + "lat="+lat+"&lon="+lon
                        +"&lang=kr&appid=" 
                        + APIKEY
                        +"&units=metric";
            
            //url data 가져옴
            URL url = new URL(urlstr);
        
            BufferedReader bf;
            String line;
            String result="";

            //날씨 정보를 받아온다.
            bf = new BufferedReader(new InputStreamReader(url.openStream()));

            //버퍼에 있는 정보를 문자열로 변환.
            while((line=bf.readLine())!=null){
                result=result.concat(line);
                System.out.println(line);
            }

            //문자열을 JSON으로 파싱
            JSONParser jsonParser = new JSONParser();
            JSONObject jsonObj = (JSONObject) jsonParser.parse(result);
            System.out.println(jsonObj);
            
            //지역 출력
            curPlace = (String)jsonObj.get("name");

            //날씨 출력
            JSONArray weatherArray = (JSONArray) jsonObj.get("weather");
            JSONObject obj = (JSONObject) weatherArray.get(0);
            curCondition = (String)obj.get("main");
            
            //날씨 설명
            conditionDescription = (String)obj.get("description");
            
            //날씨 아이콘
            curIcon = (String)obj.get("icon");
            
            //온도 출력
            JSONObject mainArray = (JSONObject) jsonObj.get("main");
            curTemp = String.valueOf(mainArray.get("temp"));
            
            nowWeather = new WeatherData();
            nowWeather.setPlace(curPlace);
            nowWeather.setTemp(curTemp);
            nowWeather.setWeatherCondition(curCondition);
            nowWeather.setDesc(conditionDescription);
            nowWeather.setIcon(curIcon);
            
            System.out.println("날씨 구하기 완료!");
            System.out.println(nowWeather);
            
            bf.close();
        }catch(Exception e){
            System.out.println(e.getMessage());
        }
        
        return nowWeather;
    }
}
