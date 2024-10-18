import 'package:flutter/material.dart';
import 'dart:async';
// Import the theme.dart file

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    // Navigate to the login screen after the splash screen
    Timer(const Duration(seconds: 15), () {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/splash_image.png',
                width: 400,
                height: 400,
              ), // Use your splash image here
              const SizedBox(height: 20),
              Text(
                'UniGuru',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [
                        Color(0xFFE4BB1A), // Muted yellow
                        Color(0xFFE6C300), // Dimmed golden yellow
                        Color(0xFFB9961F), // Dark gold
                        Color(0xFF9B6F00), // Muted bronze
                      ],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      // ignore: prefer_const_constructors
                    ).createShader(Rect.fromLTWH(
                        0, 0, 400, 70)), // Set the rect for the gradient
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
