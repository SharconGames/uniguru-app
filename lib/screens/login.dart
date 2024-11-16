import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uniguru/widgets/gradientbutton.dart'; // Import the GradientButton
import 'package:uniguru/widgets/socialsignupbutton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible =
      false; // State variable to manage password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0E0513), // Background color matching the theme
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20.0), // Base padding for the whole screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 25.0),
            //UniGuru Text
            Center(
              child: Text(
                'UniGuru',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  // Set to white (masked by gradient)
                ),
              ),
            ),

            // UniGuru Logo at the top
            Center(
              child: Image.asset(
                'assets/splash_image.png', // Path to your logo image asset
                height: 190, // Adjust height if necessary
              ),
            ),

            const SizedBox(height: 1.0),

            // Email input field with specific padding
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Email Label and TextField
                const Text(
                  'Email:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                    height: 8.0), // Space between label and TextField
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF403B4D),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Enter your email address',
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF61ACEF),
                          Color(0xFF9987ED),
                          Color(0xFFB679E1),
                          Color(0xFF9791DB),
                          Color(0xFF74BDCC),
                          Color(0xFF72EFDD),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.topLeft,
                      ).createShader(bounds),
                      child: const Icon(Icons.email_outlined),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                    height: 15.0), // Space between email and password field

                // Password Label and TextField
                const Text(
                  'Password:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                    height: 8.0), // Space between label and TextField
                TextField(
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF403B4D),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF72EFDD),
                          Color(0xFFB77DEA),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                    height: 30.0), // Space between password and button

                // Login Button with Gradient
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 100.0), // Custom padding for button
                  child: GradientButton(
                    text: 'Login',

                    onPressed: () {
                      // Navigate to home on successful login
                      Navigator.pushNamed(context, '/welcome');
                    },
                    width: 300, // Custom width
                    height: 50, // Custom height
                  ),
                ),
                const SizedBox(height: 15.0), // Space after the button
              ],
            ),

            // OR separator with specific padding
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0), // Custom padding
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                      endIndent: 10.0, // Space between line and text
                    ),
                  ),
                  Text(
                    'OR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                      indent: 10.0, // Space between text and line
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),

            // Signup with Google Button
            SocialSignupButton(
              label: 'Signup with Google',
              assetPath:
                  'assets/icons8-google-36.png', // Path to your Google logo
              onPressed: () {
                // Add your Google signup logic here
              },
            ),
            const SizedBox(height: 15), // Spacing

            // Signup with Facebook Button
            SocialSignupButton(
              label: 'Signup with Facebook',
              assetPath: 'assets/facebook.png', // Path to your Facebook logo
              onPressed: () {
                // Add your Facebook signup logic here
              },
              // Facebook blue color
            ),
            const SizedBox(height: 15), // Spacing

            // Signup with Twitter Button
            SocialSignupButton(
              label: 'Signup with Twitter',
              assetPath: 'assets/twitter.png', // Path to your Twitter logo
              onPressed: () {
                // Add your Twitter signup logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}
