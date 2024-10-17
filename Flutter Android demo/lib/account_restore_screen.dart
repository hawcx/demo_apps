import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountRestoreScreen extends StatefulWidget {
  @override
  _AccountRestoreScreenState createState() => _AccountRestoreScreenState();
}

class _AccountRestoreScreenState extends State<AccountRestoreScreen> {
  static const platform = MethodChannel('com.example.flutter_hawcx/hawcx');
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false; // To show a loading spinner

  // Function to handle OTP generation for account restore
  void handleRestoreAccount() async {
    if (_emailController.text.isNotEmpty) {
      setState(() {
        isLoading = true; // Start loading spinner
      });

      try {
        // Await the native method's result
        await platform.invokeMethod(
            'generateOtpForAccountRestore', {'email': _emailController.text});

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('OTP sent! Please check your email.')));

        // Navigate to the restore verification screen upon success
        Navigator.pushNamed(context, '/restoreVerification',
            arguments: _emailController.text);
      } on PlatformException catch (e) {
        // If PlatformException occurs, display the error message
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
      } catch (e) {
        // Handle any other errors
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to initiate account restore')));
      } finally {
        setState(() {
          isLoading = false; // Stop loading spinner
        });
      }
    } else {
      // Show error if email is not entered
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter your email')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Restore Account')),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            ) // Show loading spinner while waiting for OTP
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Restore Account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: handleRestoreAccount,
                      child: Text('Restore Account')),
                  TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signin'),
                      child: Text('Back to Sign In')),
                  TextButton(
                      onPressed: _emailController.text.isNotEmpty
                          ? () {
                              Navigator.pushNamed(
                                  context, '/restoreVerification',
                                  arguments: _emailController.text);
                            }
                          : null,
                      child: Text('Received OTP? Verify it.')),
                ],
              ),
            ),
    );
  }
}
