package com.example.flutter_hawcx

import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.example.flutter_hawcx.HawcxModule

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "com.example.flutter_hawcx/hawcx"
    private lateinit var hawcxModule: HawcxModule  

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize HawcxModule
        hawcxModule = HawcxModule(this)
    }

    // Ensure flutterEngine is initialized to avoid nullability issues
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // Set up the method channel to communicate with Flutter
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                // Sign-up functionality
                "signUp" -> {
                    val username = call.argument<String>("username")
                    if (username != null) {
                        hawcxModule.signUp(username, result)
                    } else {
                        result.error("ERROR", "Username is required", null)
                    }
                }

                // Sign-in functionality
                "signIn" -> {
                    val username = call.argument<String>("username")
                    if (username != null) {
                        hawcxModule.signIn(username, result)
                    } else {
                        result.error("ERROR", "Username is required", null)
                    }
                }

                // OTP Verification functionality
                "handleVerifyOTP" -> {
                    val username = call.argument<String>("username")
                    val otp = call.argument<String>("otp")
                    if (username != null && otp != null) {
                        hawcxModule.handleVerifyOTP(username, otp, result)
                    } else {
                        result.error("ERROR", "Username and OTP are required", null)
                    }
                }

                // Get last signed-in user
                "getLastUser" -> {
                    hawcxModule.getLastUser(result)
                }

                // Check last signed-in user
                "checkLastUser" -> {
                    hawcxModule.checkLastUser(result)
                }

                // Initiate biometric login
                "initiateBiometricLogin" -> {
                    hawcxModule.initiateBiometricLogin(result, Runnable { })
                }

                // Generate OTP for account restore
                "generateOtpForAccountRestore" -> {
                    val email = call.argument<String>("email")
                    if (email != null) {
                        hawcxModule.generateOtpForAccountRestore(email, result)
                    } else {
                        result.error("ERROR", "Email is required", null)
                    }
                }

                // Verify OTP for account restore
                "verifyOtpForAccountRestore" -> {
                    val email = call.argument<String>("email")
                    val otp = call.argument<String>("otp")
                    if (email != null && otp != null) {
                        hawcxModule.verifyOtpForAccountRestore(email, otp, result)
                    } else {
                        result.error("ERROR", "Email and OTP are required", null)
                    }
                }

                // Default handler for unknown method calls
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
