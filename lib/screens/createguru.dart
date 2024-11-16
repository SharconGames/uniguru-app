import 'package:flutter/material.dart';

class Createguru extends StatelessWidget {
  const Createguru({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0513), // Background color as shown
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0E0513), // Match the background color
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
        ),
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color(0xFFA66DF9),
              size: 40,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(colors: [
                Color(0xFF77B8CD),
                Color(0xFF9395D9),
              ]).createShader(bounds),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 50,
              ),
            ),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(colors: [
                Color(0xFFA982DB),
                Color(0xFF7C9AEE),
                Color(0xFF74A0E6)
              ]).createShader(bounds),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 40,
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Center(
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF7F6209), // Dark Orchid
                    Color(0xFFDAA520), // Golden Rod
                    Color(0xFFFFD700), // Gold (light yellow)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: const Text(
                  'Gurus',
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 30, // Increased font size for better visibility
                    fontWeight: FontWeight.bold,
                    color: Colors
                        .white, // Set to white to show the gradient effect
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
