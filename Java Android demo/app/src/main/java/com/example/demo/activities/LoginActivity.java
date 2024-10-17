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
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.EditText;

import androidx.activity.OnBackPressedCallback;
import androidx.appcompat.app.AppCompatActivity;
import androidx.biometric.BiometricManager;
import androidx.biometric.BiometricPrompt;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.content.ContextCompat;

import com.hawcx.HawcxInitializer;
import com.hawcx.auth.SignIn;
import com.hawcx.utils.AuthErrorHandler;
import com.example.demo.R;

import java.util.concurrent.Executor;

public class LoginActivity extends AppCompatActivity implements SignIn.SignInCallback {
    private EditText userIdEditText;
    private Button loginButton;
    private Button signupButton;
    private Button restoreAccountButton;
    private ProgressBar progressBar;
    private ConstraintLayout containerLayout;

    private SignIn signIn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        initViews();
        initSetup();
    }

    private void initViews() {
        userIdEditText = findViewById(R.id.user_id);
        loginButton = findViewById(R.id.login_button);
        signupButton = findViewById(R.id.signup_button);
        restoreAccountButton = findViewById(R.id.lost_device_button);
        progressBar = findViewById(R.id.progress_bar);
        containerLayout = findViewById(R.id.container);

        loginButton.setOnClickListener(v -> handleSignIn());
        signupButton.setOnClickListener(v -> navigateToSignup());
        restoreAccountButton.setOnClickListener(v -> navigateToRestoreAccount());
    }

    private void initSetup() {
        SharedPreferences preferences = getSharedPreferences(PREFS_NAME, MODE_PRIVATE);
        if(preferences.getBoolean(KEY_IS_FIRST_RUN, true)) {
            SharedPreferences.Editor editor = preferences.edit();
            editor.putBoolean(KEY_IS_FIRST_RUN, false);
            editor.commit();
        }

//        signInManager = new SignIn(this, API_KEY);
        signIn = HawcxInitializer.getInstance().getSignIn();
        signIn.checkLastUser(this);

        setupBackPressHandler();
    }

    private void setupBackPressHandler() {
        getOnBackPressedDispatcher().addCallback(this, new OnBackPressedCallback(true) {
            @Override
            public void handleOnBackPressed() {
                startActivity(new Intent(LoginActivity.this, SignupActivity.class));
                finish();
            }
        });
    }

    public void showEmailSignInScreen() {
        userIdEditText.setVisibility(View.VISIBLE);
        loginButton.setVisibility(View.VISIBLE);
        signupButton.setVisibility(View.VISIBLE);
        restoreAccountButton.setVisibility(View.VISIBLE);
    }

    private void handleSignIn() {
        String email = userIdEditText.getText().toString().trim();
        if (isValidEmail(email)) {
            showLoading(true);
            signIn.signIn(email, this);
        } else {
            showError("Enter a valid email address");
        }
    }

    public void onSuccessfulLogin(String loggedInEmail) {
        navigateToHome(loggedInEmail);
    }

    private void navigateToHome(String loggedInEmail) {
        showLoading(false);
        Intent intent = new Intent(LoginActivity.this, HomeActivity.class);
        Bundle b = new Bundle();
        b.putString("lastEmail", loggedInEmail);
        intent.putExtras(b);
        startActivity(intent);
        finish();
    }

    private void navigateToSignup() {
        Intent intent = new Intent(LoginActivity.this, SignupActivity.class);
        startActivity(intent);
        finish();
    }

    private void navigateToRestoreAccount() {
        Intent intent = new Intent(LoginActivity.this, ResetAccountActivity.class);
        startActivity(intent);
        finish();
    }

    public void showError(AuthErrorHandler.SignInErrorCode signInErrorCode, String errorMessage) {
        showLoading(false);
        switch(signInErrorCode) {
            case USER_NOT_FOUND:
                navigateToSignup();
                break;
            case RESET_DEVICE:
                navigateToRestoreAccount();
                break;
            default:
                break;
        }
        Toast.makeText(this, errorMessage, Toast.LENGTH_LONG).show();
    }

    public void showError(String errorMessage) {
        showToast(errorMessage);
    }

    private void showToast(String message) {
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show();
    }

    public void initiateBiometricLogin(Runnable onSuccess) {
        BiometricManager biometricManager = BiometricManager.from(this);
        switch (biometricManager.canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_STRONG)) {
            case BiometricManager.BIOMETRIC_SUCCESS:
                authenticateBiometric(onSuccess);
                break;
            case BiometricManager.BIOMETRIC_ERROR_NO_HARDWARE:
            case BiometricManager.BIOMETRIC_ERROR_HW_UNAVAILABLE:
            case BiometricManager.BIOMETRIC_ERROR_NONE_ENROLLED:
                showToast("Biometric authentication is not available");
                break;
        }
    }

    private void authenticateBiometric(Runnable onSuccess) {
        Executor executor = ContextCompat.getMainExecutor(this);
        BiometricPrompt biometricPrompt = new BiometricPrompt(this, executor, new BiometricPrompt.AuthenticationCallback() {
            @Override
            public void onAuthenticationError(int errorCode, CharSequence errString) {
                super.onAuthenticationError(errorCode, errString);
                showToast("Authentication error: " + errString);
            }

            @Override
            public void onAuthenticationSucceeded(BiometricPrompt.AuthenticationResult result) {
                super.onAuthenticationSucceeded(result);
                showToast("Authentication Succeeded");
                onSuccess.run();
            }

            @Override
            public void onAuthenticationFailed() {
                super.onAuthenticationFailed();
                showToast("Authentication failed");
            }
        });

        BiometricPrompt.PromptInfo promptInfo = new BiometricPrompt.PromptInfo.Builder()
                .setTitle("Biometric login for my app")
                .setSubtitle("Log in using your biometric credential")
                .setNegativeButtonText("Use email to login")
                .build();

        biometricPrompt.authenticate(promptInfo);
    }

    private void showLoading(Boolean isLoading) {
        progressBar.setVisibility(isLoading ? View.VISIBLE : View.GONE);
        containerLayout.setVisibility(isLoading ? View.GONE : View.VISIBLE);
    }
}