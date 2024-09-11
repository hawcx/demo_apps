package com.example.demo.activities;

import static com.example.demo.helpers.Constants.API_KEY;
import static com.example.demo.helpers.Constants.KEY_IS_FIRST_RUN;
import static com.example.demo.helpers.Constants.LOCATION_PERMISSION_REQUEST_CODE;
import static com.example.demo.helpers.Constants.PREFS_NAME;
import static com.example.demo.helpers.Utils.isValidEmail;

import android.Manifest;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.Toast;
import android.widget.Button;
import android.widget.EditText;
import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.example.demo.R;

import com.example.demo.helpers.Constants;
import com.hawcx.HawcxInitializer;
import com.hawcx.auth.SignUp;
import com.hawcx.utils.AuthErrorHandler;

public class SignupActivity extends AppCompatActivity implements SignUp.SignUpCallback {
    private EditText userIdEditText;
    private EditText otpEditText;
    private Button signupButton;
    private Button loginButton;
    private Button verifyOtpButton;
    private Button resendButton;
    private Button anotherAccountButton;
    private ProgressBar progressBar;
    private ConstraintLayout containerLayout;
    private ConstraintLayout otpContainerLayout;

    private SignUp signUpManager;

    private boolean isFirstRun;
    private String email;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_signup);

        initSetup();
        initViews();
    }

    private void initViews() {
        containerLayout = findViewById(R.id.container);
        otpContainerLayout = findViewById(R.id.otp_container);
        otpContainerLayout.setVisibility(View.GONE);
        userIdEditText = findViewById(R.id.email_input);
        otpEditText = findViewById(R.id.otp_input);
        signupButton = findViewById(R.id.signup_button);
        signupButton.setOnClickListener(v -> handleSignup());
        verifyOtpButton = findViewById(R.id.submit_otp_button);
        verifyOtpButton.setOnClickListener(v -> handleVerifyOtp());
        loginButton = findViewById(R.id.login_button);
        loginButton.setOnClickListener(v -> {
            if (isFirstRun) {
                navigateToRestore();
            } else {
                navigateToLogin();
            }
        });
        resendButton = findViewById(R.id.resend_button);
        resendButton.setOnClickListener(v -> handleEmailVerify());
        anotherAccountButton = findViewById(R.id.another_button);
        anotherAccountButton.setOnClickListener(v -> handleAnotherAccount());
        progressBar = findViewById(R.id.progress_bar);

        if(isFirstRun) {
            loginButton.setText("Restore Account");
        }
    }

    private void initSetup() {
        SharedPreferences preferences = getSharedPreferences(PREFS_NAME, MODE_PRIVATE);
        isFirstRun = preferences.getBoolean(KEY_IS_FIRST_RUN, true);

//        signUpManager = new SignUp(this, API_KEY);
        signUpManager = HawcxInitializer.getInstance().getSignUp();
    }

    private void handleSignup() {
        email = userIdEditText.getText().toString().trim();
        if(isValidEmail(email)) {
            checkLocationPermissionAndHandleSignUp();
        } else {
            showError("Enter a valid email address");
        }
    }

    private void checkLocationPermissionAndHandleSignUp() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this,
                    new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                    LOCATION_PERMISSION_REQUEST_CODE);
        } else {
            handleEmailVerify();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == LOCATION_PERMISSION_REQUEST_CODE) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                handleEmailVerify();
            } else {
                Toast.makeText(this, "Location permission is required for signup", Toast.LENGTH_LONG).show();
            }
        }
    }

    private void handleEmailVerify() {
        showLoading(true);
        signUpManager.signUp(email, this);
    }

    private void handleVerifyOtp() {
//        otp validation
        String otp = otpEditText.getText().toString().trim();
        if(otp.isEmpty()) {
            showError("Enter an OTP");
        } else {
            showLoading(true);
            signUpManager.handleVerifyOTP(email, otp, this);
        }
    }

    private void navigateToHome() {
        showLoading(false);
        Intent intent = new Intent(SignupActivity.this, HomeActivity.class);
        Bundle b = new Bundle();
        b.putString("lastEmail", "");
        intent.putExtras(b);
        startActivity(intent);
        finish();
    }

    private void navigateToLogin(){
        Intent intent = new Intent(SignupActivity.this, LoginActivity.class);
        startActivity(intent);
        finish();
    }

    private void navigateToRestore(){
        Intent intent = new Intent(SignupActivity.this, ResetAccountActivity.class);
        startActivity(intent);
        finish();
    }

    private void showLoading(Boolean isLoading) {
        progressBar.setVisibility(isLoading ? View.VISIBLE : View.GONE);
        containerLayout.setVisibility(isLoading ? View.GONE : View.VISIBLE);
        otpContainerLayout.setVisibility(isLoading ? View.GONE : View.VISIBLE);
    }

    private void showOtpContainer(){
        progressBar.setVisibility(View.GONE);
        containerLayout.setVisibility(View.GONE);
        otpContainerLayout.setVisibility(View.VISIBLE);
    }

    private void handleAnotherAccount() {
        containerLayout.setVisibility(View.VISIBLE);
        otpContainerLayout.setVisibility(View.GONE);
        userIdEditText.setText("");
        email = "";
    }

    @Override
    public void showError(String errorMessage) {
        Toast.makeText(this, errorMessage, Toast.LENGTH_SHORT).show();
    }

    @Override
    public void showError(AuthErrorHandler.SignUpErrorCode signUpErrorCode, String errorMessage) {
        switch(signUpErrorCode) {
            case USER_ALREADY_EXISTS:
                navigateToLogin();
                break;
            case GENERATE_OTP_FAILED:
            case VERIFY_OTP_FAILED:
                showOtpContainer();
                break;
            default:
                break;
        }
        Toast.makeText(this, errorMessage, Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onSuccessfulSignup() {
        navigateToHome();
    }

    @Override
    public void onGenerateOTPSuccess() {
        Toast.makeText(this, "Succeed to generate OTP", Toast.LENGTH_LONG).show();
        showOtpContainer();
    }
}


