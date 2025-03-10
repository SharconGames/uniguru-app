import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/starScreen/star_background.dart';
// Import the StarBackground widget

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
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
    Timer(const Duration(seconds: 4), () {
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
    bool isDesktop = MediaQuery.of(context).size.width >= 1024;
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Stack(
      // Use Stack to layer widgets
      children: [
        const StarBackground(), // Add star background
        Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // UniGuru Text
                Text(
                  'UniGuru',
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: isDesktop ? 30 : 28,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none, // Ensure no underline
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
                      ).createShader(Rect.fromLTWH(
                          0, 0, 400, 70)), // Set the rect for the gradient
                  ),
                ),
                SizedBox(
                  height: isDesktop ? screenheight * 0.45 : screenheight * 0.40,
                  child: Image.asset(
                    'assets/splash_image.png',
                    width: screenwidth * 0.7,
                    height: screenheight * 0.7,
                  ),
                ), // Use your splash image here
                SizedBox(height: screenheight * 0.01),
              ],
            ),
          ),
        ),
        // Positioned(
        //   bottom: 20,
        //   right: 20,
        //   child: Image.asset(
        //     'assets/blackhole_logo.png',

        //     width: isDesktop
        //         ? screenwidth * 0.06
        //         : screenwidth * 0.15, // Small size, adjust as needed
        //     height: screenwidth * 0.15, // Keep it square
        //     opacity: const AlwaysStoppedAnimation(0.7), // Slight transparency
        //   ),
        // ),
      ],
    );
  }
}
