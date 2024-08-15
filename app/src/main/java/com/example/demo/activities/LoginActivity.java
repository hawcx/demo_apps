package com.example.demo.activities;

import static com.example.demo.helpers.Constants.API_KEY;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.EditText;

import androidx.activity.OnBackPressedCallback;
import androidx.appcompat.app.AppCompatActivity;
import androidx.biometric.BiometricManager;
import androidx.biometric.BiometricPrompt;
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

    private SignIn signIn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        initializeViews();
        setupListeners();

//        signInManager = new SignIn(this, API_KEY);
        signIn = HawcxInitializer.getInstance().getSignIn();
        signIn.checkLastUser(this);

        setupBackPressHandler();
    }

    private void initializeViews() {
        userIdEditText = findViewById(R.id.user_id);
        loginButton = findViewById(R.id.login_button);
        signupButton = findViewById(R.id.signup_button);
        restoreAccountButton = findViewById(R.id.lost_device_button);
    }

    private void setupListeners() {
        loginButton.setOnClickListener(v -> handleSignIn());
        signupButton.setOnClickListener(v -> navigateToSignup());
        restoreAccountButton.setOnClickListener(v -> navigateToRestoreAccount());
    }

    private void setupBackPressHandler() {
        getOnBackPressedDispatcher().addCallback(this, new OnBackPressedCallback(true) {
            @Override
            public void handleOnBackPressed() {
                finish();
            }
        });
    }

    @Override
    public void showEmailSignInScreen() {
        userIdEditText.setVisibility(View.VISIBLE);
        loginButton.setVisibility(View.VISIBLE);
        signupButton.setVisibility(View.VISIBLE);
        restoreAccountButton.setVisibility(View.VISIBLE);
    }

    private void handleSignIn() {
        String email = userIdEditText.getText().toString().trim();
        if (isValidEmail(email)) {
            signIn.signIn(email, this);
        } else {
            showError("Enter a valid email address");
        }
    }

    private boolean isValidEmail(String email) {
        return android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches();
    }

    @Override
    public void onSuccessfulLogin(String loggedInEmail) {
        navigateToHome(loggedInEmail);
    }

    private void navigateToHome(String loggedInEmail) {
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

    @Override
    public void showError(AuthErrorHandler.SignInErrorCode signInErrorCode, String errorMessage) {
        String displayMessage = AuthErrorHandler.getSignInErrorMessage(signInErrorCode, errorMessage);
        showToast(displayMessage);
        showToast(signInErrorCode.getCode());
    }

    @Override
    public void showError(String errorMessage) {
        showToast(errorMessage);
    }

    private void showToast(String message) {
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show();
    }

    @Override
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
}