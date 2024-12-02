import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    // Get screen height and width
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
          bottom: screenHeight * 0.02), // Padding based on screen height
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFF0E0513),
        selectedItemColor: const Color(0xFFA66DF9),
        unselectedItemColor: const Color(0xFF77B9CD),
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Colors.white,
          backgroundColor: Colors.transparent,
        ),
        currentIndex: widget.currentIndex,
        onTap: widget.onTap,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {}, // Optional: Add any specific behavior here
              child: const Icon(
                Icons.home,
                color: Color(0xFFA66DF9),
                size: 25,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/createguru');
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.02,
                        top: screenHeight * 0.02), // Adjust padding
                    child: Image.asset(
                      'assets/add.png',
                      height: screenHeight *
                          0.04, // Adjust size based on screen height
                    ),
                  ),
                ),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF59D2BF), // Teal
                      Color(0xFF74BDCC), // Aqua Blue
                      Color(0xFFB679E1), // Lavender
                      Color(0xFF9987ED), // Light Purple
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  child: const Text(
                    'Add',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/chat');
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.02), // Adjust padding
                    child: Image.asset(
                      'assets/profile.png',
                      height: screenHeight *
                          0.04, // Adjust size based on screen height
                    ),
                  ),
                ),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF59D2BF), // Teal
                      Color(0xFF74BDCC), // Aqua Blue
                      Color(0xFFB679E1), // Lavender
                      Color(0xFF9987ED), // Light Purple
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  child: const Text(
                    'Profile',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
