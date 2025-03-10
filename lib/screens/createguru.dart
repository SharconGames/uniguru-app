import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uniguru/context/AppCommunicator.dart';
import 'package:uniguru/context/AuthNotifier.dart';
import 'package:uniguru/screens/chat.dart';
import 'package:uniguru/widgets/starScreen/StarBackgroundWrapper.dart';
import 'package:uniguru/widgets/utils/customtextfield.dart';
import 'package:uniguru/widgets/utils/errorDialog.dart';
import 'package:uniguru/widgets/utils/successDialog.dart';

class Createguru extends ConsumerStatefulWidget {
  const Createguru({super.key});

  @override
  ConsumerState<Createguru> createState() => _CreateguruState();
}

class _CreateguruState extends ConsumerState<Createguru> {
  final int _currentIndex = 0;
  bool _isLoading = false;
  String errorMessage = "";

  void _createGuru() async {
    if (namecontroller.text.isEmpty ||
        descriptioncontroller.text.isEmpty ||
        subjectcontroller.text.isEmpty) {
      _showErrorDialog("Please fill in all fields");
      return;
    }

    setState(() {
      _isLoading = true;
      errorMessage = "";
    });

    try {
      final authState = ref.read(authStateProvider);

      if (!authState.isLoggedIn || authState.user?.id == null) {
        throw Exception('User not logged in');
      }

      final newGuru = Guru(
        name: namecontroller.text.trim(),
        description: descriptioncontroller.text.trim(),
        subject: subjectcontroller.text.trim(),
        id: '',
        userId: authState.user!.id,
        chats: [], // Initialize with empty chats list
      );

      // Create the guru
      final createdGuruData = await ApiCommunicator.createNewGuru(
          newGuru.toJson(), authState.user!.id);

      // Detailed logging
      print("Full API Response: $createdGuruData");

      // Safely extract chatbot data+

      dynamic chatbotData = createdGuruData['chatbot'];

      // Ensure chatbot data is a Map<String, dynamic>
      Map<String, dynamic> chatbotMap;

      if (createdGuruData['chatbot'] is Map) {
        final newGuru = Guru.fromJson(
            Map<String, dynamic>.from(createdGuruData['chatbot']));

        final authState = ref.read(authStateProvider);
        final updatedGurus = [...authState.gurus, newGuru];

        ref.read(authStateProvider.notifier).state = authState.copyWith(
          gurus: updatedGurus,
          selectedGuru: newGuru,
        );

        chatbotMap = Map<String, dynamic>.from(createdGuruData['chatbot']);
      } else if (createdGuruData['chatbot'] is String) {
        chatbotMap = json.decode(createdGuruData['chatbot']);
      } else {
        throw Exception('Invalid chatbot data format');
      }

      // Create Guru instance with robust parsing
      final createdGuru = Guru.fromJson(chatbotMap);

      // Validate required fields
      if (!chatbotMap.containsKey('name') ||
          !chatbotMap.containsKey('description') ||
          !chatbotMap.containsKey('subject')) {
        throw Exception('Missing required guru fields');
      }

      // Create Guru instance

      // Update state
      final updatedGurus = [...authState.gurus, createdGuru];
      ref.read(authStateProvider.notifier).state = authState.copyWith(
        gurus: updatedGurus,
        selectedGuru: createdGuru,
      );

      // Clear form and reset UI
      namecontroller.clear();
      descriptioncontroller.clear();
      subjectcontroller.clear();

      setState(() {
        _isLoading = false;
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFF2B1736),
            title: const Text(
              'Success!',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text('Guru is being created Successfully'),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9987ED),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Continue',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          );
        },
      );

      // Navigate to chat page
      if (mounted) {
        final navigateUrl = createdGuruData['navigateUrl'] ?? '';
        final chatId = createdGuruData['chatId'] ?? '';

        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StarBackgroundWrapper(
                  child: ChatScreen(
                navigateUrl: createdGuruData['navigateUrl'],
                initialSelectedGuru: createdGuru.name,
                chatId: createdGuruData['chatId'],
                chatbotId: createdGuru.id,
              )),
            ),
          );
        });
      }
    } catch (e, stackTrace) {
      print("Error creating guru: $e");
      print("Full Stack Trace: $stackTrace");

      setState(() {
        _isLoading = false;
      });

      _showErrorDialog(e.toString());
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(message: message);
      },
    );
  }

  // Show success dialog
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessDialog(message: message);
      },
    );
  }

  //TextEdititng controller for the fields
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();
  final TextEditingController subjectcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Get screen height and width for responsive design
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600 ||
        (screenWidth > 600 && screenWidth / screenHeight < 0.6);

    bool isDesktop = MediaQuery.of(context).size.width >= 1024;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    double calculateFontSize(double baseSize) {
      return isDesktop
          ? screenWidth * 0.025
          : baseSize * (textScaleFactor > 1.0 ? 0.7 : 1.0);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body:
          // Foreground content wrapped in SingleChildScrollView
          SingleChildScrollView(
        child: Center(
          child: Container(
            width: isDesktop
                ? screenWidth * 0.5
                : isTablet
                    ? screenWidth * 0.8
                    : screenWidth * 0.9,
            margin: EdgeInsets.symmetric(
              horizontal: isDesktop
                  ? screenWidth * 0.1
                  : isTablet
                      ? screenWidth * 0.1
                      : 0.0,
              vertical: 10.0,
            ),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04), // Dynamic padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: isTablet
                          ? screenHeight * 0.05
                          : screenHeight * 0.11), // Adjust top spacing
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
                        'Add a new Guru',
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: calculateFontSize(screenWidth * 0.050),

                          // fontSize: isTablet
                          //     ? screenWidth * 0.050
                          //     : screenWidth * 0.065,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: isDesktop
                          ? screenHeight * 0.03
                          : isTablet
                              ? screenHeight * 0.01
                              : screenHeight * 0.05), // Adjusted spacing

                  // Name Input Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Label
                      Text(
                        'Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isDesktop
                              ? screenWidth * 0.017
                              : isTablet
                                  ? screenWidth * 0.02
                                  : screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      // Text Field for the Name
                      CustomTextfield(
                        maxlines: 1,
                        minlines: 1,
                        placeholder: 'Guru\'s Name',
                        controller: namecontroller,
                      ),

                      SizedBox(height: screenHeight * 0.035),
                      // Description Label
                      Text(
                        'Description',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isDesktop
                              ? screenWidth * 0.017
                              : isTablet
                                  ? screenWidth * 0.02
                                  : screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      // TextField for the Description
                      CustomTextfield(
                        maxlines: 10,
                        minlines: 4,
                        placeholder:
                            'A customizable AI Guru with real-time adjustments.',
                        controller: descriptioncontroller,
                      ),

                      SizedBox(height: screenHeight * 0.035),
                      // Subject Field
                      Text(
                        'Subject',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isDesktop
                              ? screenWidth * 0.017
                              : isTablet
                                  ? screenWidth * 0.02
                                  : screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      // TextField for the subject
                      CustomTextfield(
                        maxlines: 1,
                        minlines: 1,
                        placeholder: 'Guru\'s Subject',
                        controller: subjectcontroller,
                      ),

                      SizedBox(
                          height:
                              screenHeight * 0.060), // Space before the button
                      // Let's ask button
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF86A6D4),
                                Color(0xFF9A8FDC), // Light Purple
                                Color(0xFFB47AE2),
                                Color(0xFFAF7CE4), // Intermediate Purple
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(
                                50), // Match button's border radius
                          ),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _createGuru,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop
                                    ? screenWidth * 0.02
                                    : isTablet
                                        ? screenWidth * 0.03
                                        : screenWidth * 0.08,
                                vertical: isDesktop
                                    ? screenHeight * 0.006
                                    : screenHeight * 0.008,
                              ), // Dynamic padding
                              backgroundColor: Colors
                                  .transparent, // Set to transparent to show gradient
                              shadowColor: Colors.transparent,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    "Continue",
                                    style: TextStyle(
                                      fontFamily: 'Lexend',
                                      fontSize: isTablet
                                          ? screenWidth * 0.02
                                          : screenWidth *
                                              0.06, // Dynamic font size based on screen width
                                      fontWeight:
                                          FontWeight.w600, // Make text bold
                                      color: Colors
                                          .black, // Set text color to black
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
