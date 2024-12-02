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
<<<<<<< HEAD
    return Container(
      width: width,
      height: height,
=======
    // Get the screen width and height using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adjust button size dynamically using MediaQuery
    final dynamicWidth = screenWidth * 0.8; // 80% of screen width
    final dynamicHeight = screenHeight * 0.07; // 7% of screen height

    return Container(
      width: width != 0
          ? width
          : dynamicWidth, // Use passed width or dynamic value
      height: height != 0
          ? height
          : dynamicHeight, // Use passed height or dynamic value
>>>>>>> 2a2b775 (Project)
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
<<<<<<< HEAD
=======
          overlayColor: Colors.purpleAccent.shade200,
>>>>>>> 2a2b775 (Project)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Text(
          text, // Displaying the text
          style: const TextStyle(
<<<<<<< HEAD
              color: Colors.white, fontSize: 16, fontFamily: 'Lexend'),
=======
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.bold,
          ),
>>>>>>> 2a2b775 (Project)
        ),
      ),
    );
  }
}
