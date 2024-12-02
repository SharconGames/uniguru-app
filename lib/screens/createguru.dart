import 'package:flutter/material.dart';
import 'package:uniguru/widgets/bottomnavigationbar.dart';
import 'package:uniguru/widgets/customtextfield.dart';

class Createguru extends StatefulWidget {
  const Createguru({super.key});

  @override
  State<Createguru> createState() => _CreateguruState();
}

class _CreateguruState extends State<Createguru> {
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
      backgroundColor: const Color(0xFF0E0513), // Background color as shown
      //bottomnavigationbar
      bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex, onTap: _onTabTapped),

      body: Padding(
        padding: EdgeInsets.all(
            screenWidth * 0.04), // Dynamic padding based on screen width
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: screenHeight *
                    0.05), // Adjust top spacing based on screen height
            Center(
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF664D00),
                    Color(0xFF7F6209), // Dark Orchid
                    Color(0xFFDAA520), // Golden Rod
                    Color(0xFF664D00)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: Text(
                  'Add your Guru',
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: screenWidth *
                        0.065, // Adjust font size based on screen width
                    fontWeight: FontWeight.bold,
                    color: Colors
                        .white, // Set to white to show the gradient effect
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01), // Adjusted spacing

            //Name Input Field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //name Label
                Text(
                  'Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth *
                        0.04, // Adjust label font size based on screen width
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01, // Adjust spacing
                ),

                //Text Field for the Name
                const CustomTextfield(
                  maxlines: 1,
                  minlines: 1,
                  placeholder: 'Guru\'s Name',
                ),

                SizedBox(height: screenHeight * 0.03), // Adjusted spacing
                //Description Label
                Text(
                  'Description',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth *
                        0.04, // Adjust font size based on screen width
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01, // Adjusted spacing
                ),
                // TextField for the  Description
                const CustomTextfield(
                  maxlines: 10,
                  minlines: 5,
                  placeholder:
                      'A customizable AI Guru with real-time adjustments. ',
                ),

                SizedBox(height: screenHeight * 0.02),
                //Subject Field
                Text(
                  'Subject',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth *
                        0.04, // Adjust font size based on screen width
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01, // Adjusted spacing
                ),

                //TextField for the subject
                const CustomTextfield(
                  maxlines: 1,
                  minlines: 1,
                  placeholder: 'Guru\'s Subject',
                ),

                SizedBox(
                  height: screenHeight *
                      0.1, // Adjusted space between textfield and button
                ),
                //Lets ask button
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
                      borderRadius: BorderRadius.circular(
                          50), // Match button's border radius
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/preference');
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.18,
                              vertical: screenHeight * 0.01), // Dynamic padding
                          backgroundColor: Colors
                              .transparent, // Set to transparent to show gradient
                          shadowColor: Colors.transparent),
                      child: Text(
                        "Lets Ask...",
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: screenWidth *
                              0.06, // Dynamic font size based on screen width
                          fontWeight: FontWeight.w600, // Make text bold
                          color: Colors.black, // Set text color to black
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
