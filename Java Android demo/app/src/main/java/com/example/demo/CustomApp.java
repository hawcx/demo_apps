package com.example.demo;

import android.app.Application;

import com.example.demo.helpers.Constants;
import com.hawcx.HawcxInitializer;

public class CustomApp extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        HawcxInitializer.getInstance().init(getApplicationContext(), Constants.API_KEY);
    }
}