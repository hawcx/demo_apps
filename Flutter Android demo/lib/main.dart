import 'package:flutter/material.dart';
import 'account_restore_screen.dart';
import 'home_screen.dart';
import 'restore_verification_screen.dart';
import 'signin_screen.dart';
import 'signup_screen.dart';
import 'verification_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hawcx Auth Demo',
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => SignupScreen(),
        '/verification': (context) => VerificationScreen(
              email: ModalRoute.of(context)!.settings.arguments as String,
            ),
        '/home': (context) => HomeScreen(),
        '/signin': (context) => SignInScreen(),
        '/accountRestore': (context) => AccountRestoreScreen(),
        '/restoreVerification': (context) => RestoreVerificationScreen(
              email: ModalRoute.of(context)!.settings.arguments as String,
            ),
      },
    );
  }
}
