import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RestoreVerificationScreen extends StatefulWidget {
  final String email; // Accept the email parameter

  RestoreVerificationScreen({required this.email});

  @override
  _RestoreVerificationScreenState createState() =>
      _RestoreVerificationScreenState();
}

class _RestoreVerificationScreenState extends State<RestoreVerificationScreen> {
  static const platform = MethodChannel('com.example.flutter_hawcx/hawcx');
  final TextEditingController _otpController = TextEditingController();
  bool loading = false; // For OTP verification loading
  bool resending = false; // For resending OTP loading

  void handleVerifyOtp() async {
    if (_otpController.text.isNotEmpty) {
      setState(() {
        loading = true;
      });

      try {
        await platform.invokeMethod('verifyOtpForAccountRestore',
            {'email': widget.email, 'otp': _otpController.text});
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account restored successfully!')));
        Navigator.pushReplacementNamed(context, '/signin');
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to verify OTP')));
      } finally {
        setState(() {
          loading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter OTP')));
    }
  }

  void handleResendOtp() async {
    setState(() {
      resending = true;
    });

    try {
      await platform.invokeMethod(
          'generateOtpForAccountRestore', {'email': widget.email});
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('A new OTP has been sent to your email.')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to resend OTP')));
    } finally {
      setState(() {
        resending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify OTP')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Enter the OTP sent to ${widget.email}:'),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: 'OTP'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading ? null : handleVerifyOtp,
              child: Text(loading ? 'Verifying OTP...' : 'Verify OTP'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: resending ? null : handleResendOtp,
              child: Text(resending ? 'Resending OTP...' : 'Resend OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
