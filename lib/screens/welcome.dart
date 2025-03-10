import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uniguru/pages/AuthPage.dart';
import '../widgets/starScreen/star_background.dart';

class WelcomePage extends StatelessWidget {
  //final String userName;
  final GoogleSignInAccount user;

  const WelcomePage({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Determine if it's a tablet with a more precise check
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600 ||
        (screenWidth > 600 && screenWidth / screenHeight < 0.6);

    return GestureDetector(
      onTap: () {
        // Random click redirects to home page
        Navigator.pushNamed(context, '/home');
      },
      child: Stack(
        // Use Stack to layer widgets
        children: [
          const StarBackground(), // Add star background
          Scaffold(
            backgroundColor: Colors.transparent, // Make scaffold transparent
            body: SingleChildScrollView(
              // Wrap the entire body in a SingleChildScrollView
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet
                      ? screenWidth * 0.08 // Increased margin for tablets
                      : screenWidth * 0.04, // Original margin for phones
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: screenHeight * 0.08), // Adjusted top spacing
                    // "Guru" text
                    Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFF664D00),
                            Color(0xFF7F6209),
                            Color(0xFFDAA520),
                            Color(0xFF664D00),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds),
                        child: Text(
                          'Gurus',
                          style: GoogleFonts.roboto(
                            fontSize: isTablet
                                ? screenWidth * 0.05
                                : screenWidth * 0.08, // Dynamic font size
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: isTablet
                            ? screenHeight * 0.07
                            : screenHeight * 0.12), // Adjusted spacing

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
                      child: Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.02),
                        child: Text(
                          'Welcome,',
                          style: GoogleFonts.lexend(
                            fontSize: isTablet
                                ? screenWidth * 0.038
                                : screenWidth * 0.06, // Dynamic font size
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height:
                          isTablet ? screenHeight * 0.03 : screenHeight * 0.06,
                    ),
                    // Adjusted spacing

                    // User name (e.g., John Smith)
                    Align(
                      alignment: Alignment.centerRight,
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
                          user.displayName!,
                          style: GoogleFonts.lexend(
                            fontSize: isTablet
                                ? screenWidth * 0.045
                                : screenWidth * 0.07, // Dynamic font size
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                        height: isTablet
                            ? screenHeight * 0.06
                            : screenHeight * 0.11), // Adjusted spacing

                    // Card with welcome text
                    Card(
                      // margin: EdgeInsets.symmetric(
                      //   horizontal:
                      //       isTablet ? screenWidth * 0.08 : screenWidth * 0.05,
                      //   vertical: isTablet
                      //       ? screenHeight * 0.02
                      //       : screenHeight * 0.01,
                      // ), // Adds spacing from the screen edges

                      color: const Color(0xFF2B1736), // Dark purple background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(isTablet
                            ? screenWidth * 0.01
                            : screenWidth * 0.05), // Dynamic padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFF74BDCC),
                                  Color(0xFF72EFDD),
                                  Color(0xFF9790DA),
                                  Color(0xFFAD7FDF),
                                  Color(0xFF779BED),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                              child: GestureDetector(
                                onTap: () async {
                                 

                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => AuthPage()));
                                },
                                child: Text(
                                  'Welcome to UniGuru,',
                                  style: GoogleFonts.lexend(
                                    fontSize: isTablet
                                        ? screenWidth * 0.04
                                        : screenWidth *
                                            0.06, // Dynamic font size
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                height: isTablet
                                    ? screenHeight * 0.015
                                    : screenHeight * 0.01), // Adjusted spacing
                            Text(
                              'Step into the future with our AI-powered chat app, blending wisdom and cutting-edge technology. Engage with AI Gurus, and create your customized Gurus offering seamless support, insights, and automation. Discover innovation and personalized assistance in an immersive, futuristic experience. Join us and explore the universe of AI Gurus today!',
                              style: GoogleFonts.lexend(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: isTablet
                                    ? screenWidth * 0.02
                                    : screenWidth * 0.04, // Dynamic font size
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        height: isTablet
                            ? screenHeight * 0.05
                            : screenHeight * 0.01),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
