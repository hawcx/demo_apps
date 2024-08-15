package com.example.demo.viewmodels;

import android.app.Application;
import android.content.Context;

import androidx.annotation.NonNull;
import androidx.lifecycle.AndroidViewModel;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;

import com.hawcx.utils.EncryptedSharedPreferencesUtil;

import com.example.demo.fragments.TimeLogs;

import org.json.JSONObject;

public class MainViewModel extends AndroidViewModel {
    private final MutableLiveData<String> emailId = new MutableLiveData<>();
    private final MutableLiveData<Boolean> timeLogShow = new MutableLiveData<>(false);
    private final MutableLiveData<TimeLogs> timeLogs = new MutableLiveData<>();

    public MainViewModel(@NonNull Application application) {
        super(application);
//FIXME: If the username is the last logged in user -> flow change
//        loadData(application);
    }

    public LiveData<String> getEmailId() {
        return emailId;
    }

    public LiveData<Boolean> getTimeLogShow() {
        return timeLogShow;
    }

    public LiveData<TimeLogs> getTimeLogs() {
        return timeLogs;
    }

    public void showTimeLogs() {
        timeLogShow.setValue(true);
    }

    public void hideTimeLogs() {
        timeLogShow.setValue(false);
    }

    public void loadData(Context context, String email) {
        // FIXME: Related to the L24 fixme
//        String email = EncryptedSharedPreferencesUtil.getString(context, "email");
        emailId.setValue(email);

        String timeLogsJson = EncryptedSharedPreferencesUtil.getString(context, "timelog");
        long totalTime = EncryptedSharedPreferencesUtil.getLong(context, "total");

        if (timeLogsJson != null) {
            try {
                JSONObject jsonObject = new JSONObject(timeLogsJson);
                TimeLogs logs;

                if (jsonObject.has("cipherTime")) {
                    // Sign-in scenario
                    long cipherTime = jsonObject.getLong("cipherTime");
                    long sendCipherTime = jsonObject.getLong("sendchipherTime");
                    long regenM2Time = jsonObject.getLong("regenM2Time");
                    long verifyCipherTime = jsonObject.getLong("verifyCipherTime");
                    long storeKeyTime = jsonObject.getLong("storekeyTime");

                    logs = new TimeLogs(cipherTime, sendCipherTime, regenM2Time, verifyCipherTime, storeKeyTime, totalTime);
                } else {
                    // Sign-up scenario
                    long addUserTime = jsonObject.getLong("addUserTime");
                    long h1h2Time = jsonObject.getLong("h1h2Time");
                    long verifyCipherTime = jsonObject.getLong("verifyCipherTime");
                    long storeKeyTime = jsonObject.getLong("storekeyTime");

                    logs = new TimeLogs(addUserTime, h1h2Time, 0, verifyCipherTime, storeKeyTime, totalTime);
                }

                timeLogs.setValue(logs);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

    }
}
