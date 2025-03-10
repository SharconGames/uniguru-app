import 'package:flutter/material.dart';
import '../widgets/starScreen/star_background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // int _currentIndex = 0;

  // void _onTabTapped(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });
  //   switch (index) {
  //     case 0:
  //       Navigator.pushNamed(context, '/home');
  //       break;
  //     case 1:
  //       Navigator.pushNamed(context, '/createguru');
  //       break;
  //     // case 2:
  //     //   Navigator.pushNamed(context, '/profilepage');
  //     //   break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine if it's a tablet with a more precise check
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600 ||
        (screenWidth > 600 && screenWidth / screenHeight < 0.6);

    return Scaffold(
      backgroundColor: const Color(0xFF0E0513),
      // bottomNavigationBar: CustomBottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap: _onTabTapped,
      // ),
      body: Stack(
        children: [
          const StarBackground(),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height:
                          isTablet ? screenHeight * 0.03 : screenHeight * 0.09),
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
                      child: Text(
                        'Gurus',
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: isTablet
                              ? screenWidth * 0.055
                              : screenWidth * 0.075,
                          // fontSize: isTablet ? 28 : 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.28),
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
                      child: Text(
                        "Chat With Your OWN GURU",
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 20 : 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          isTablet ? screenHeight * 0.09 : screenHeight * 0.04),
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
                          Navigator.pushNamed(context, '/chat');
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
                  // SizedBox(
                  //     height:
                  //         isTablet ? screenHeight * 0.08 : screenHeight * 0.14),
                  // ShaderMask(
                  //   shaderCallback: (bounds) => const LinearGradient(
                  //     colors: [
                  //       Color(0xFF70C0CA),
                  //       Color(0xFF70C0CA),
                  //       Color(0xFFA183E9),
                  //       Color(0xFFAF7CE4),
                  //       Color(0xFFAD7FDF),
                  //       Color(0xFF779BED),
                  //       Color(0xFF69A7EF),
                  //     ],
                  //     begin: Alignment.centerRight,
                  //     end: Alignment.centerLeft,
                  //   ).createShader(bounds),
                  //   child: Text(
                  //     "Suggested Guru's",
                  //     style: TextStyle(
                  //       fontFamily: 'Lexend',
                  //       fontSize: isTablet ? 24 : 22,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: screenHeight * 0.02),
                  // // Adjusting the ListView
                  // SizedBox(
                  //   height: screenHeight * (isTablet ? 0.47 : 0.26),
                  //   child: ListView(
                  //     scrollDirection: Axis.horizontal,
                  //     children: [
                  //       guruCard(
                  //         "Blackhole Guru",
                  //         "Amazing features are out of this world. ",
                  //         'assets/robogirl1.png',
                  //       ),
                  //       SizedBox(width: screenWidth * 0.04),
                  //       guruCard(
                  //         "AI Guru",
                  //         "Experience the new capabilities.",
                  //         'assets/robogirl1.png',
                  //       ),
                  //       SizedBox(width: screenWidth * 0.04),
                  //       guruCard(
                  //         "Data Guru",
                  //         "Learn about data science and its impact.",
                  //         'assets/demo.jpg',
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: screenHeight * 0.06),
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

    // Determine if it's a tablet
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Container(
      width: isTablet
          ? screenWidth * 0.3
          : screenWidth * 0.53, // Preserved original phone width
      constraints: BoxConstraints(
        maxHeight: isTablet
            ? screenHeight * 0.4
            : screenHeight * 0.5, // Preserved original phone height
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
          // Image with adjusted height
          SizedBox(
            height: isTablet ? screenHeight * 0.30 : screenHeight * 0.14,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                fit: BoxFit.cover,
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
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: isTablet ? 20 : 18, // Minimal font size adjustment
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
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize:
                        isTablet ? 14 : 12, // Minimal font size adjustment
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Existing _showFullContent method remains the same
  void _showFullContent(String title, String description, String imagePath) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.7,
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
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
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
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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
                      style: TextStyle(color: Colors.white),
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
