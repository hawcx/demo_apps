import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HawcxAuthScreen extends StatefulWidget {
  @override
  _HawcxAuthScreenState createState() => _HawcxAuthScreenState();
}

class _HawcxAuthScreenState extends State<HawcxAuthScreen> {
  static const platform = MethodChannel(
      'hawcx'); // Channel name should match the one in MainActivity.kt
  String _message = 'No operation performed yet';

  // Method to call native signUp
  Future<void> signUp(String username) async {
    try {
      final String result =
          await platform.invokeMethod('signUp', {'username': username});
      setState(() {
        _message = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _message = "Failed to sign up: ${e.message}";
      });
    }
  }

  // Method to call native signIn
  Future<void> signIn(String username) async {
    try {
      final String result =
          await platform.invokeMethod('signIn', {'username': username});
      setState(() {
        _message = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _message = "Failed to sign in: ${e.message}";
      });
    }
  }

  // Method to handle OTP verification
  Future<void> verifyOTP(String username, String otp) async {
    try {
      final String result = await platform
          .invokeMethod('handleVerifyOTP', {'username': username, 'otp': otp});
      setState(() {
        _message = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _message = "Failed to verify OTP: ${e.message}";
      });
    }
  }

  // Example UI for testing native methods
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hawcx Auth Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => signUp('testuser@example.com'),
              child: Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () => signIn('testuser@example.com'),
              child: Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: () => verifyOTP('testuser@example.com', '123456'),
              child: Text('Verify OTP'),
            ),
            SizedBox(height: 20),
            Text(_message),
          ],
        ),
      ),
    );
  }
}
