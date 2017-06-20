package com.example.administrator.airapp;
import android.util.Log;

import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;
import org.xmlpull.v1.XmlPullParserFactory;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

/**
 * Created by ksmart-t201 on 2017-06-20.
 */

public class AirService {
    public static Air getAir() {
        Air air = new Air();
        String str = getAirList();
        // list -> air : xml 파싱
        try {
            XmlPullParserFactory factory = XmlPullParserFactory.newInstance();
            XmlPullParser parse = factory.newPullParser();
            parse.setInput(new StringReader(str));

            int type = parse.getEventType();
            boolean flag = false;
            String local = "";
            while(type != XmlPullParser.END_DOCUMENT){
                switch(type){
                    case XmlPullParser.START_TAG:
                        local = parse.getName();
                        if(local.equals("dataTime")
                                ||local.equals("seoul")
                                || local.equals("busan")
                                || local.equals("daegu")
                                || local.equals("incheon")
                                || local.equals("gwangju")
                                || local.equals("daejeon")
                                || local.equals("ulsan")
                                || local.equals("gyeonggi")
                                || local.equals("gangwon")
                                || local.equals("chungbuk")
                                || local.equals("chungnam")
                                || local.equals("jeonbuk")
                                || local.equals("jeonnam")
                                || local.equals("gyeongbuk")
                                || local.equals("gyeongnam")
                                || local.equals("jeju")
                                || local.equals("sejong")){
                            flag = true;
                        }
                        break;
                    case XmlPullParser.TEXT:
                        if(flag) {
                            if(local.equals("dataTime")) {
                                air.setDataTime(parse.getText());
                            }else if(local.equals("seoul")) {
                                air.setSeoul(Integer.parseInt(parse.getText()));
                            } else if(local.equals("busan")){
                                air.setBusan(Integer.parseInt(parse.getText()));
                            } else if(local.equals("daegu")){
                                air.setDaegu(Integer.parseInt(parse.getText()));
                            } else if(local.equals("incheon")){
                                air.setIncheon(Integer.parseInt(parse.getText()));
                            } else if(local.equals("gwangju")){
                                air.setGwangju(Integer.parseInt(parse.getText()));
                            } else if(local.equals("daejeon")){
                                air.setDaejeon(Integer.parseInt(parse.getText()));
                            } else if(local.equals("ulsan")){
                                air.setUlsan(Integer.parseInt(parse.getText()));
                            } else if(local.equals("gyeonggi")){
                                air.setGyeonggi(Integer.parseInt(parse.getText()));
                            } else if(local.equals("gangwon")){
                                air.setGangwon(Integer.parseInt(parse.getText()));
                            } else if(local.equals("chungbuk")){
                                air.setChungbuk(Integer.parseInt(parse.getText()));
                            } else if(local.equals("chungnam")){
                                air.setChungnam(Integer.parseInt(parse.getText()));
                            } else if(local.equals("jeonbuk")){
                                air.setJeonbuk(Integer.parseInt(parse.getText()));
                            } else if(local.equals("jeonnam")){
                                air.setJeonnam(Integer.parseInt(parse.getText()));
                            } else if(local.equals("gyeongbuk")){
                                air.setGyeongbuk(Integer.parseInt(parse.getText()));
                            } else if(local.equals("gyeongnam")){
                                air.setGyeongnam(Integer.parseInt(parse.getText()));
                            } else if(local.equals("jeju")){
                                air.setJeju(Integer.parseInt(parse.getText()));
                            } else if(local.equals("sejong")){
                                air.setSejong(Integer.parseInt(parse.getText()));
                            }
                            flag = false;
                        }
                        break;
                    default:
                        break;
                }
                type = parse.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return air;
    }

    private static String getAirList() {
        HttpURLConnection conn = null;
        BufferedReader rd = null;
        StringBuilder sb = null;
        try {
            Log.v("air","try...");
            StringBuilder urlBuilder = new StringBuilder("http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureLIst"); /*URL*/
            urlBuilder.append("?" + URLEncoder.encode("ServiceKey", "UTF-8") + "=UWglQGsgXb5QQxiNRskg3WBTP7dtrBkrMJbiI1IN61B67chcMfziPQ0JP9yohyVYaKosTK2raaYGnzuB7ltiyg%3D%3D"); /*Service Key*/
            urlBuilder.append("&" + URLEncoder.encode("itemCode", "UTF-8") + "=" + URLEncoder.encode("PM10", "UTF-8")); /*파라미터설명*/
            urlBuilder.append("&" + URLEncoder.encode("dataGubun", "UTF-8") + "=" + URLEncoder.encode("HOUR", "UTF-8")); /*파라미터설명*/
            urlBuilder.append("&" + URLEncoder.encode("pageNo", "UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*파라미터설명*/
            urlBuilder.append("&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*파라미터설명*/

            URL url = new URL(urlBuilder.toString());
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Content-type", "application/json");
            Log.v("air","Response code: " + conn.getResponseCode());
            if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
                Log.v("air","if...");
                rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            } else {
                rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
            }
            sb = new StringBuilder();
            String line;
            while ((line = rd.readLine()) != null) {
                sb.append(line);
            }
            //    System.out.println(sb.toString());
        } catch (IOException e) {
            Log.v("air","catch...");
            e.printStackTrace();
        } finally {
            Log.v("air","finally...");
            try {
                rd.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            conn.disconnect();
        }
        return sb.toString();
    }
}