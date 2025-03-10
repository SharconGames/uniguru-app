// toggle_component.dart
import 'package:flutter/material.dart';

class LoginSignupToggle extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onLoginTap;
  final VoidCallback onSignupTap;
  final double screenWidth;
  final bool isTablet;

  const LoginSignupToggle({
    super.key,
    required this.isLogin,
    required this.onLoginTap,
    required this.onSignupTap,
    required this.screenWidth,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    // Get text scale factor and determine if it's desktop
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isDesktop = MediaQuery.of(context).size.width >= 1024;
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600 ||
        (screenWidth > 600 && screenWidth / screenHeight < 2.0);

    // Responsive text sizing
    double calculateFontSize(double baseSize) {
      return isDesktop
          ? screenWidth * 0.013
          : isTablet
              ? screenWidth * 0.020
              : baseSize * (textScaleFactor > 1.0 ? 0.7 : 1.0);
    }

    // Responsive container dimensions
    double calculateContainerWidth(double baseWidth) {
      return isDesktop
          ? screenWidth * 0.08
          : isTablet
              ? (textScaleFactor > 1.0 ? baseWidth * 1.2 : baseWidth)
              : baseWidth;
    }

    double calculateContainerHeight(double baseHeight) {
      return isDesktop
          ? screenHeight * 0.05
          : isTablet
              ? baseHeight
              : baseHeight * 0.9;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            if (!isLogin) onLoginTap();
          },
          child: Container(
            height: calculateContainerHeight(isTablet ? 50 : 40),
            width: calculateContainerWidth(isTablet ? 90 : 100),
            decoration: BoxDecoration(
              color:
                  isLogin ? Colors.white.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: calculateFontSize(screenWidth * 0.045),
                    color: isLogin ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: isDesktop ? screenWidth * 0.03 : screenWidth * 0.05),
        GestureDetector(
          onTap: () {
            if (isLogin) onSignupTap();
          },
          child: Container(
            height: calculateContainerHeight(isTablet ? 50 : 40),
            width: calculateContainerWidth(isTablet ? 120 : 100),
            decoration: BoxDecoration(
              color:
                  !isLogin ? Colors.white.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: calculateFontSize(screenWidth * 0.045),
                    color: !isLogin ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
