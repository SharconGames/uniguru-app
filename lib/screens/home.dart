import 'package:flutter/material.dart';
import 'package:uniguru/widgets/bottomnavigationbar.dart';

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
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/createguru');
        break;
      case 2:
        Navigator.pushNamed(context, '/chat');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height and width for responsive design
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0513),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      body: SingleChildScrollView(
        // Added scrollable parent to prevent overflow
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
              SizedBox(height: screenHeight * 0.15),
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
              SizedBox(height: screenHeight * 0.12),
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
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // ListView inside an Expanded widget causes overflow; using SingleChildScrollView avoids this issue
              SizedBox(
                height: screenHeight * 0.25, // Set height to prevent overflow
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    guruCard(
                        "Blackhole Guru",
                        "Yes, it's amazing! The new features are out of this world.",
                        'assets/robogirl1.png'),
                    SizedBox(width: screenWidth * 0.04),
                    guruCard(
                        "AI Guru",
                        "Yes, it's amazing! The new features are out of this world.",
                        'assets/robogirl1.png'),
                    SizedBox(width: screenWidth * 0.04),
                    guruCard(
                        "AI Guru",
                        "Yes, it's amazing! The new features are out of this world.",
                        'assets/demo.jpg'),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.06),
            ],
          ),
        ),
      ),
    );
  }

  Widget guruCard(String title, String description, String imagePath) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.6,
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
          Image.asset(imagePath, fit: BoxFit.cover),
          SizedBox(height: screenHeight * 0.01),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0x0ff7f620),
                Color(0xFF7F6209),
                Color(0xFFDAA520),
                Color(0x0ff7f620),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.03),
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.001),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF7F9D60), Color(0xFFB44F8D)],
            ).createShader(bounds),
            child: Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.03, right: screenWidth * 0.05),
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
