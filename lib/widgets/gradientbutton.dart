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
    return Container(
      width: width,
      height: height,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Text(
          text, // Displaying the text
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
