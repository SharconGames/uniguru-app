import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          backgroundColor:
              Colors.transparent, // No background color for unselected
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
                // Add ShaderMask to apply gradient
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF7F6209), // Dark Orchid
                    Color(0xFFDAA520), // Golden Rod
                    Color(0xFFFFD700), // Gold (light yellow)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds), // Create the shader using the bounds
                child: const Text(
                  'Gurus',
                  style: TextStyle(
                    // Style of the text
                    fontFamily: 'Lexend',
                    fontSize: 30, // Increased font size for better visibility
                    fontWeight: FontWeight.bold,
                    color: Colors
                        .white, // Set to white to show the gradient effect
                  ),
                ),
              ),
            ),
            const SizedBox(height: 140),
            Center(
              child: ShaderMask(
                // Add ShaderMask to apply gradient
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF63C9C4),
                    Color(0xFF9790DA), // Light Cyan (Teal)
                    Color(0xFF9790DA), // Light Purple
                    Color(0xFFAD7FDF), // Intermediate Purple
                    Color(0xFF779BED), // Light Blue
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds), // Create the shader using the bounds
                child: const Text(
                  "Chat With Your OWN GURU",
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors
                        .white, // Set to white to show the gradient effect
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35), // SizedBox between text and button
            Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF86A6D4),
                      Color(0xFF9A8FDC), // Light Purple
                      Color(0xFFB47AE2),
                      Color(0xFFAF7CE4) // Intermediate Purple
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius:
                      BorderRadius.circular(50), // Match button's border radius
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    backgroundColor: Colors
                        .transparent, // Set to transparent to show gradient
                    //shape: RoundedRectangleBorder(
                    //borderRadius: BorderRadius.circular(50),
                    //),
                  ),
                  child: const Text(
                    "Let's Begin!",
                    style: TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 20,
                      fontWeight: FontWeight.bold, // Make text bold
                      color: Colors.black, // Set text color to black
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
                height: 120), // sizedbox betweeen button and suggested guru
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFF66C7C5),
                  Color(0xFF66C7C5),
                  //Color(0xFF49D0B9), // Dark Cyan
                  Color(0xFF9790DA), // Light Cyan (Teal)
                  Color(0xFF9790DA), // Light Purple
                  Color(0xFFAD7FDF), // Intermediate Purple
                  Color(0xFF779BED), // Light Blue
                ],
                begin: Alignment.centerRight, // Start from the right
                end: Alignment.centerLeft, // End at the left
              ).createShader(bounds),
              child: const Text(
                "Suggested Guru's",
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 30,
                  fontWeight: FontWeight.bold, // Make text bold
                  color: Colors.white, // Set to white to let the gradient show
                ),
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  guruCard("Blackhole Guru",
                      "Yes, it's amazing! The new features are out of this world."),
                  const SizedBox(width: 16),
                  guruCard("AI Guru",
                      "Yes, it's amazing! The new features are out of this world."),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget guruCard(String title, String description) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2B1736), Color(0xFF2B1736)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      //padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/robogirl1.png',
              fit: BoxFit.cover), // Replace with your image
          const SizedBox(height: 10),
          //Blackhole text
          ShaderMask(
            // Add ShaderMask to apply gradient
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFF7F6209), // Dark Orchid
                Color(0xFFDAA520), // Golden Rod
                Color(0xFFFFD700), // Gold (light yellow)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds), // Create the shader using the bounds
            child: Padding(
              padding: const EdgeInsets.only(left: 11),
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 1),

          //Text Under the image
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFF7F9D60),
                Color(0xFFB44F8D),
              ],
            ).createShader(bounds),
            child: Padding(
              padding: const EdgeInsets.only(left: 11, right: 20),
              child: Text(
                description,
                style: const TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
