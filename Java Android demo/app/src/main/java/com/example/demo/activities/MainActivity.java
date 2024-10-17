package com.example.demo.activities;

import static com.example.demo.helpers.Constants.KEY_IS_FIRST_RUN;
import static com.example.demo.helpers.Constants.KEY_IS_LOGGED_IN;
import static com.example.demo.helpers.Constants.PREFS_NAME;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;

import com.example.demo.helpers.Constants;
import com.hawcx.HawcxInitializer;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SharedPreferences preferences = getSharedPreferences(PREFS_NAME, MODE_PRIVATE);
        boolean isLoggedIn = preferences.getBoolean(KEY_IS_LOGGED_IN, false);

        if (isLoggedIn) {
            startActivity(new Intent(this, HomeActivity.class));
        } else {
            startActivity(new Intent(this, LoginActivity.class));
        }

        finish();
    }

    public static void setLoggedInStatus(SharedPreferences preferences, boolean status) {
        SharedPreferences.Editor editor = preferences.edit();
        editor.putBoolean(KEY_IS_LOGGED_IN, status);
        editor.apply();
    }


}
