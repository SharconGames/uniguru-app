import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:google_fonts/google_fonts.dart';
import 'package:uniguru/widgets/gradientbutton.dart'; // Import the GradientButton
=======
import 'package:uniguru/dbHelper/login_api.dart';
import 'package:uniguru/widgets/gradientbutton.dart';
>>>>>>> 2a2b775 (Project)
import 'package:uniguru/widgets/socialsignupbutton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
<<<<<<< HEAD
  // ignore: library_private_types_in_public_api
=======
>>>>>>> 2a2b775 (Project)
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
<<<<<<< HEAD
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
=======
  bool _isPasswordVisible = false;
  bool isLogin = true; // Toggle between Login and Signup

  @override
  Widget build(BuildContext context) {
    // Get the screen's height and width
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0513), // Dark theme background
      resizeToAvoidBottomInset:
          true, // This will adjust the layout when the keyboard is visible
      body: SafeArea(
        // Prevents overflow into system UI
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenHeight * 0.01),

                // Title or App Logo
                // Center(
                //   child: Text(
                //     'UniGuru',
                //     style: GoogleFonts.roboto(
                //       fontSize: screenWidth * 0.06,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),

                Center(
                  child: Image.asset(
                    'assets/splash_image.png',
                    height: screenHeight * 0.2, // 20% of screen height
                  ),
                ),

                // Toggle between Login and Signup
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () => setState(() => isLogin = true),
                        child: Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                              color: isLogin
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                color: isLogin ? Colors.white : Colors.grey,
                                fontWeight: isLogin
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        )),
                    SizedBox(width: screenWidth * 0.05),
                    GestureDetector(
                      onTap: () => setState(() => isLogin = false),
                      child: Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                            color: !isLogin
                                ? Colors.white.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Signup',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              color: !isLogin ? Colors.white : Colors.grey,
                              fontWeight: !isLogin
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),

                // Email and Password Fields
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isLogin)
                      _buildInputField(
                        label: "Name",
                        hint: 'Enter your name',
                        iconPath: 'assets/email.png',
                      ),
                    SizedBox(height: screenHeight * 0.019),
                    _buildInputField(
                      label: 'Email',
                      hint: 'Enter your email address',
                      iconPath: 'assets/email.png',
                    ),
                    SizedBox(height: screenHeight * 0.019),
                    _buildInputField(
                      label: 'Password',
                      hint: 'Enter your password',
                      iconPath: 'assets/password.png',
                      isPassword: true,
                    ),
                    SizedBox(height: screenHeight * 0.018),
                    if (!isLogin)
                      _buildInputField(
                        label: "Re-Enter Password",
                        hint: 'Confirm your password',
                        iconPath: 'assets/email.png',
                      ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),

                // Action Button (Login/Signup)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.18),
                  child: GradientButton(
                    text: isLogin ? 'Login' : 'Signup',
                    onPressed: () {
                      if (isLogin) {
                        Navigator.pushNamed(context, '/welcome');
                      } else {
                        Navigator.pushNamed(context, '/signup');
                      }
                    },
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.06,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),

                // OR Divider and Social Media Buttons (Only for Login)
                if (isLogin) ...[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1.0,
                            endIndent: screenWidth * 0.02,
                          ),
                        ),
                        Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1.0,
                            indent: screenWidth * 0.02,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  SocialSignupButton(
                    label: 'Signup with Google',
                    assetPath: 'assets/icons8-google-36.png',
                    onPressed: signIn,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  SocialSignupButton(
                    label: 'Signup with Facebook',
                    assetPath: 'assets/facebook.png',
                    onPressed: () {
                      // Add Facebook signup logic
                    },
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  SocialSignupButton(
                    label: 'Signup with Twitter',
                    assetPath: 'assets/twitter.png',
                    onPressed: () {
                      // Add Twitter signup logic
                    },
                  ),
                ],
              ],
            ),
          ),
>>>>>>> 2a2b775 (Project)
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  // Reusable Input Field Widget
  Widget _buildInputField({
    required String label,
    required String hint,
    required String iconPath,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6.0),
        TextField(
          obscureText: isPassword ? !_isPasswordVisible : false,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF403B4D),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            suffixIcon: isPassword
                ? IconButton(
                    icon: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(colors: [
                        Color(0xFF61ACEF), // Light Blue
                        Color(0xFF9987ED), // Light Purple
                        Color(0xFFB679E1), // Lavender
                        Color(0xFF9791DB), // Soft Blue
                        Color(0xFF74BDCC), // Aqua Blue
                        Color(0xFF59D2BF), // Teal
                      ]).createShader(bounds),
                      child: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                : Image.asset(
                    iconPath,
                    height: 20,
                    width: 20,
                  ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Future signIn() async {
    await GoogleSignInApi.login();
  }
>>>>>>> 2a2b775 (Project)
}
