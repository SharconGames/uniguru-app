import 'package:flutter/material.dart';
import 'package:uniguru/widgets/bottomnavigationbar.dart';
import '../widgets/star_background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/welcome');
        break;
      case 1:
        Navigator.pushNamed(context, '/createguru');
        break;
      case 2:
        Navigator.pushNamed(context, '/profilepage');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0513),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      body: Stack(
        children: [
          const StarBackground(),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.06),
                  Center(
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF664D00),
                          Color(0xFF7F6209),
                          Color(0xFFDAA520),
                          Color(0xFF664D00),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: const Text(
                        'Gurus',
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.09),
                  Center(
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF5DCFC1),
                          Color(0xFF74BDCC),
                          Color(0xFF9790DA),
                          Color(0xFF9790DA),
                          Color(0xFFAD7FDF),
                          Color(0xFF749FEE),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: const Text(
                        "Chat With Your OWN GURU",
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF85A8D3),
                            Color(0xFF8D9DD7),
                            Color(0xFF9198D9),
                            Color(0xFF9A8FDC),
                            Color(0xFFA487DE),
                            Color(0xFFAF7CE4),
                            Color(0xFFB37BE2),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        border: Border.all(color: const Color(0xFF85A8D3)),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/createguru');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.08,
                            vertical: screenHeight * 0.01,
                          ),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: const Text(
                          "Let's Begin!",
                          style: TextStyle(
                            fontFamily: 'Lexend',
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.1),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF70C0CA),
                        Color(0xFF70C0CA),
                        Color(0xFFA183E9),
                        Color(0xFFAF7CE4),
                        Color(0xFFAD7FDF),
                        Color(0xFF779BED),
                        Color(0xFF69A7EF),
                      ],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    ).createShader(bounds),
                    child: const Text(
                      "Suggested Guru's",
                      style: TextStyle(
                        fontFamily: 'Lexend',
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Adjusting the ListView
                  SizedBox(
                    height: screenHeight * 0.33, // Height for ListView
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        guruCard(
                          "Blackhole Guru",
                          "Amazing features are out of this world. This is a longer description to test overflow issues and ensure it is handled properly.",
                          'assets/robogirl1.png',
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        guruCard(
                          "AI Guru",
                          "Experience the new capabilities.",
                          'assets/robogirl1.png',
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        guruCard(
                          "Data Guru",
                          "Learn about data science and its impact.",
                          'assets/demo.jpg',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.06),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget guruCard(String title, String description, String imagePath) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.5, // Width of the card
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.35, // Set a max height for the card
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2B1736), Color(0xFF2B1736)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Set a fixed height for the image
          SizedBox(
            // height: screenHeight * 0.17, // Adjusted height for the image
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover, // Keep the aspect ratio of the image
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.01, horizontal: screenWidth * 0.03),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFF664D00),
                  Color(0xFF7F6209),
                  Color(0xFFDAA520),
                  Color(0xFF664D00),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 18, // Font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF7F9D60), Color(0xFFB44F8D)],
                ).createShader(bounds),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 12, // Font size
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis, // Handle overflow
                  maxLines: 3, // Limit the number of lines
                ),
              ),
            ),
          ),
          // Modify the "See More" button to call _showFullContent
          TextButton(
            onPressed: () {
              _showFullContent(
                  title, description, imagePath); // Call to show dialog
            },
            child: const Text(
              'See More',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullContent(String title, String description, String imagePath) {
    showDialog(
      context: context,
      barrierColor: Colors.black54, // Background blur
      builder: (BuildContext context) {
        return Dialog(
          // Remove the backgroundColor from the Dialog widget
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.7, // Adjust height
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF2B1736),
                  Color(0xFF2B1736),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // Full image at the top
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Full title with gradient
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFF664D00),
                                Color(0xFF7F6209),
                                Color(0xFFDAA520),
                                Color(0xFF664D00),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(bounds),
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontFamily: 'Lexend',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors
                                    .white, // Set color to white to see the gradient effect
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Full description with gradient
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFF664D00),
                                Color(0xFF7F6209),
                                Color(0xFFDAA520),
                                Color(0xFF664D00),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(bounds),
                            child: Text(
                              description,
                              style: const TextStyle(
                                fontFamily: 'Lexend',
                                fontSize: 16,
                                color: Colors
                                    .white, // Set color to white to see the gradient effect
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Close button with gradient
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color.fromARGB(38, 247, 247, 32),
                        Color(0xFF7F6209),
                        Color(0xFFDAA520),
                        Color.fromARGB(39, 247, 247, 32),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: const Text(
                      "Close",
                      style: TextStyle(
                          color: Colors
                              .white), // Set the text color to white for visibility
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
