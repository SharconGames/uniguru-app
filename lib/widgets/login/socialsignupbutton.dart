import 'package:flutter/material.dart';

class SocialSignupButton extends StatelessWidget {
  final String label;
  final String assetPath; // Path to the icon asset
  final VoidCallback onPressed;
  final double width; // Optional width
  final double height; // Optional height

  const SocialSignupButton({
    super.key,
    required this.label,
    required this.assetPath,
    required this.onPressed,
    this.width = 0, // Default to 0 if not specified
    this.height = 0, // Default to 0 if not specified
  });

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic width and height based on the screen size
    // final dynamicWidth = MediaQuery.of(context).size.width * 0.8;
    // final dynamicHeight = 50.0;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600 &&
        MediaQuery.of(context).size.shortestSide < 700;
    bool isMTablet = MediaQuery.of(context).size.shortestSide >= 700 &&
        MediaQuery.of(context).size.shortestSide < 1000;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final dynamicWidth =
        width ?? (isTablet ? screenWidth * 0.5 : screenWidth * 0.8);

    final dynamicHeight =
        height ?? (isTablet ? screenHeight * 0.08 : screenHeight * 0.065);

    // Dynamically scale icon and text
    final iconSize = 24 * textScaleFactor;
    final iconBg = 30 * textScaleFactor;
    final textStyle = TextStyle(
      fontSize: 22 * textScaleFactor, // Base size scaled
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'Lexend',
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: dynamicWidth,
          height: dynamicHeight,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF61ACEF), // Light Blue
                Color(0xFF9987ED), // Light Purple
                Color(0xFFB679E1), // Lavender
                Color(0xFF9791DB), // Soft Blue
                Color(0xFF74BDCC), // Aqua Blue
                Color(0xFF59D2BF), // Teal
              ],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              overlayColor: (Colors.purpleAccent.shade200),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 10 : 12,
                vertical: isTablet ? 15 : 10,
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Add a background for the icon to enhance visibility
                  Container(
                    width: iconBg,
                    height: iconBg,
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withOpacity(1.0), // Semi-transparent dark
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        assetPath,
                        height: iconSize,
                        width: iconSize,
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Space between the image and the text

                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: textStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
