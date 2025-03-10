import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uniguru/widgets/utils/LoginSignupToggle.dart';
import 'package:uniguru/widgets/animations/animatedswitchwrapper.dart';
import 'package:uniguru/widgets/login/loginForm.dart';
import 'package:uniguru/widgets/signup/signUpForm.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  // Controllers for login
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Controllers for signup
  final TextEditingController signupNameController = TextEditingController();
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupPasswordController =
      TextEditingController();

  final bool _isLoading = false;
  bool isLogin = true;
  bool isNotValidate = false;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600 ||
        (screenWidth > 600 && screenWidth / screenHeight < 0.6);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Center(
                  child: Image.asset(
                    'assets/splash_image.png',
                    height: isTablet ? screenHeight * 0.25 : screenHeight * 0.2,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                LoginSignupToggle(
                  isLogin: isLogin,
                  onLoginTap: () => setState(() => isLogin = true),
                  onSignupTap: () => setState(() => isLogin = false),
                  screenWidth: screenWidth,
                  isTablet: isTablet,
                ),
                SizedBox(height: screenHeight * 0.045),
                AnimatedSwitchScrapper(
                  isLogin: isLogin,
                  loginForm: _buildLoginForm(screenWidth, screenHeight),
                  signupForm: _buildSignupForm(screenWidth, screenHeight),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build login form
  Widget _buildLoginForm(double screenWidth, double screenHeight) {
    return LoginForm(
      emailcontroller: emailController,
      passwordcontroller: passwordController,
      isLoading: _isLoading,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
    );
  }

  // Build signup form
  Widget _buildSignupForm(double screenWidth, double screenHeight) {
    return SignupForm(
      signupNameController: signupNameController,
      signupEmailController: signupEmailController,
      signupPasswordController: signupPasswordController,
      isLoading: _isLoading,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
    );
  }
}
