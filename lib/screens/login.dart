import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uniguru/dbHelper/config/config.dart';
import 'package:uniguru/dbHelper/login_api.dart';
import 'package:uniguru/provider/auth_notifier.dart';
import 'package:uniguru/widgets/gradientbutton.dart';
import 'package:uniguru/widgets/socialsignupbutton.dart';
import '../widgets/star_background.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool isLogin = true; // Toggle between Login and Signup
  bool isNotvalidate = false;

  void registerUser() async {
    if (emailcontroller.text.isNotEmpty &&
        passwordcontroller.text.isNotEmpty &&
        namecontroller.text.isNotEmpty) {
      //It will send the data to the backend with  http
      var regBody = {
        "name": namecontroller.text,
        "email": emailcontroller.text,
        "password": passwordcontroller,
      };

      //It will give the response from the backend
      var response = await http.post(Uri.parse(registartion),
          body: jsonEncode(regBody),
          headers: {"Content-Type": "application/json"});

      print(response);
    } else {
      setState(() {
        isNotvalidate = true;
      });
    }
  }

  //texteditingcontroller
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController namecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get the screen's height and width
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0513), // Dark theme background
      resizeToAvoidBottomInset: true, // Adjust layout when keyboard is visible
      body: Stack(
        // Use Stack to layer widgets
        children: [
          const StarBackground(), // Add star background
          SafeArea(
            // Prevents overflow into system UI
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: screenHeight * 0.01),

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
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                          ),
                        ),
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
                              borderRadius: BorderRadius.circular(10),
                            ),
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

                    // Animated Form Fields
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 600),
                      crossFadeState: isLogin
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: _buildLoginForm(screenWidth, screenHeight),
                      secondChild: _buildSignupForm(screenWidth, screenHeight),
                      layoutBuilder:
                          (topChild, topChildKey, bottomChild, bottomChildKey) {
                        return Stack(
                          clipBehavior: Clip.hardEdge,
                          children: [
                            Positioned(
                              key: bottomChildKey,
                              child: bottomChild,
                            ),
                            Positioned(
                              key: topChildKey,
                              child: topChild,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Login Form
  Widget _buildLoginForm(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email and Password Fields
        _buildInputField(
          label: 'Email',
          controller: emailcontroller,
          hint: 'Enter your email address',
          iconPath: 'assets/email.png',
        ),
        SizedBox(height: screenHeight * 0.019),
        _buildInputField(
          label: 'Password',
          controller: passwordcontroller,
          hint: 'Enter your password',
          iconPath: 'assets/password.png',
          isPassword: true,
        ),
        SizedBox(height: screenHeight * 0.02),

        // Action Button (Login)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.18),
          child: GradientButton(
            text: 'Login',
            onPressed: () {
              Navigator.pushNamed(context, '/welcome');
            },
            width: screenWidth * 0.6,
            height: screenHeight * 0.06,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),

        // OR Divider and Social Media Buttons
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
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
    );
  }

  // Signup Form
  Widget _buildSignupForm(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name Field
        _buildInputField(
          label: "Name",
          controller: namecontroller,
          hint: 'Enter your name',
          iconPath: 'assets/profile.png',
        ),
        SizedBox(height: screenHeight * 0.019),

        // Email Field
        _buildInputField(
          label: 'Email',
          controller: emailcontroller,
          hint: 'Enter your email address',
          iconPath: 'assets/email.png',
        ),
        SizedBox(height: screenHeight * 0.019),

        // Password Field
        _buildInputField(
          label: 'Password',
          controller: passwordcontroller,
          hint: 'Enter your password',
          iconPath: 'assets/password.png',
          isPassword: true,
        ),
        SizedBox(height: screenHeight * 0.018),

        // Confirm Password Field
        _buildInputField(
          label: "Re-Enter Password",
          controller: passwordcontroller,
          hint: 'Confirm your password',
          iconPath: 'assets/email.png',
          isPassword: true,
        ),
        SizedBox(height: screenHeight * 0.02),

        // Action Button (Signup)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.18),
          child: GradientButton(
            text: 'Signup',
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
            width: screenWidth * 0.6,
            height: screenHeight * 0.06,
          ),
        ),
      ],
    );
  }

  // Reusable Input Field Widget
  Widget _buildInputField({
    required String label,
    required String hint,
    required String iconPath,
    required final controller,
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
          controller: controller,
          obscureText: isPassword ? !_isPasswordVisible : false,
          decoration: InputDecoration(
            filled: false, // Set to false for transparent background
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            errorText: isNotvalidate ? "Enter Proper Info" : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.white
                    .withOpacity(0.5), // Border color with transparency
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(
                  color: Colors.white), // Border color when focused
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color:
                    Colors.white.withOpacity(0.5), // Border color when enabled
              ),
            ),
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
          style: const TextStyle(color: Colors.white), // Text color
        ),
      ],
    );
  }

//Mwthos for the google sign in
  Future signIn() async {
    final user = await GoogleSignInApi.login();

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Signin Failed')));
    } else {
      Navigator.pushNamed(
        context,
        '/welcome',
        arguments: user, // Pass the GoogleSignInAccount user here
      );
    }
  }
}
