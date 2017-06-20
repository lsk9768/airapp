package com.example.administrator.airapp;

import android.os.AsyncTask;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.widget.ProgressBar;
import android.widget.TextView;

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
            Air air = AirService.getAir();
            Log.d("air",air.toString());
            return  air;
        }
        @Override
        protected  void onPostExecute(Object o){
            Log.d("air","onPostExecute:"+o.toString());
            Air air = (Air)o;
            datetime.setText(air.getDataTime());
            seoul.setText("서울 :"+air.getSeoul());
            seoulBar.setProgress(air.getSeoul());
            busan.setText("부산 :"+air.getBusan());
            busanBar.setProgress(air.getBusan());
            daegu.setText("대구 :"+air.getDaegu());
            daeguBar.setProgress(air.getDaegu());
            incheon.setText("인천 :"+air.getIncheon());
            incheonBar.setProgress(air.getIncheon());
            gwangju.setText("광주 :"+air.getGwangju());
            gwangjuBar.setProgress(air.getGwangju());
            daejeon.setText("대전 :"+air.getDaejeon());
            daejeonBar.setProgress(air.getDaejeon());
            ulsan.setText("울산 :"+air.getUlsan());
            ulsanBar.setProgress(air.getUlsan());
            gyeonggi.setText("경기 :"+air.getGyeonggi());
            gyeonggiBar.setProgress(air.getGyeonggi());
            gangwon.setText("강원 :"+air.getGangwon());
            gangwonBar.setProgress(air.getGangwon());
            chungbuk.setText("충북 :"+air.getChungbuk());
            chungbukBar.setProgress(air.getChungbuk());
            chungnam.setText("충남 :"+air.getChungnam());
            chungnamBar.setProgress(air.getChungnam());
            jeonbuk.setText("전북 :"+air.getJeonbuk());
            jeonbukBar.setProgress(air.getJeonbuk());
            jeonnam.setText("충북 :"+air.getJeonnam());
            jeonnamBar.setProgress(air.getJeonnam());
            gyeongbuk.setText("경북 :"+air.getGyeongbuk());
            gyeongbukBar.setProgress(air.getGyeongbuk());
            gyeongnam.setText("경남 :"+air.getGyeongnam());
            gyeongnamBar.setProgress(air.getGyeongnam());
            jeju.setText("제주 :"+air.getJeju());
            jejuBar.setProgress(air.getJeju());
            sejong.setText("세종 :"+air.getSejong());
            sejongBar.setProgress(air.getSejong());

        }
    }
}
