import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationScreen extends StatefulWidget {
  final String email; // Accept the email parameter

  VerificationScreen({required this.email});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  static const platform = MethodChannel('hawcx');
  final TextEditingController _otpController = TextEditingController();
  bool loading = false; // For showing progress during OTP verification
  bool resending = false; // For showing progress during OTP resend

  void handleVerifyOtp() async {
    if (_otpController.text.isNotEmpty) {
      setState(() {
        loading = true;
      });

      try {
        await platform.invokeMethod('handleVerifyOTP',
            {'email': widget.email, 'otp': _otpController.text});
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
      await platform.invokeMethod('signUp', {'username': widget.email});
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
          mainAxisAlignment: MainAxisAlignment.center,
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
