import 'package:flutter/material.dart';
import 'package:uniguru/widgets/dropdown.dart';
import 'package:uniguru/widgets/star_background.dart'; // Adjust the import based on your project structure

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _currentIndex = 0;
  String? selectedUsers; // Store the selected user here
  List<String> users = [
    "Blackhole Guru",
    "AI Guru",
    "Robot Guru",
    "Human Guru",
    "Khol Guru"
  ];

  final TextEditingController _textEditingController = TextEditingController();
  bool isTyping = false; // typing state
  List<String> messages = [
    'Hey everyone, did you see the new AI update?',
    'Yes, it’s amazing! The new features are out of this world.',
  ]; // List to store chat messages

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

  void _sendMessage() {
    // Get the message from the text field
    String message = _textEditingController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        messages.add(message); // Add message to the list
        _textEditingController.clear(); // Clear the text field
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background widget
          const StarBackground(),

          // Main content
          Column(
            children: [
              SizedBox(
                height: screenheight *
                    0.08, // Space at the top for better positioning
              ),
              // Row for the CircleAvatar, heading, and settings
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

                  // DropDown List
                  CustomDropdown(
                    assetPath: 'assets/spritual_light.png',
                    items: users,
                    selectedValue:
                        selectedUsers, // Ensure the selected value is passed
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedUsers = newValue; // Update the selected user
                      });
                    },
                    hint: 'BlackHole Guru',
                  ),

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

              // Existing Messages
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 5),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color(0xFF00655D), // Light Blue
                            Color(0xFF374564), // Light Purple
                            Color(0xFF4C316A), // Lavender
                            Color(0xFF44356F), // Soft Blue
                            Color(0xFF284675), // Aqua Blue
                          ]),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            messages[index],
                            style: const TextStyle(
                                fontFamily: 'Lexend', color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Chat input area at the bottom of the screen
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, top: 15, bottom: 15),
                  child: Row(
                    children: [
                      Expanded(
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
                                      const LinearGradient(
                                    colors: [
                                      Color(0xFF61ACEF),
                                      Color(0xFF9987ED),
                                      Color(0xFFB679E1),
                                      Color(0xFF9791DB),
                                      Color(0xFf4CAEF5),
                                    ],
                                  ).createShader(bounds),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: TextField(
                                      controller: _textEditingController,
                                      onSubmitted: (_) => _sendMessage(),
                                      decoration: const InputDecoration(
                                        hintText: 'Ask Your Guru..',
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 5),
                                      ),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
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
                      GestureDetector(
                        onTap: () {},
                        child: SizedBox(
                          height: 35,
                          width: 35,
                          child: Image.asset('assets/voice_light.png'),
                        ),
                      ),
                      const SizedBox(width: 5),
                      // IconButton for send
                      GestureDetector(
                        onTap: _sendMessage,
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset('assets/send_light.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
