package com.example.administrator.airapp;

import android.os.AsyncTask;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.widget.ProgressBar;
import android.widget.TextView;

import java.util.Map;

public class MainActivity extends AppCompatActivity {
    TextView datetime;
    ProgressBar seoulBar;
    TextView seoul;
    ProgressBar busanBar;
    TextView busan;
    ProgressBar daeguBar;
    TextView daegu;
    ProgressBar incheonBar;
    TextView incheon;
    ProgressBar gwangjuBar;
    TextView gwangju;
    ProgressBar daejeonBar;
    TextView daejeon;
    ProgressBar ulsanBar;
    TextView ulsan;
    ProgressBar gyeonggiBar;
    TextView gyeonggi;
    ProgressBar gangwonBar;
    TextView gangwon;
    ProgressBar chungbukBar;
    TextView chungbuk;
    ProgressBar chungnamBar;
    TextView chungnam;
    ProgressBar jeonbukBar;
    TextView jeonbuk;
    ProgressBar jeonnamBar;
    TextView jeonnam;
    ProgressBar gyeongbukBar;
    TextView gyeongbuk;
    ProgressBar gyeongnamBar;
    TextView gyeongnam;
    ProgressBar jejuBar;
    TextView jeju;
    ProgressBar sejongBar;
    TextView sejong;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        new MyThred().execute();
        datetime = (TextView) findViewById(R.id.datetime);
        seoul = (TextView) findViewById(R.id.seoul);
        seoulBar = (ProgressBar) findViewById(R.id.seoulBar);
        busan =(TextView) findViewById(R.id.busan);
        busanBar = (ProgressBar) findViewById(R.id.busanBar);
        daegu =(TextView) findViewById(R.id.daegu);
        daeguBar = (ProgressBar) findViewById(R.id.daeguBar);
        incheon =(TextView) findViewById(R.id.incheon);
        incheonBar = (ProgressBar) findViewById(R.id.incheonBar);
        gwangju =(TextView) findViewById(R.id.gwangju);
        gwangjuBar = (ProgressBar) findViewById(R.id.gwangjuBar);
        daejeon =(TextView) findViewById(R.id.daejeon);
        daejeonBar = (ProgressBar) findViewById(R.id.daejeonBar);
        ulsan =(TextView) findViewById(R.id.ulsan);
        ulsanBar = (ProgressBar) findViewById(R.id.ulsanBar);
        gyeonggi =(TextView) findViewById(R.id.gyeonggi);
        gyeonggiBar = (ProgressBar) findViewById(R.id.gyeonggiBar);
        gangwon =(TextView) findViewById(R.id.gangwon);
        gangwonBar = (ProgressBar) findViewById(R.id.gangwonBar);
        chungbuk =(TextView) findViewById(R.id.chungbuk);
        chungbukBar = (ProgressBar) findViewById(R.id.chungbukBar);
        chungnam =(TextView) findViewById(R.id.chungnam);
        chungnamBar = (ProgressBar) findViewById(R.id.chungnamBar);
        jeonbuk =(TextView) findViewById(R.id.jeonbuk);
        jeonbukBar = (ProgressBar) findViewById(R.id.jeonbukBar);
        gyeongbuk =(TextView) findViewById(R.id.gyeongbuk);
        gyeongbukBar = (ProgressBar) findViewById(R.id.gyeongbukBar);
        gyeongnam =(TextView) findViewById(R.id.gyeongnam);
        gyeongnamBar = (ProgressBar) findViewById(R.id.gyeongnamBar);
        jeonnam =(TextView) findViewById(R.id.jeonnam);
        jeonnamBar = (ProgressBar) findViewById(R.id.jeonnamBar);
        jeju =(TextView) findViewById(R.id.jeju);
        jejuBar = (ProgressBar) findViewById(R.id.jejuBar);
        sejong =(TextView) findViewById(R.id.sejong);
        sejongBar = (ProgressBar) findViewById(R.id.sejongBar);
    }
    class MyThred extends AsyncTask{
        @Override
        protected Object doInBackground(Object[] params){
            Map<String, String> map= AirService.getAir();
            Log.d("air","doInbackground"+map);
            return  map;
        }
        @Override
        protected  void onPostExecute(Object o){
            Log.d("air","onPostExcute"+o.toString());
            Map<String, String> map = (Map<String, String>)o;
            StringBuffer sb = new StringBuffer();
            for(String KeyName : map.keySet()) {
                sb.append(KeyName + ":" + map.get(KeyName)+"\n");
            }
            Log.d("air",sb.toString());


        }
    }
}
