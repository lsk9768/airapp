package com.example.administrator.airapp;

import android.os.AsyncTask;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;

import com.github.mikephil.charting.charts.BarChart;
import com.github.mikephil.charting.data.BarData;
import com.github.mikephil.charting.data.BarDataSet;
import com.github.mikephil.charting.data.BarEntry;


import java.util.ArrayList;
import java.util.Map;

public class MainActivity extends AppCompatActivity {
    BarChart barChart;
    ArrayList<String> labels;
    String dataTime;
    ArrayList<BarEntry> entries;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        barChart = (BarChart) findViewById(R.id.barChart);
        new MyThred().execute();

    }
    class MyThred extends AsyncTask {
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
            dataTime = map.get("dataTime");
            map.remove("dataTime");
            labels = new ArrayList<String>();
            entries = new ArrayList<BarEntry>();
            int index = 0;

            for(String KeyName : map.keySet()) {
                labels.add(KeyName);
                entries.add(new BarEntry(index++,Float.parseFloat(map.get(KeyName))));

            }
            Log.d("air",labels.toString());

            BarDataSet barDataSet = new BarDataSet(entries, "Korea air");
            barDataSet.setDrawValues(false);

            BarData barData = new BarData(barDataSet);

            barChart.setData(barData);
            barChart.invalidate();
        }
    }
}
