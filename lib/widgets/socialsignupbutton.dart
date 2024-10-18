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
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Image.asset(
        assetPath,
        height: 24,
        width: 24,
      ),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white, // Change text color to white for contrast
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            const Color(0xFF403B4D), // Dark background color with transparency
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}
