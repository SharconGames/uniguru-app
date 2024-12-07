import 'package:flutter/material.dart';

class SocialSignupButton extends StatelessWidget {
  final String label;
  final String assetPath; // Path to the icon asset
  final VoidCallback onPressed;

  const SocialSignupButton({
    super.key,
    required this.label,
    required this.assetPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent, // Make the button transparent
        elevation: 0, // Remove elevation to ensure flat appearance
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: BorderSide(
              color: Colors.white.withOpacity(0.5)), // Optional: Add a border
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            assetPath,
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 12), // Space between the image and the text
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16,
                  color:
                      Colors.white, // Change text color to white for contrast
                  fontFamily: 'Lexend'),
            ),
          ),
        ],
      ),
    );
  }
}
