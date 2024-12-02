import 'package:flutter/material.dart';
import 'package:uniguru/widgets/dropdown.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0513),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
              height: screenheight *
                  0.15), // Space at the top for better positioning

          // Row for the circleavatar, heading, and setting
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

              //DropDown List
              CustomDropdown(
                  assetPath: 'assets/spritual_light.png',
                  items: users,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedUsers = newValue;
                    });
                  },
                  hint: 'BlackHole Guru'),

              // Setting Button
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
          const SizedBox(height: 10),

          // Container for First text
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Container(
              height: 69,
              width: 269,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFF2B1736), Color(0xFF2B1736)]),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(colors: [
                    Color(0xFF5CBEB7), // Teal
                    Color(0xFF74BDCC), // Aqua Blue
                    Color(0xFF9791DB), // Soft Blue
                    Color(0xFFB679E1), // Lavender
                    Color(0xFF9987ED), // Light Purple
                    Color(0xFF61ACEF), // Light Blue
                  ]).createShader(bounds),
                  child: const Text(
                    'Hey everyone, did you see the new AI update?',
                    style: TextStyle(fontFamily: 'Lexend'),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),

          // Container for second text
          Padding(
            padding: const EdgeInsets.only(right: 60),
            child: Container(
              height: 75,
              width: 269,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFF00655D), // Light Blue
                    Color(0xFF374564), // Light Purple
                    Color(0xFF4C316A), // Lavender
                    Color(0xFF44356F), // Soft Blue
                    Color(0xFF284675), // Aqua Blue
                    // Color(0xFF59D2BF), // Teal
                  ]),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Yes, it’s amazing! The new features are out of this world.',
                  style: TextStyle(fontFamily: 'Lexend', color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
              height:
                  screenheight * 1.260), // Adding space before the TextField

          // "Ask Your Guru" chat positioned at the bottom of the screen
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  width: screenwidth * 0.67,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF18141C),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      children: [
                        // if (!isTyping) //Show "ASk Your " only if not typing
                        //   const Padding(
                        //     padding: EdgeInsets.only(left: 20),
                        //     child: Text(
                        //       'Ask Your',
                        //       style: TextStyle(
                        //           color: Color(0xFF4C4C50), fontSize: 16),
                        //     ),
                        //   ),
                        //SizedBox(width: 1),
                        Expanded(
                          // Make the TextField take the remaining space
                          child: ShaderMask(
                            shaderCallback: (bounds) =>
                                const LinearGradient(colors: [
                              Color(0xFF61ACEF), // Light Blue
                              Color(0xFF9987ED), // Light Purple
                              Color(0xFFB679E1), // Lavender
                              Color(0xFF9791DB), // Soft Blue
                              Color(0xFf4CAEF5)
                            ]).createShader(bounds),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: TextField(
                                controller: _textEditingController,
                                decoration: const InputDecoration(
                                  hintText: ' Ask Your Guru..',
                                  hintStyle: TextStyle(
                                    color:
                                        Colors.grey, // Color for the hint text
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none, // Remove the border
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, // Adjust vertical padding
                                    horizontal: 5, // Adjust horizontal padding
                                  ),
                                ),
                                style: const TextStyle(
                                  color:
                                      Colors.white, // Color of the input text
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
                const SizedBox(
                  width: 10,
                ),
                // IconButton for voice
                SizedBox(
                  height: 35,
                  width: 35,
                  child: Image.asset('assets/voice_light.png'),
                ),
                // IconButton for send
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Image.asset('assets/send_light.png'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
