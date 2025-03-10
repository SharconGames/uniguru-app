import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text; // Required text parameter
  final VoidCallback onPressed; // Required callback
  final double width; // Required width parameter
  final double height; // Required height parameter

  const GradientButton({
    super.key,
    required this.text, // 'text' is required
    required this.onPressed, // 'onPressed' is required
    required this.width, // Make width required
    required this.height, // Make height required
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600 ||
        (screenWidth > 600 && screenWidth / screenHeight < 0.6);

    final dynamicWidth = width ?? screenWidth * 0.8;
    final dynamicHeight = height ?? screenHeight * 0.07;

    double calculateFontSize() {
      // Base font size with scaling
      double baseFontSize = isTablet ? 18 : 16;

      // Adjust font size based on text scale factor
      if (textScaleFactor > 1.0) {
        return baseFontSize * 0.8; // Reduce size for larger scale factors
      }

      return baseFontSize * textScaleFactor;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: dynamicWidth, // Use passed width or dynamic value
          height: dynamicHeight, // Use passed height or dynamic value
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
              overlayColor: Colors.purpleAccent.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text, // Displaying the text
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isTablet ? 18 : 20,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }
}
