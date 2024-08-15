package com.example.demo.activities;

import static com.example.demo.helpers.Constants.API_KEY;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.activity.OnBackPressedCallback;
import androidx.appcompat.app.AppCompatActivity;

import com.example.demo.R;
import com.hawcx.HawcxInitializer;
import com.hawcx.auth.Restore;
import com.hawcx.utils.EncryptedSharedPreferencesUtil;

public class ResetAccountActivity extends AppCompatActivity {
    // Get the UI components
    private EditText emailEditText;
    private EditText otpEditText;
    private Button submitButton;
    private ProgressBar progressBar;
    private View informationSection;

    private Restore restoreAccountManager;
    private String email;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_rpw);

        initViews();
        restoreAccountManager = HawcxInitializer.getInstance().getRestore();
        submitButton.setOnClickListener(v -> handleSubmit());

        getOnBackPressedDispatcher().addCallback(this, new OnBackPressedCallback(true) {
            @Override
            public void handleOnBackPressed() {
                navigateToLogin();
                finish();
            }
        });

    }

    private void initViews() {
        emailEditText = findViewById(R.id.email_input);
        otpEditText = findViewById(R.id.otp_input);
        submitButton = findViewById(R.id.submit_button);
        progressBar = findViewById(R.id.progress_bar);
        informationSection = findViewById(R.id.information_section);
    }

    private void handleSubmit() {
        if (otpEditText.getVisibility() != View.VISIBLE) {
            handleEmailSubmit();
        } else {
            handleOTPSubmit();
        }
    }

    private void handleEmailSubmit() {
        email = emailEditText.getText().toString().trim();
        if (isValidEmail(email)) {
            showLoading(true);
            restoreAccountManager.generateOtp(email, this::onAccountRestored, this::showError);
        } else {
            showError("Enter a valid email address");
        }
    }

    private void handleOTPSubmit() {
        String otp = otpEditText.getText().toString().trim();
        if (!otp.isEmpty()) {
            showLoading(true);
            restoreAccountManager.verifyOtp(email, otp, this::onOtpVerified, this::showError);
        } else {
            showError("Please enter the OTP");
        }
    }

    private boolean isValidEmail(String email) {
        return android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches();
    }

    private void onAccountRestored(String message) {
        runOnUiThread(() -> {
            showLoading(false);
            emailEditText.setEnabled(false);
            otpEditText.setVisibility(View.VISIBLE);
            informationSection.setVisibility(View.VISIBLE);
            submitButton.setText("Verify OTP");
            Toast.makeText(this, message, Toast.LENGTH_SHORT).show();
        });
    }

    private void onOtpVerified(String message) {
        showLoading(false);
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show();
        EncryptedSharedPreferencesUtil.setBoolean(this, "password_reset", true);
        navigateToLogin();
    }

    private void showError(String errorMessage) {
        showLoading(false);
        Toast.makeText(this, errorMessage, Toast.LENGTH_SHORT).show();
    }

    private void showLoading(boolean isLoading) {
        progressBar.setVisibility(isLoading ? View.VISIBLE : View.GONE);
        submitButton.setEnabled(!isLoading);
    }

    private void navigateToLogin() {
        Intent intent = new Intent(ResetAccountActivity.this, LoginActivity.class);
        startActivity(intent);
        finish();
    }
}
