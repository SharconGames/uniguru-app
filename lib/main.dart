import 'package:flutter/material.dart';
import 'package:uniguru/screens/home.dart';
import 'package:uniguru/screens/login.dart';
import 'package:uniguru/screens/splash.dart';
import 'package:uniguru/screens/welcome.dart';
import 'package:uniguru/theme/gradient_theme.dart'; // Import your theme.dart file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniGuru',
      theme: appTheme, // Use the appTheme defined in theme.dart
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/welcome': (context) => WelcomePage(userName: "john smith"),
        '/home': (context) => HomePage(),
      },
    );
  }
}
