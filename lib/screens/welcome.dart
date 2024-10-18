import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Use Google Fonts if custom fonts are needed

class WelcomePage extends StatelessWidget {
  final String userName;

  const WelcomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Random click redirects to home page
        Navigator.pushNamed(context, '/home');
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0E0513),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80), // Add some spacing at the top
              // "Guru" text
              Center(
                child: Text(
                  'Guru',
                  style: GoogleFonts.roboto(
                    color: const Color(0xFF9B6D0A), // Golden-ish color
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              // "Welcome" text
              Text(
                'Welcome,',
                style: GoogleFonts.roboto(
                  color: const Color(0xFF4FE2D7), // Teal color
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              // User name (e.g., John Smith)
              Text(
                userName,
                style: GoogleFonts.roboto(
                  color: const Color(0xFFC0A3F5), // Light purple color
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              // Card with welcome text
              Card(
                color: const Color(0xFF523F68), // Dark purple background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to UniGuru,',
                        style: GoogleFonts.roboto(
                          color: const Color(0xFF4FE2D7), // Teal color
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Step into the future with our AI-powered chat app, blending wisdom and cutting-edge technology. Engage with AI Gurus, and create your customized Gurus offering seamless support, insights, and automation. Discover innovation and personalized assistance in an immersive, futuristic experience. Join us and explore the universe of AI Gurus today!',
                        style: GoogleFonts.roboto(
                          color: Colors.white.withOpacity(0.9), // Light white
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
