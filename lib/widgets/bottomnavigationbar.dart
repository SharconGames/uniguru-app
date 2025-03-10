import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isCreateGuruPage;
  final double? homeIconPadding; // New optional parameter

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isCreateGuruPage = false,
    this.homeIconPadding,
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

    // Determine if it's a tablet based on screen width and aspect ratio
    bool isTablet = screenWidth > 600 && screenWidth / screenHeight < 0.6;

    // Responsive sizing calculations
    double iconSize = isTablet ? 36 : 26;
    double labelFontSize = isTablet ? 16 : 12;

    // Adjust vertical positioning for icons and labels
    double iconVerticalPadding = isTablet
        ? screenHeight * 0.02 // More space for tablets
        : screenHeight * 0.02; // Keep phone layout

    double labelVerticalPadding = isTablet
        ? screenHeight * 0.01 // Less space between icon and label for tablets
        : screenHeight * 0.005; // Keep phone layout

    double homeIconPadding = widget.homeIconPadding ??
        (widget.isCreateGuruPage
            ? screenWidth * 0.15 // More space when only 2 buttons
            : screenWidth * 0.03); // Original spacing for 3 buttons

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.001),
          child: BottomNavigationBar(
            backgroundColor: const Color(0xFF0E0513),
            selectedItemColor: const Color(0xFFA66DF9),
            unselectedItemColor: const Color(0xFF77B9CD),
            showUnselectedLabels: true,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: labelFontSize,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: labelFontSize,
              backgroundColor: Colors.transparent,
            ),
            currentIndex: widget.currentIndex,
            onTap: widget.onTap,
            items: widget.isCreateGuruPage
                ? <BottomNavigationBarItem>[
                    // Home Navigation Item
                    BottomNavigationBarItem(
                      icon: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: homeIconPadding,
                                  top: iconVerticalPadding),
                              child: ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFF59D2BF), // Teal
                                    Color(0xFF74BDCC), // Aqua Blue
                                    Color(0xFFB679E1), // Lavender
                                    Color(0xFF9987ED), // Light Purple
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ).createShader(bounds),
                                blendMode: BlendMode.srcIn,
                                child: Icon(
                                  Icons.home,
                                  color: Colors.white,
                                  size: iconSize,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: labelVerticalPadding),
                              child: ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFF59D2BF), // Teal
                                    Color(0xFF74BDCC), // Aqua Blue
                                    Color(0xFFB679E1), // Lavender
                                    Color(0xFF9987ED), // Light Purple
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ).createShader(bounds),
                                child: Text(
                                  'Home',
                                  style: TextStyle(
                                    fontSize: labelFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      label: '', // Hide default label
                      tooltip: '', // Remove default tooltip
                    ),

                    // Profile Navigation Item
                    BottomNavigationBarItem(
                      icon: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/profilepage');
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: isTablet
                                    ? screenWidth * 0.15
                                    : screenWidth * 0.001,
                                top: iconVerticalPadding,
                              ),
                              child: Icon(
                                Icons.construction, // Tool icon
                                size: isTablet
                                    ? screenHeight *
                                        0.045 // Slightly larger for tablets
                                    : screenHeight * 0.025,
                                color:
                                    Color(0xFFB679E1), // Adjust color as needed
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: labelVerticalPadding),
                            child: ShaderMask(
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
                              child: Text(
                                'Tools',
                                style: TextStyle(
                                  fontSize: labelFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      label: '',
                    ),
                  ]
                : <BottomNavigationBarItem>[
                    // Home Navigation Item (Original 3-button version)
                    BottomNavigationBarItem(
                      icon: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: screenWidth * 0.002,
                                  top: iconVerticalPadding),
                              child: ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFF59D2BF), // Teal
                                    Color(0xFF74BDCC), // Aqua Blue
                                    Color(0xFFB679E1), // Lavender
                                    Color(0xFF9987ED), // Light Purple
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ).createShader(bounds),
                                blendMode: BlendMode.srcIn,
                                child: Icon(
                                  Icons.home,
                                  color: Colors.white,
                                  size: iconSize,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: labelVerticalPadding),
                              child: ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFF59D2BF), // Teal
                                    Color(0xFF74BDCC), // Aqua Blue
                                    Color(0xFFB679E1), // Lavender
                                    Color(0xFF9987ED), // Light Purple
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ).createShader(bounds),
                                child: Text(
                                  'Home',
                                  style: TextStyle(
                                    fontSize: labelFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      label: '', // Hide default label
                      tooltip: '', // Remove default tooltip
                    ),

                    // Add Guru Navigation Item
                    // BottomNavigationBarItem(
                    //   icon: Column(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       GestureDetector(
                    //         onTap: () {
                    //           Navigator.pushNamed(context, '/createguru');
                    //         },
                    //         child: Padding(
                    //           padding: EdgeInsets.only(
                    //             left: isTablet
                    //                 ? screenWidth * 0.02
                    //                 : screenWidth * 0.008,
                    //             top: iconVerticalPadding,
                    //           ),
                    //           child: Image.asset(
                    //             'assets/add.png',
                    //             height: isTablet
                    //                 ? screenHeight *
                    //                     0.04 // Slightly larger for tablets
                    //                 : screenHeight * 0.023,
                    //           ),
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: EdgeInsets.only(top: labelVerticalPadding),
                    //         child: ShaderMask(
                    //           shaderCallback: (bounds) => const LinearGradient(
                    //             colors: [
                    //               Color(0xFF59D2BF), // Teal
                    //               Color(0xFF74BDCC), // Aqua Blue
                    //               Color(0xFFB679E1), // Lavender
                    //               Color(0xFF9987ED), // Light Purple
                    //             ],
                    //             begin: Alignment.topCenter,
                    //             end: Alignment.bottomCenter,
                    //           ).createShader(bounds),
                    //           child: Text(
                    //             'Add',
                    //             style: TextStyle(
                    //               fontSize: labelFontSize,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //   label: '',
                    // ),

                    // Profile Navigation Item
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
                                left: isTablet
                                    ? screenWidth * 0.015
                                    : screenWidth * 0.005,
                                top: iconVerticalPadding,
                              ),
                              child: Image.asset(
                                'assets/add.png',
                                height: isTablet
                                    ? screenHeight *
                                        0.045 // Slightly larger for tablets
                                    : screenHeight * 0.025,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: labelVerticalPadding),
                            child: ShaderMask(
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
                              child: Text(
                                'Add Guru',
                                style: TextStyle(
                                  fontSize: labelFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      label: '',
                    ),
                  ],
          ),
        ),
      ],
    );
  }
}
