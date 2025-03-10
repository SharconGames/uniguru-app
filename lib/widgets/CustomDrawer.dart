import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uniguru/context/AppCommunicator.dart';
import 'package:uniguru/context/AuthNotifier.dart';
import 'package:uniguru/screens/login.dart';
import 'package:uniguru/widgets/starScreen/StarBackgroundWrapper.dart';

final selectedChatProvider = StateProvider<String?>((ref) => null);

class CustomDrawer extends ConsumerStatefulWidget {
  final Function(String?) onModelSelected;
  final Function(String?) onHistorySelected;
  final String? selectedVersion;
  final String? selectedChatHistory;
  final List<String> Models;
  final VoidCallback onNewChat;

  const CustomDrawer({
    super.key,
    required this.onModelSelected,
    required this.onHistorySelected,
    required this.selectedVersion,
    required this.selectedChatHistory,
    required this.Models,
    required this.onNewChat,
  });

  @override
  ConsumerState<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends ConsumerState<CustomDrawer>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> chatHistory = [];
  String? editingChatId;
  late TextEditingController titleController;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimationLeft;
  late Animation<Offset> _slideAnimationRight;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    _fetchChatHistory();

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Animation for sliding from left (Model section)
    _slideAnimationLeft = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Animation for sliding from right (Chat History section)
    _slideAnimationRight = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Fade animation
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // Start animation when drawer opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
    // Initialize the selected chat if it exists
    if (widget.selectedChatHistory != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedChatProvider.notifier).state =
            widget.selectedChatHistory;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

//Function For fetching chat history as title
  Future<void> _fetchChatHistory() async {
    final authNotifier = ref.read(authStateProvider);
    final apiCommunicator = ref.read(apiCommunicatorProvider);
    final userId = authNotifier.user?.id;
    final selectedGuruId = authNotifier.selectedGuru?.id;

    if (userId != null && selectedGuruId != null) {
      try {
        final chatData =
            await ApiCommunicator.fetchChatFromGurus(selectedGuruId);

        if (chatData['chats'] is List) {
          setState(() {
            chatHistory = (chatData['chats'] as List).where((chat) {
              return chat['title'] != null && chat['title'].isNotEmpty;
            }).map((chat) {
              return {
                'id': chat['chatId'],
                'title': chat['title'] ??
                    'Conversation ${chat['chatId'].substring(chat['chatId'].length - 4)}'
              };
            }).toList();
          });
        } else {
          print('No chats available or incorrect data format.');
        }
      } catch (e) {
        print('Error fetching chat history: $e');
      }
    } else {
      print('User or Guru ID is null.');
    }
  }

  Future<void> onLogout() async {
    final authNotifier = ref.read(authStateProvider.notifier);

    try {
      // Attempt to logout with both basic and Google methods
      final basicLogoutResult = await authNotifier.logout(context);
      await authNotifier.signOutWithGoogle(context);

      // Clear the token from local storage
      final localStorage = ref.read(apiCommunicatorProvider);
      await ApiCommunicator.clearToken();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) =>
                StarBackgroundWrapper(child: const LoginScreen())),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: ${e.toString()}')),
      );
    }
  }

//Function edit title
  void _handleEditTitle(String chatId, String currentTitle) {
    setState(() {
      editingChatId = chatId;
      titleController.text = currentTitle;
    });
  }

//Function save title in the database
  Future<void> _handleSaveTitle(String chatId) async {
    final authNotifier = ref.read(authStateProvider.notifier);
    final currentState = ref.read(authStateProvider);
    final userId = currentState.user?.id;

    if (userId != null && titleController.text.isNotEmpty) {
      try {
        // Call authNotifier function to update the chat title in the backend
        await authNotifier.updateChatTitle(
          chatId,
          userId,
          titleController.text,
          currentState,
        );

        setState(() {
          chatHistory = chatHistory.map((chat) {
            if (chat['id'] == chatId) {
              return {
                ...chat,
                'title': titleController.text,
              };
            }
            return chat;
          }).toList();

          editingChatId = null;
          titleController.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xFF2B1736),
              content: Text('Chat title updated successfully')),
        );
      } catch (error) {
        print("Error updating chat title: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update title: $error')),
        );
      }
    }
  }

