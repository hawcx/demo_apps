package com.example.demo.activities;

import static com.example.demo.helpers.Constants.API_KEY;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.widget.Toast;
import android.widget.Button;
import android.widget.EditText;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.example.demo.R;

import com.hawcx.HawcxInitializer;
import com.hawcx.auth.SignUp;
import com.hawcx.utils.AuthErrorHandler;

public class SignupActivity extends AppCompatActivity{
    private EditText userIdEditText;
    private Button signupButton;

    private Button loginButton;
    private Button addDeviceButton;
    private SignUp signUpManager;
    private static final int LOCATION_PERMISSION_REQUEST_CODE = 1000;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_signup);

        userIdEditText = findViewById(R.id.email_input);
        signupButton = findViewById(R.id.signup_button);
        loginButton = findViewById(R.id.login_button);

//        signUpManager = new SignUp(this, API_KEY);
        signUpManager = HawcxInitializer.getInstance().getSignUp();
        signupButton.setOnClickListener(v -> checkLocationPermissionAndHandleSignUp());
        loginButton.setOnClickListener(v -> navigateToLogin());
    }

    private void checkLocationPermissionAndHandleSignUp() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this,
                    new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                    LOCATION_PERMISSION_REQUEST_CODE);
        } else {
            handleSignUp();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == LOCATION_PERMISSION_REQUEST_CODE) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                handleSignUp();
            } else {
                Toast.makeText(this, "Location permission is required for signup", Toast.LENGTH_LONG).show();
            }
        }
    }
    private void handleSignUp() {
        String email = userIdEditText.getText().toString().trim();
        if (isValidEmail(email)) {
            signUpManager.signUp(
                    email,
                    this::navigateToHome,
                    this::showError
            );
        } else {
            showError("Enter a valid email address");
        }
    }

    private boolean isValidEmail(String email) {
        return android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches();
    }

    private void navigateToHome() {
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

    private void showError(AuthErrorHandler.SignUpErrorCode signUpErrorCode, String errorMessage) {
        String displayMessage = AuthErrorHandler.getSignUpErrorMessage(signUpErrorCode, errorMessage);
        Toast.makeText(this, displayMessage, Toast.LENGTH_SHORT).show();
//        Toast.makeText(this, signUpErrorCode.getCode(), Toast.LENGTH_SHORT).show();
    }

    private void showError(String errorMessage) {
        Toast.makeText(this, errorMessage, Toast.LENGTH_SHORT).show();
    }

}


