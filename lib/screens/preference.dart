import 'package:flutter/material.dart';
import 'package:uniguru/widgets/dropdown.dart';
import 'package:uniguru/widgets/star_background.dart'; // Import your StarBackground widget here

class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({super.key});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  int _currentIndex = 0;

  String? selectedUsers;
  List<String> users = [
    "Blackhole Guru",
    "AI Guru",
    "Robot Guru",
    "Human Guru",
    "Khol Guru"
  ];

  final TextEditingController _textEditingController = TextEditingController();
  bool isTyping = false; // typing state

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      setState(() {
        isTyping = _textEditingController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenPadding =
        MediaQuery.of(context).padding.top; // Get status bar height

    return Scaffold(
      backgroundColor: const Color(0xFF0D0513),
      body: Stack(
        children: [
          // Star background
          StarBackground(), // Add the StarBackground widget here

          // Main content
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight *
                    0.1, // Adjusting space at the top for status bar
              ),
              // Row for the CircleAvatar, heading, and settings button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // CircleAvatar
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: () {}, // OnTap for the circle avatar
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.asset('assets/spritual_light.png'),
                      ),
                    ),
                  ),
                  // BlackHole Guru Name
                  // DropDown List
                  CustomDropdown(
                    assetPath: 'assets/spritual_light.png',
                    selectedValue: selectedUsers,
                    items: users,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedUsers = newValue;
                      });
                    },
                    hint: 'BlackHole Guru',
                  ),
                  // Settings Button
                  GestureDetector(
                    onTap: () {}, // OnTap for the settings button
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset('assets/setting_light.png'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight *
                    0.2, // Adjusting space between name and container
              ),
              // Container for the preference
              Container(
                height: screenHeight * 0.3, // Adjusting the container height
                width: screenWidth * 0.75, // Adjusting the container width
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2B1736), Color(0xFF2B1736)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Center(
                      // Text "Select Your Preference"
                      child: Text(
                        'Select Your Preference',
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                    // "Let's Chat" button
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF8AA2D5),
                              Color(0xFF9A8FDC),
                              Color(0xFFB47AE2),
                              Color(0xFFAF7CE4),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/chat');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 13),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: const Text(
                            "Lets Chat...",
                            style: TextStyle(
                              fontFamily: 'Lexend',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 40),
                              child: Divider(
                                color: Color(0xFF454A6E),
                                thickness: 1.0,
                                endIndent: 5.0,
                              ),
                            ),
                          ),
                          Text(
                            'OR',
                            style: TextStyle(
                              color: Color(0xFf524D5D),
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: 40),
                              child: Divider(
                                color: Color(0xFF454A6E),
                                thickness: 1.0,
                                indent: 5.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // "Let's Talk" button
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF8AA2D5),
                              Color(0xFF9A8FDC),
                              Color(0xFFB47AE2),
                              Color(0xFFAF7CE4),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/chat');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 13),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: const Text(
                            "Lets Talk...",
                            style: TextStyle(
                              fontFamily: 'Lexend',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2)
                  ],
                ),
              ),
              SizedBox(
                height:
                    screenHeight * 0.24, // Adjusting space before the TextField
              ),
              // "Ask Your Guru" chat positioned at the bottom of the screen
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      width: screenWidth *
                          0.7, // Adjusted TextField width to avoid overflow
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF18141C),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(colors: [
                                  Color(0xFF61ACEF),
                                  Color(0xFF9987ED),
                                  Color(0xFFB679E1),
                                  Color(0xFF9791DB),
                                  Color(0xFf4CAEF5)
                                ]).createShader(bounds),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: TextField(
                                    controller: _textEditingController,
                                    decoration: const InputDecoration(
                                      hintText: ' Ask Your Guru..',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 5,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 1),
                    // IconButton for voice
                    SizedBox(
                      height: 35,
                      width: 35,
                      child: Image.asset('assets/voice_light.png'),
                    ),
                    // // IconButton for send
                    // GestureDetector(
                    //   onTap: _sendMessage,
                    //   child: SizedBox(
                    //     height: 40,
                    //     width: 40,
                    //     child: Image.asset('assets/send_light.png'),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
