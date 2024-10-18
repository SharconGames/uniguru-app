import 'package:flutter/material.dart';
import 'package:uniguru/widgets/gradientbutton.dart'; // Import the GradientButton
import 'package:uniguru/widgets/socialsignupbutton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
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
            // UniGuru Logo at the top
            Center(
              child: Image.asset(
                'assets/splash_image.png', // Path to your logo image asset
                height: 280, // Adjust height if necessary
              ),
            ),
            const SizedBox(height: 20),

            // Email input field with specific padding
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 20.0), // Custom padding for email field
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: const Color(
                      0xFF403B4D), // Matching the dark input field background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Enter your email address',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF61ACEF), // Light Blue
                        Color(0xFF9987ED), // Light Purple
                        Color(0xFFB679E1), // Lavender
                        Color(0xFF9791DB), // Soft Blue
                        Color(0xFF74BDCC), // Aqua Blue
                        Color(0xFF59D2BF), // Teal
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.topLeft,
                    ).createShader(bounds),
                    child: const Icon(Icons.email_outlined),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            // Password input field with specific padding
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 20.0), // Custom padding for password field
              child: TextField(
                obscureText: !_isPasswordVisible, // Toggle password visibility
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: const Color(0xFF403B4D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Enter your password',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF61ACEF), // Light Blue
                        Color(0xFF9987ED), // Light Purple
                        Color(0xFFB679E1), // Lavender
                        Color(0xFF9791DB), // Soft Blue
                        Color(0xFF74BDCC), // Aqua Blue
                        Color(0xFF59D2BF), // Teal
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.topLeft,
                    ).createShader(bounds),
                    child: const Icon(Icons.lock_outline),
                  ),
                  suffixIcon: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF72EFDD), // Starting color for gradient
                        Color(0xFFB77DEA), // Ending color for gradient
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility // Show password icon
                            : Icons.visibility_off, // Hide password icon
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible =
                              !_isPasswordVisible; // Toggle the password visibility
                        });
                      },
                    ),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),

            // Login Button with Gradient and specific padding
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 50.0), // Custom padding for login button
              child: GradientButton(
                text: 'Login',
                onPressed: () {
                  // Navigate to home on successful login
                  Navigator.pushNamed(context, '/welcome');
                },
                width: 200, // Custom width
                height: 50, // Custom height
              ),
            ),
            const SizedBox(height: 15), // Spacing

            // OR separator with specific padding
            const Padding(
              padding:
                  EdgeInsets.only(bottom: 20.0), // Custom padding for OR text
              child: Text(
                'OR',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
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
            const SizedBox(height: 10), // Spacing

            // Signup with Facebook Button
            SocialSignupButton(
              label: 'Signup with Facebook',
              assetPath:
                  'assets/icons8-google-36.png', // Path to your Facebook logo
              onPressed: () {
                // Add your Facebook signup logic here
              },
              // Facebook blue color
            ),
            const SizedBox(height: 10), // Spacing

            // Signup with Twitter Button
            SocialSignupButton(
              label: 'Signup with Twitter',
              assetPath:
                  'assets/icons8-google-36.png', // Path to your Twitter logo
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
