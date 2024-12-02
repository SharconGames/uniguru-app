import 'package:flutter/material.dart';
import 'package:uniguru/dbHelper/login_api.dart';
import 'package:uniguru/widgets/gradientbutton.dart';
import 'package:uniguru/widgets/socialsignupbutton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
        ),
      ),
    );
  }

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
}
