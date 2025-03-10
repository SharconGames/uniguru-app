import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uniguru/context/AuthNotifier.dart';
import 'package:uniguru/screens/chat.dart';

import 'package:uniguru/widgets/gradientbutton.dart';
import 'package:uniguru/widgets/starScreen/StarBackgroundWrapper.dart';
import 'package:uniguru/widgets/utils/errorDialog.dart';
import 'package:uniguru/widgets/utils/successDialog.dart';

class SignupForm extends ConsumerStatefulWidget {
  final TextEditingController signupNameController;
  final TextEditingController signupEmailController;
  final TextEditingController signupPasswordController;
  //final Function() onSignup;
  final bool isLoading;
  final double screenWidth;
  final double screenHeight;

  const SignupForm({
    super.key,
    required this.signupNameController,
    required this.signupEmailController,
    required this.signupPasswordController,
    //required this.onSignup,
    required this.isLoading,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  ConsumerState<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends ConsumerState<SignupForm> {
  bool _isPasswordVisible = false;
  bool isNotvalidate = false;
  bool _isLoading = false;
  bool isLogin = true;
  //bool isNotValidate = false;
  String errorMessage = "";

  // Email validation method
  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  // Register function
  void _registerUser() async {
    setState(() {
      errorMessage = "";
      _isLoading = true;
    });

    try {
      if (widget.signupEmailController.text.isEmpty ||
          widget.signupPasswordController.text.isEmpty ||
          widget.signupNameController.text.isEmpty) {
        _showErrorDialog("Please fill in all fields");
        return;
      }

      if (!_isValidEmail(widget.signupEmailController.text)) {
        _showErrorDialog("Invalid email format");
        return;
      }

      final result = await ref.read(authStateProvider.notifier).signup(
            widget.signupNameController.text.trim(),
            widget.signupEmailController.text.trim(),
            widget.signupPasswordController.text,
          );

      if (!mounted) return;

      // Check for successful signup and navigate
      final authState = ref.read(authStateProvider);

      if (authState.isLoggedIn && authState.navigateUrl != null) {
        print("Navigating to: ${authState.navigateUrl}");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StarBackgroundWrapper(
              child: ChatScreen(
                navigateUrl: authState.navigateUrl!,
                chatId: authState.user?.chatId ?? '',
                chatbotId: authState.user?.chatbotId ?? '',
              ),
            ),
          ),
        );
      } else if (authState.error != null) {
        _showErrorDialog(authState.error!);
      }
    } catch (e) {
      print("Signup error: $e");
      _showErrorDialog("An error occurred during registration");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(message: message);
      },
    );
  }

  // Show success dialog
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessDialog(message: message);
      },
    );
  }

  Widget _buildInputField({
    String label = '',
    required String hint,
    required String iconPath,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    bool isDesktop = widget.screenWidth >= 1024;
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        // Use a percentage-based width instead of fixed margins
        width: isDesktop
            ? screenWidth * 0.3
            : isTablet
                ? screenWidth * 0.5
                : screenWidth * 0.9,
        margin: EdgeInsets.symmetric(
          horizontal: isDesktop
              ? screenWidth * 0.1
              : isTablet
                  ? screenWidth * 0.1
                  : 0.0,
          vertical: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label.isNotEmpty)
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
                filled: false,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
                errorText: isNotvalidate ? "Enter Proper Info" : null,
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.5), width: 4),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(color: Colors.white, width: 4),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.5), width: 4),
                ),
                suffixIcon: isPassword
                    ? IconButton(
                        icon: ShaderMask(
                          shaderCallback: (bounds) =>
                              const LinearGradient(colors: [
                            Color(0xFF61ACEF),
                            Color(0xFF9987ED),
                            Color(0xFFB679E1),
                            Color(0xFF9791DB),
                            Color(0xFF74BDCC),
                            Color(0xFF59D2BF),
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600 ||
        (widget.screenWidth > 600 &&
            widget.screenWidth / widget.screenHeight < 2.0);

    bool isDesktop = widget.screenWidth >= 1024;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField(
          // label: "Name",
          controller: widget.signupNameController,
          hint: 'Enter your name',
          iconPath: 'assets/profile.png',
        ),
        SizedBox(height: widget.screenHeight * 0.024),
        _buildInputField(
          // label: 'Email',
          controller: widget.signupEmailController,
          hint: 'Enter your email address',
          iconPath: 'assets/email.png',
        ),
        SizedBox(height: widget.screenHeight * 0.024),
        _buildInputField(
          // label: 'Password',
          controller: widget.signupPasswordController,
          hint: 'Enter your password',
          iconPath: 'assets/password.png',
          isPassword: true,
        ),
        SizedBox(height: widget.screenHeight * 0.035),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop
                  ? widget.screenWidth *
                      0.30 // Wider horizontal padding for desktop
                  : isTablet
                      ? widget.screenWidth * 0.360
                      : widget.screenWidth * 0.180,
            ),
            child: widget.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.7),
                      ),
                    ),
                  )
                : GradientButton(
                    text: 'Signup',
                    onPressed: _registerUser,
                    width: isDesktop
                        ? widget.screenWidth * 0.12 // Wider button for desktop
                        : isTablet
                            ? widget.screenWidth * 0.25
                            : widget.screenWidth * 0.60,
                    height: isDesktop
                        ? widget.screenHeight *
                            0.060 // Slightly taller button for desktop
                        : isTablet
                            ? widget.screenHeight * 0.075
                            : widget.screenHeight * 0.065,
                  ),
          ),
        ),
      ],
    );
  }
}
