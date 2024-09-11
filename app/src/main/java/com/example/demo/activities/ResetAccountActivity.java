package com.example.demo.activities;

import static com.example.demo.helpers.Constants.API_KEY;
import static com.example.demo.helpers.Constants.KEY_IS_FIRST_RUN;
import static com.example.demo.helpers.Constants.PREFS_NAME;
import static com.example.demo.helpers.Utils.isValidEmail;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.activity.OnBackPressedCallback;
import androidx.activity.OnBackPressedDispatcher;
import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;

import com.example.demo.R;
import com.hawcx.HawcxInitializer;
import com.hawcx.auth.Restore;
import com.hawcx.utils.EncryptedSharedPreferencesUtil;

public class ResetAccountActivity extends AppCompatActivity {
    // Get the UI components
    private EditText emailEditText;
    private EditText otpEditText;
    private Button submitEmailButton;
    private Button submitOtpButton;
    private Button resendButton;
    private Button anotherButton;
    private ProgressBar progressBar;
    private ConstraintLayout emailLayout;
    private ConstraintLayout otpLayout;

    private Restore restoreAccountManager;
    private String email;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_rpw);

        initViews();
        initSetup();
    }

    private void initViews() {
        emailEditText = findViewById(R.id.email_input);
        otpEditText = findViewById(R.id.otp_input);
        submitEmailButton = findViewById(R.id.submit_email_button);
        submitOtpButton = findViewById(R.id.submit_otp_button);
        resendButton = findViewById(R.id.resend_button);
        anotherButton = findViewById(R.id.another_button);
        progressBar = findViewById(R.id.progress_bar);
        progressBar.setVisibility(View.GONE);
        emailLayout = findViewById(R.id.email_container);
        otpLayout = findViewById(R.id.otp_container);
        otpLayout.setVisibility(View.GONE);
        submitEmailButton.setOnClickListener(v -> handleEmailSubmit());
        submitOtpButton.setOnClickListener(v -> handleOTPSubmit());
        resendButton.setOnClickListener(v -> handleEmailSubmit());
        anotherButton.setOnClickListener(v -> setVisibility(true));
    }

    private void initSetup() {
        restoreAccountManager = HawcxInitializer.getInstance().getRestore();

        setupBackPressHandler();
    }

    private void setupBackPressHandler() {
        getOnBackPressedDispatcher().addCallback(this, new OnBackPressedCallback(true) {
            @Override
            public void handleOnBackPressed() {
                SharedPreferences preferences = getSharedPreferences(PREFS_NAME, MODE_PRIVATE);
                Boolean isFirstRun = preferences.getBoolean(KEY_IS_FIRST_RUN, true);
                if(isFirstRun) {
                    startActivity(new Intent(ResetAccountActivity.this, SignupActivity.class));
                } else {
                    startActivity(new Intent(ResetAccountActivity.this, LoginActivity.class));
                }
                finish();
            }
        });
    }

    private void handleEmailSubmit() {
        email = emailEditText.getText().toString().trim();
        if (isValidEmail(email)) {
            showLoading(true);
            restoreAccountManager.generateOtp(email, this::onAccountRestored, this::onEmailError);
        } else {
            Toast.makeText(this, "Enter a valid email address", Toast.LENGTH_SHORT).show();
        }
    }

    private void handleOTPSubmit() {
        String otp = otpEditText.getText().toString().trim();
        if (!otp.isEmpty()) {
            showLoading(true);
            restoreAccountManager.verifyOtp(email, otp, this::onOtpVerified, this::onOtpError);
        } else {
            Toast.makeText(this, "Please enter the OTP", Toast.LENGTH_SHORT).show();
        }
    }

    private void onAccountRestored(String message) {
        runOnUiThread(() -> {
            Toast.makeText(this, message, Toast.LENGTH_SHORT).show();
            showLoading(false);
            setVisibility(false);
        });
    }

    private void onOtpVerified(String message) {
        showLoading(false);
        setVisibility(false);
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show();
        EncryptedSharedPreferencesUtil.setBoolean(this, "password_reset", true);
        navigateToLogin();
    }

    private void onEmailError(String errorMessage) {
        showLoading(false);
        setVisibility(true);
        Toast.makeText(this, errorMessage, Toast.LENGTH_SHORT).show();
    }

    private void onOtpError(String errorMessage) {
        showLoading(false);
        setVisibility(false);
        Toast.makeText(this, errorMessage, Toast.LENGTH_SHORT).show();
    }

    private void showLoading(boolean isLoading) {
        progressBar.setVisibility(isLoading ? View.VISIBLE : View.GONE);
        emailLayout.setVisibility(!isLoading ? View.VISIBLE : View.GONE);
        otpLayout.setVisibility(!isLoading ? View.VISIBLE : View.GONE);
    }

    private void setVisibility(boolean status) {
//        if status is true, show EmailLayout
        emailLayout.setVisibility(status ? View.VISIBLE : View.GONE);
        otpLayout.setVisibility(status ? View.GONE : View.VISIBLE);
    }

    private void navigateToLogin() {
        Intent intent = new Intent(ResetAccountActivity.this, LoginActivity.class);
        startActivity(intent);
        finish();
    }
}
