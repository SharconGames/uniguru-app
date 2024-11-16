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
              const SizedBox(height: 50), // Add some spacing at the top
              // "Guru" text
              Center(
                child: ShaderMask(
                  // Add ShaderMask to apply gradient
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF7F6209), // Dark Orchid
                      Color(0xFFDAA520), // Golden Rod
                      Color(0xFFFFD700), // Gold (light yellow)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds), // Gradient shader applied to text
                  child: Text(
                    'Guru',
                    style: GoogleFonts.roboto(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Set to white (masked by gradient)
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 120),
              // "Welcome" text

              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF74BDCC),
                    Color(0xFF72EFDD),
                    Color(0xFF9790DA), // Light Purple
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: Text(
                  'Welcome,',
                  style: GoogleFonts.lexend(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.white, // Masked by gradient
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // User name (e.g., John Smith)
              Align(
                alignment: Alignment.centerRight, // Align text to the right
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF9790DA), // First color (Light Purple)
                      Color(0xFFAD7FDF), // Second color
                      Color(0xFF779BED), // Third color
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: Text(
                    userName,
                    style: GoogleFonts.lexend(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Masked by gradient
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 150),
              // Card with welcome text
              Card(
                color: const Color(0xFF423354), // Dark purple background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFF74BDCC),
                            Color(0xFF72EFDD),
                            Color(0xFF9790DA),
                            Color(0xFFAD7FDF), // Intermediate Purple
                            Color(0xFF779BED), // Light Blue
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds),
                        child: Text(
                          'Welcome to UniGuru,',
                          style: GoogleFonts.lexend(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors
                                .white, // Set to white for gradient visibility
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Step into the future with our AI-powered chat app, blending wisdom and cutting-edge technology. Engage with AI Gurus, and create your customized Gurus offering seamless support, insights, and automation. Discover innovation and personalized assistance in an immersive, futuristic experience. Join us and explore the universe of AI Gurus today!',
                        style: GoogleFonts.lexend(
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
