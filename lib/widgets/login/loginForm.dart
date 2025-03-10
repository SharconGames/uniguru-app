import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uniguru/context/AppCommunicator.dart';
// import 'package:logging/logging.dart';
import 'package:uniguru/context/AuthNotifier.dart';
import 'package:uniguru/screens/chat.dart';
import 'package:uniguru/widgets/gradientbutton.dart';
import 'package:uniguru/widgets/login/socialsignupbutton.dart';
import 'package:uniguru/widgets/starScreen/StarBackgroundWrapper.dart';
import 'package:uniguru/widgets/utils/errorDialog.dart';

class LoginForm extends ConsumerStatefulWidget {
  final TextEditingController emailcontroller;
  final TextEditingController passwordcontroller;
  final bool isLoading;
  final double screenWidth;
  final double screenHeight;

  const LoginForm({
    super.key,
    required this.emailcontroller,
    required this.passwordcontroller,
    required this.isLoading,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final logger = Logger(
    printer: PrettyPrinter(), // This configures the logger to use PrettyPrinter
  );
  bool _isPasswordVisible = false;

  bool isNotvalidate = false;
  bool _isLoading = false;
  String errorMessage = "";

  // Email validation method
  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  // Login function
  void _loginUser() async {
    setState(() {
      errorMessage = "";
      _isLoading = true;
    });

    try {
      if (!_isValidEmail(widget.emailcontroller.text)) {
        _showErrorDialog("Invalid email format");
        return;
      }

      await ref.read(authStateProvider.notifier).login(
            widget.emailcontroller.text.trim(),
            widget.passwordcontroller.text,
          );

      if (!mounted) return;

      final authState = ref.read(authStateProvider);

      if (authState.isLoggedIn && authState.navigateUrl != null) {
        logger.wtf("Navigating to: ${authState.navigateUrl}");

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
      print("Login error: $e");
      _showErrorDialog("An error occurred during login");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Google Login
  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    try {
      final sMessenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Call the signInWithGoogle from AuthNotifier
      await ref.read(authStateProvider.notifier).signInWithGoogle(context);

      // If the sign-in is successful, check for chat session
      final authState = ref.read(authStateProvider);

      if (authState.user != null) {
        final userId = authState.user?.id ?? '';
        final selectedGuru = authState.selectedGuru;

        if (userId.isNotEmpty && selectedGuru != null) {
          // Fetch or create new chat session
          print('User ID: $userId, Selected Guru ID: ${selectedGuru.id}');

          // Check if the user already has a chat session
          String chatId = authState.user?.chatId ?? '';
          String chatbotId = authState.user?.chatbotId ?? selectedGuru.id;

          if (chatId.isEmpty) {
            print('No existing chat session found. Creating a new one...');
            final newChatSession = await ApiCommunicator.startNewChatSession(
              userId: userId,
              chatbotId: selectedGuru.id,
              createNewSession: true,
            );

            chatId = newChatSession['chatId'] ?? '';
            print('New Chat Session ID: $chatId');
          }

          final navigateUrl =
              authState.navigateUrl ?? '/${selectedGuru.name}/c/$chatId';
          print('Navigate URL: $navigateUrl');

          // Navigate to the chat screen
          navigator.pushReplacement(MaterialPageRoute(
            builder: (context) => StarBackgroundWrapper(
              child: ChatScreen(
                navigateUrl: navigateUrl,
                chatId: chatId,
                chatbotId: chatbotId,
              ),
            ),
          ));
        } else {
          sMessenger.showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xFF2B1736),
              content: Text(
                'Failed to retrieve user or Guru details',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      } else {
        sMessenger.showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: Color(0xFF2B1736),
            content: Text(
              'Sign-in failed',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }

    // Web platform handling
    if (kIsWeb) {
      try {
        final navigator = Navigator.of(context);
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        // Sign in the user with Google
        await ref.read(authStateProvider.notifier).signInWithGoogle(context);

        final authState = ref.read(authStateProvider);

        // Close initial loading indicator
        if (context.mounted) {
          Navigator.pop(context);
        }

        if (authState.isLoggedIn && authState.user != null) {
          final userId = authState.user?.id;
          final selectedGuru = authState.selectedGuru;

          if (userId == null || selectedGuru == null) {
            throw Exception('User ID or Guru not found');
          }

          // Show loading for chat session creation
          if (context.mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          }

          // Create a new chat session
          final newChatSession = await ApiCommunicator.startNewChatSession(
            userId: userId,
            chatbotId: selectedGuru.id,
            createNewSession: true,
          );

          if (newChatSession['chatId'] != null) {
            final String newChatId = newChatSession['chatId'];
            final String navigateUrl = '/${selectedGuru.name}/c/$newChatId';

            // Close the loading dialog
            if (context.mounted) {
              Navigator.pop(context);
            }

            // Navigate to the new chat session screen
            if (context.mounted) {
              navigator.pushReplacement(MaterialPageRoute(
                builder: (context) => StarBackgroundWrapper(
                  child: ChatScreen(
                    navigateUrl: navigateUrl,
                    chatId: newChatId,
                    chatbotId: selectedGuru.id,
                  ),
                ),
              ));
            }

            scaffoldMessenger.showSnackBar(
              const SnackBar(content: Text('Sign-in successful!')),
            );
          } else {
            throw Exception('Failed to create chat session');
          }
        } else {
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Sign-in failed. Please try again.')),
          );
        }
      } catch (e) {
        // Make sure to close any open loading dialogs
        if (context.mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  // Error dialog method
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(message: message);
      },
    );
  }

  //Input Field for the login and signup
  Widget _buildInputField({
    String label = '',
    required String hint,
    required String iconPath,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    // bool isTablet = MediaQuery.of(context).size.shortestSide >= 600 &&
    //     MediaQuery.of(context).size.shortestSide < 700;

    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600 ||
        (widget.screenWidth > 600 &&
            widget.screenWidth / widget.screenHeight < 2.0);
    bool isMTablet = MediaQuery.of(context).size.shortestSide >= 700 &&
        MediaQuery.of(context).size.shortestSide < 1000;
    bool isDesktop = MediaQuery.of(context).size.width >= 1024;
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
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            //
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
          // label: 'Email',
          controller: widget.emailcontroller,
          hint: 'Enter your email address',
          iconPath: 'assets/email.png',
        ),
        SizedBox(height: widget.screenHeight * 0.028),
        _buildInputField(
          // label: 'Password',
          controller: widget.passwordcontroller,
          hint: 'Enter your password',
          iconPath: 'assets/password.png',
          isPassword: true,
        ),
        if (errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
        SizedBox(height: widget.screenHeight * 0.04),
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
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : GradientButton(
                    text: 'Login',
                    onPressed: _loginUser,
                    width: isDesktop
                        ? widget.screenWidth * 0.12 // Wider button for desktop
                        : isTablet
                            ? widget.screenWidth * 0.25
                            : widget.screenWidth * 0.60,
                    height: isDesktop
                        ? widget.screenHeight *
                            0.060 // Slightly taller button for desktop
                        : isTablet
                            ? widget.screenHeight * 0.060
                            : widget.screenHeight * 0.065,
                  ),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () {},
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        SizedBox(height: widget.screenHeight * 0.024),
        Padding(
          padding: EdgeInsets.symmetric(vertical: widget.screenHeight * 0.01),
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                  indent: isDesktop
                      ? widget.screenWidth * 0.30 // More indent for desktop
                      : isTablet
                          ? widget.screenWidth * 0.08
                          : widget.screenWidth * 0.00,
                  endIndent: widget.screenWidth * 0.02,
                ),
              ),
              Text(
                'OR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isDesktop
                      ? widget.screenWidth *
                          0.013 // Slightly smaller text for desktop
                      : isTablet
                          ? widget.screenWidth * 0.017
                          : widget.screenWidth * 0.045,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                  indent: widget.screenWidth * 0.02,
                  endIndent: isDesktop
                      ? widget.screenWidth * 0.30 // More indent for desktop
                      : isTablet
                          ? widget.screenWidth * 0.08
                          : widget.screenWidth * 0.00,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: widget.screenHeight * 0.02),
        Center(
          child: SizedBox(
            width: isDesktop
                ? widget.screenWidth * 0.12 // Wider for desktop
                : isTablet
                    ? widget.screenWidth * 0.179
                    : widget.screenWidth * 0.55,
            height: isDesktop
                ? widget.screenHeight * 0.060 // Slightly taller for desktop
                : isTablet
                    ? widget.screenHeight * 0.065
                    : widget.screenHeight * 0.065,
            child: SocialSignupButton(
              label: 'SignUp with Google',
              assetPath: 'assets/icons8-google-36.png',
              onPressed: () => signInWithGoogle(ref, context),
            ),
          ),
        ),
        SizedBox(height: widget.screenHeight * 0.02),
      ],
    );
  }
}