//Function delete chat
  Future<void> _handleDeleteChat(String chatId) async {
    final authState = ref.read(authStateProvider);
    final userId = authState.user?.id;
    final selectedGuru = authState.selectedGuru;

    if (userId == null || selectedGuru == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID or Guru not found')),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Delete chat session from the database
      await ApiCommunicator.deleteChatSession(chatId, userId);

      // Remove from local chat history
      setState(() {
        chatHistory.removeWhere((chat) => chat['id'] == chatId);
      });

      // Clear selected chat history and provider state
      widget.onHistorySelected(null);
      ref.read(selectedChatProvider.notifier).state = null;

      print('Creating new chat session...'); // Debug log

      // Create new chat session
      final newChatSession = await ApiCommunicator.startNewChatSession(
        userId: userId,
        chatbotId: selectedGuru.id,
        createNewSession: true,
      );

      print('New Chat Session Response: $newChatSession'); // Debug log

      if (newChatSession['chatId'] != null) {
        final String newChatId = newChatSession['chatId'];
        print('New Chat Id: $newChatId'); // Debug log

        final String navigateUrl = '/${selectedGuru.name}/c/$newChatId';
        print('Navigate Url: $navigateUrl'); // Debug log

        // Close loading dialog and drawer
        if (context.mounted) {
          Navigator.pop(context); // Close loading dialog
          Navigator.pop(context); // Close drawer
        }

        // Navigate to the new chat
        if (context.mounted) {
          Navigator.pushReplacementNamed(
            context,
            navigateUrl,
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xFF2B1736),
              content: Text('Chat deleted successfully')),
        );
      } else {
        throw Exception('Failed to create new chat session');
      }
    } catch (e) {
      print('Error in _handleDeleteChat: $e'); // Debug log

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete chat: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedChatId = ref.watch(selectedChatProvider);
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        color: const Color(0xFF2B1736).withOpacity(0.2),
        child: Column(
          children: [
            SizedBox(
              height: 80,
              width: 270,
              child: Padding(
                padding: const EdgeInsets.only(top: 60, right: 25),
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 198),
              child: Align(
                alignment: Alignment.topRight,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final textScaleFactor =
                        MediaQuery.of(context).textScaleFactor;

                    double calculateFontSize() {
                      double baseFontSize = 20;
                      return textScaleFactor > 1.0
                          ? baseFontSize * 0.8
                          : baseFontSize * textScaleFactor;
                    }

                    return ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF664D00),
                          Color(0xFF7F6209),
                          Color(0xFFDAA520),
                          Color(0xFF7F6209),
                          Color(0xFF664D00),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                      child: Text(
                        "Uniguru",
                        style: TextStyle(
                          color: Colors
                              .white, // This is ignored when Shader is applied.
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lexend',
                          fontSize: calculateFontSize(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final textScaleFactor =
                      MediaQuery.of(context).textScaleFactor;

                  double calculateFontSize() {
                    double baseFontSize = 16;
                    return textScaleFactor > 1.0
                        ? baseFontSize * 0.8
                        : baseFontSize * textScaleFactor;
                  }

                  double calculateIconSize() {
                    return 25 * (textScaleFactor > 1.0 ? 0.8 : textScaleFactor);
                  }

                  return OutlinedButton(
                    onPressed: () {
                      ref.read(selectedChatProvider.notifier).state = null;
                      widget.onNewChat();
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          Colors.transparent, // Transparent background
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(25), // Rounded corners
                        side: const BorderSide(
                          color: Colors
                              .transparent, // Transparent border side for button
                          width: 1, // Thin border width (adjust this if needed)
                        ),
                      ),
                      minimumSize:
                          const Size(double.infinity, 50), // Full-width button
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: Colors.white, // White icon color
                            size: calculateIconSize(), // Dynamic icon size
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'New Chat',
                            style: TextStyle(
                              color: Colors.white, // White text
                              fontFamily: 'Lexend',
                              fontSize:
                                  calculateFontSize(), // Dynamic font size
                              fontWeight: FontWeight.bold,
                            ),
                            // maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    children: [
                      // Animated Chat History Section
                      SlideTransition(
                        position: _slideAnimationRight,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: ExpansionTile(
                            title: LayoutBuilder(
                              builder: (context, constraints) {
                                final textScaleFactor =
                                    MediaQuery.of(context).textScaleFactor;

                                double calculateFontSize() {
                                  double baseFontSize = 18;
                                  return textScaleFactor > 1.0
                                      ? baseFontSize * 0.8
                                      : baseFontSize * textScaleFactor;
                                }

                                return Text(
                                  'Chat History',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: calculateFontSize(),
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                            iconColor: Colors.white,
                            collapsedIconColor: Colors.white,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: chatHistory.isNotEmpty
                                    ? SingleChildScrollView(
                                        child: ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: chatHistory.length,
                                          itemBuilder: (context, index) {
                                            final chat = chatHistory[index];
                                            final selectedChatId =
                                                ref.watch(selectedChatProvider);
                                            final isActive =
                                                selectedChatId == chat['id'];

                                            return Container(
                                              //Selected Chat Display with opacity
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 1),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: isActive
                                                    ? const Color.fromARGB(
                                                            155, 241, 82, 255)
                                                        .withOpacity(0.3)
                                                    : Colors.transparent,
                                              ),

                                              child: ListTile(
                                                title: editingChatId ==
                                                        chat['id']
                                                    ? TextField(
                                                        controller:
                                                            titleController,
                                                        onSubmitted: (_) =>
                                                            _handleSaveTitle(
                                                                chat['id']!),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              UnderlineInputBorder(),
                                                          hintText:
                                                              'Enter new title',
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      )
                                                    : Text(
                                                        chat['title']!,
                                                        style: TextStyle(
                                                          color: isActive
                                                              ? Colors.white
                                                              : Colors.grey
                                                                  .shade400,
                                                          fontWeight: isActive
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal,
                                                          fontFamily: 'Lexend',
                                                        ),
                                                      ),
                                                trailing:
                                                    PopupMenuButton<String>(
                                                  icon: const Icon(
                                                      Icons.more_vert,
                                                      color: Colors.white),
                                                  color: Colors
                                                      .grey, //Three Button Icon
                                                  onSelected: (value) {
                                                    if (value == 'edit') {
                                                      _handleEditTitle(
                                                          chat['id']!,
                                                          chat['title']!);
                                                    } else if (value ==
                                                        'delete') {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            backgroundColor:
                                                                Color(
                                                                    0xFF2B1736),
                                                            title: const Text(
                                                              'Delete Chat',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            content: const Text(
                                                                'Are you sure you want to delete this chat?'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: const Text(
                                                                    'Cancel'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: const Text(
                                                                    'Delete'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  _handleDeleteChat(
                                                                      chat[
                                                                          'id']!);
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                  itemBuilder: (context) => [
                                                    const PopupMenuItem(
                                                      value: 'edit',
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.edit,
                                                              size: 16,
                                                              color: Color
                                                                  .fromARGB(255,
                                                                      3, 3, 3)),
                                                          SizedBox(width: 8),
                                                          Text(
                                                            'Edit',
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        3,
                                                                        3,
                                                                        3)), // Text color for edit
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const PopupMenuItem(
                                                      value: 'delete',
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.delete,
                                                              size: 16,
                                                              color: Color
                                                                  .fromARGB(255,
                                                                      2, 2, 2)),
                                                          SizedBox(width: 8),
                                                          Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        5,
                                                                        5,
                                                                        5)), // Text color for edit
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () {
                                                  final selectedChatId =
                                                      chat['id'];
                                                  final authState = ref
                                                      .read(authStateProvider);
                                                  final selectedGuru =
                                                      authState.selectedGuru;

                                                  if (selectedChatId != null &&
                                                      selectedGuru != null) {
                                                    ref
                                                        .read(
                                                            selectedChatProvider
                                                                .notifier)
                                                        .state = selectedChatId;
                                                    final guruName =
                                                        selectedGuru.name;
                                                    final route =
                                                        '/$guruName/c/$selectedChatId';

                                                    Navigator.pushNamed(
                                                        context, route);
                                                    widget.onHistorySelected(
                                                        chat['id']);
                                                  }
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : LayoutBuilder(
                                        builder: (context, constraints) {
                                          final textScaleFactor =
                                              MediaQuery.of(context)
                                                  .textScaleFactor;

                                          double calculateFontSize() {
                                            double baseFontSize = 14;
                                            return textScaleFactor > 1.0
                                                ? baseFontSize * 0.8
                                                : baseFontSize *
                                                    textScaleFactor;
                                          }

                                          return Text(
                                            'No chat history available.',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: calculateFontSize(),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 80, right: 80),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Get text scale factor
                  final textScaleFactor =
                      MediaQuery.of(context).textScaleFactor;

                  // Adaptive font size calculation
                  double calculateFontSize() {
                    // Base font size with scaling
                    double baseFontSize = 16;

                    // Adjust font size based on text scale factor
                    if (textScaleFactor > 1.0) {
                      return baseFontSize *
                          0.8; // Reduce size for larger scale factors
                    }

                    return baseFontSize * textScaleFactor;
                  }

                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors
                            .transparent, // Set transparent color for the border
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(
                          25), // Match border radius with button
                    ),
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF664D00),
                          Color(0xFF7F6209),
                          Color(0xFFDAA520),
                          Color(0xFF7F6209),
                          Color(0xFF664D00),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: OutlinedButton(
                        onPressed: onLogout,
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              Colors.transparent, // Transparent background
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(25), // Rounded corners
                          ),
                          minimumSize: const Size(50, 50), // Minimum size
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.logout_outlined,
                                color: Colors.white,
                                size: 25, // Icon size
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.white, // White text
                                  fontFamily: 'Lexend',
                                  fontSize:
                                      calculateFontSize(), // Dynamic font size
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
