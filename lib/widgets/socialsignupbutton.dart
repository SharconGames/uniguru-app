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
<<<<<<< HEAD
=======
    // Get the screen width and height using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

>>>>>>> 2a2b775 (Project)
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF403B4D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
<<<<<<< HEAD
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
=======
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth *
              0.05, // Adjusting horizontal padding based on screen width
          vertical: screenHeight *
              0.015, // Adjusting vertical padding based on screen height
        ),
>>>>>>> 2a2b775 (Project)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            assetPath,
<<<<<<< HEAD
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 12), // Space between the image and the text
=======
            height:
                screenHeight * 0.03, // Adjust icon size based on screen height
            width:
                screenHeight * 0.03, // Adjust icon size based on screen height
          ),
          SizedBox(
              width: screenWidth *
                  0.03), // Adjust space between the image and the text based on screen width
>>>>>>> 2a2b775 (Project)
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
<<<<<<< HEAD
              style: const TextStyle(
                  fontSize: 16,
                  color:
                      Colors.white, // Change text color to white for contrast
                  fontFamily: 'Lexend'),
=======
              style: TextStyle(
                fontSize: screenWidth *
                    0.04, // Adjust font size based on screen width
                color: Colors.white,
                fontFamily: 'Lexend',
              ),
>>>>>>> 2a2b775 (Project)
            ),
          ),
        ],
      ),
    );
  }
}
