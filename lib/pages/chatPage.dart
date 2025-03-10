import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uniguru/context/AppCommunicator.dart';
import 'package:uniguru/context/AuthNotifier.dart';
import 'package:uniguru/widgets/CustomDrawer.dart';
import 'package:uniguru/widgets/chatItems/chatMessages.dart';
import 'package:uniguru/widgets/chatItems/chatNavbar.dart';
import 'package:uniguru/widgets/chatItems/chat_message.dart';
import 'package:uniguru/widgets/voiceDialog.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String? navigateUrl;
  final String? chatId;
  final String? chatbotId;
  final String? initialSelectedGuru;

  const ChatPage({
    super.key,
    required this.navigateUrl,
    this.chatId,
    this.chatbotId,
    this.initialSelectedGuru,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  static const String groqApiKey =
      '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';
  static const String groqApiUrl = 'http://api.uni-guru.in/api/v1/chat/new';

  final SpeechToText _speechToText = SpeechToText();
  final TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1000 &&
        MediaQuery.of(context).size.shortestSide < 1200;
  }

  String? selectedGuruName;
  bool _speechEnabled = false;
  bool _isListening = false;
  bool _isDrawerOpen = false;
  String _lastResult = "";
  DateTime? _lastSoundDetected;
  Timer? _silenceTimer;
  String? selectedUsers;
  String? selectedVersion;
  String? selectedChatHistory;
  String? chatId;
  bool _showScrollButton = false;

  //Fetch GuruNames
  List<String> getGuruNames() {
    final authState = ref.watch(authStateProvider);
    return authState.gurus.map((guru) => guru.name).toList();
  }

  //Fetch GuruId
  List<String> getGuruId() {
    final authState = ref.watch(authStateProvider);
    return authState.gurus.map((guru) => guru.id).toList();
  }

  final List<String> Models = ["llama3-8b-8192"];

  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    initSpeech();

    chatId = widget.chatId;

    _scrollController.addListener(_scrollListener);

    // Extract chatId from navigateUrl using RegExp
    final chatIdMatch =
        RegExp(r'\/([^\/]+)\/c\/([^\/]+)').firstMatch(widget.navigateUrl ?? '');
    if (chatIdMatch != null) {
      chatId = chatIdMatch.group(2); // Extract chatId from the URL

      // Fetch existing chat messages
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchChatMessages();
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authStateProvider);

      // Check if an initial guru is passed
      if (widget.initialSelectedGuru != null) {
        setState(() {
          selectedGuruName = widget.initialSelectedGuru;
        });

        // Trigger guru selection
        onGuruSelected(widget.initialSelectedGuru);
      } else {
        // Existing logic to select default guru
        final uniGuru = authState.gurus.firstWhere(
          (guru) => guru.name == "UniGuru",
          orElse: () => authState.gurus.first,
        );
        setState(() {
          selectedGuruName = uniGuru.name;
        });
      }
    });
  }

// Separate function for handling chat history selection
  void onChatHistorySelected(String chatId) async {
    print('SELECTING CHAT HISTORY: $chatId'); // Debug log

    // Check if the selected chat is already the active chat
    if (this.chatId == chatId) {
      print("Chat is already selected. Skipping fetch.");
      return; // If the chat is already selected, don't fetch again.
    }

    setState(() {
      this.chatId = chatId; // Use this.chatId to reference the class variable
      messages.clear(); // Clear the previous messages before fetching new ones
    });

    // Fetch the messages for the selected chat history
    await _fetchChatMessages();
  }

// 2. Keep onGuruSelected focused only on guru changes
  void onGuruSelected(String? guruName) async {
    if (guruName == null) return;
    final authState = ref.read(authStateProvider);

    // If the "Create Guru" option is selected, navigate to the create guru page
    if (guruName == "Create Guru") {
      Navigator.pushNamed(context, '/createguru');
      return;
    }

    // Fetch the selected guru based on the name
    final selectedGuru = authState.gurus.firstWhere(
      (guru) => guru.name == guruName,
      orElse: () => authState.gurus.first,
    );

    // Update the auth state with the selected guru
    ref.read(authStateProvider.notifier).state = authState.copyWith(
      selectedGuru: selectedGuru,
    );

    // Check if the selected guru is different from the current one
    if (selectedGuru.name != selectedGuruName) {
      // If yes, create a new chat session
      try {
        final newChatSession = await ApiCommunicator.startNewChatSession(
          userId: authState.user!.id,
          chatbotId: selectedGuru.id,
          createNewSession: true,
        );

        setState(() {
          selectedGuruName = selectedGuru.name; // Update the guru name
          chatId = newChatSession['chatId']; // Set the new chatId
          messages.clear(); // Clear existing messages
        });

        // Fetch new chat history
        await _fetchChatMessages();
      } catch (e) {
        print('Error creating new chat session: $e');
        _showErrorSnackBar('Failed to create new chat session');
      }
    } else {
      // If the selected guru is the same as the current one, just fetch messages
      if (chatId != null && chatId!.isNotEmpty) {
        setState(() {
          messages.clear(); // Clear existing messages
        });
        await _fetchChatMessages(); // Fetch the existing chat messages
      }
    }
  }

  // Add this new method to handle scroll events
  void _scrollListener() {
    // Show button if not at bottom and there's enough content to scroll
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      final threshold =
          200.0; // Show button when user has scrolled up this many pixels

      setState(() {
        _showScrollButton = currentScroll < maxScroll - threshold;
      });
    }
  }

  //Scroll to the bottom
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  //Function for speech to text
  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  //Function for the start listening
  void _startListening() async {
    if (_speechEnabled) {
      setState(() => _isListening = true);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => SpeechRecognitionDialog(
          onStopListening: _stopListening,
        ),
      );

      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 10),
        partialResults: true,
        onSoundLevelChange: (level) {
          if (level < 0.1) _handleSilence();
        },
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      );
    }
  }

  //Function for the stop listening
  void _stopListening() async {
    await _speechToText.stop();
    setState(() => _isListening = false);
  }

  //Function for the handle silence
  void _handleSilence() {
    if (_lastSoundDetected == null) {
      _lastSoundDetected = DateTime.now();
      _silenceTimer?.cancel();
      _silenceTimer = Timer(Duration(seconds: 10), () {
        if (mounted && _isListening) {
          _stopListening();
          Navigator.of(context).pop();
        }
      });
    }
  }

  ////Function for the specech result
  void _onSpeechResult(SpeechRecognitionResult result) {
    if (!result.finalResult || result.recognizedWords == _lastResult) return;

    _lastSoundDetected = null;
    _silenceTimer?.cancel();

    setState(() {
      _lastResult = result.recognizedWords;
      _textEditingController.text = _textEditingController.text.isEmpty
          ? result.recognizedWords
          : "${_textEditingController.text} ${result.recognizedWords}";

      _textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textEditingController.text.length),
      );
    });
  }

  // Add a method to show error to user
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  //Function for send messages
  Future<void> _sendMessage() async {
    final message = _textEditingController.text.trim();
    if (message.isEmpty || chatId == null) return;

    final authState = ref.read(authStateProvider);
    final selectedGuru = authState.selectedGuru;
    final userId = authState.user?.id;

    if (selectedGuru == null || userId == null) {
      _showErrorSnackBar('Unable to send message. User or Guru not selected.');
      return;
    }
    final timestamp = DateTime.now(); // Capture timestamp

    setState(() {
      // Add user message
      messages.add(ChatMessage(
        text: message,
        isUser: true,
        isGuru: false,
        timestamp: timestamp,
      ));
      // Add placeholder AI message
      messages.add(ChatMessage(
        text: 'Generating response...',
        isGuru: true,
        isUser: false,
        timestamp: timestamp,
      ));
      _textEditingController.clear();
    });

    try {
      // Get the stream of AI responses
      final responseStream = await ApiCommunicator.generateChatCompletion(
        chatbotId: selectedGuru.id,
        message: message,
        model: 'llama3-8b-8192',
        userId: userId,
        chatId: chatId!,
      );

      // Track the last message index for updating
      final lastMessageIndex = messages.length - 1;
      String fullResponse = '';

      // Listen to the stream and update message in real-time
      responseStream.listen((chunk) {
        print('Received chunk: $chunk'); // Debugging step
        setState(() {
          fullResponse += chunk;
          messages[lastMessageIndex] = ChatMessage(
            text: fullResponse,
            isGuru: true,
            isUser: false,
            timestamp: DateTime.now(), // Keep updating timestamp
          );
        });

        // Scroll to bottom with each chunk
        _scrollToBottom();
      }, onDone: () {
        print('AI response completed');
      }, onError: (error) {
        print('Stream Error: ${error.toString()}'); // Debugging
        setState(() {
          messages[lastMessageIndex] = ChatMessage(
            text: 'Error: ${error.toString()}',
            isGuru: true,
            isUser: false,
            timestamp: DateTime.now(),
          );
        });
        print('Failed to get AI response');
      });
    } catch (e) {
      print('Chat Completion Error: $e');
      _showErrorSnackBar('Failed to send message');
    }
  }

  //method to fetch existing chat messages in ChatPage
  Future<void> _fetchChatMessages() async {
    if (chatId == null) {
      print('ChatId is null, cannot fetch messages');
      return;
    }

    try {
      print('Fetching messages for chatId: $chatId');
      final chatData = await ApiCommunicator.getChatWithGuru(chatId!);

      print('chatData Response: $chatData');

      if (!mounted) return;

      setState(() {
        messages.clear();
        if (chatData['messages'] != null) {
          messages = chatData['messages'].map<ChatMessage>((msg) {
            return ChatMessage(
              text: msg['content'],
              isUser: msg['sender'] == 'user',
              isGuru: msg['sender'] == 'guru',
              timestamp: DateTime.parse(msg['timestamp']).toLocal(),
            );
          }).toList();
        }
      });

      print('Messages updated: ${messages.length} messages');

      // Ensure scrolling happens after the UI is updated
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    } catch (e) {
      print('Error fetching chat messages: $e');
      if (mounted) {
        _showErrorSnackBar('Failed to load chat history');
      }
    }
  }

//Chat Input Area
  Widget _buildChatInput({bool isDesktop = false}) {
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600 &&
        MediaQuery.of(context).size.shortestSide < 700;
    bool isMTablet = MediaQuery.of(context).size.shortestSide >= 700 &&
        MediaQuery.of(context).size.shortestSide < 1024;
    bool isDesktop = MediaQuery.of(context).size.width >= 1024;

    final screenWidth = MediaQuery.of(context).size.width;

    // Define padding values for different screen width ranges
    final paddingMap = {
      5000: (true) ? 430.0 : 400.0,
      900: (true) ? 250.0 : 180.0,
      1800: (true) ? 440.0 : 420.0,
      1600: (true) ? 330.0 : 280.0,
      1400: (true) ? 310.0 : 250.0,
      1200: (true) ? 270.0 : 230.0,
      1000: (true) ? 260.0 : 220.0,
      800: (true) ? 80.0 : 120.0,
      700: (true) ? 70.0 : 100.0,
      600: (true) ? 60.0 : 80.0,
      0: 25.0 // Default for mobile, use 25.0 instead of 25
    };

    double getPadding(double width, bool isLeft) {
      double padding = 25.0; // Default value, now a double
      for (var entry in paddingMap.entries) {
        if (width >= entry.key) {
          padding = entry.value; // No need to cast to double anymore
          break;
        }
      }
      return padding;
    }

    return SafeArea(
      top: false, // Disable top SafeArea
      bottom: true,
      child: Padding(
        padding: EdgeInsets.only(
          left: getPadding(screenWidth, true),
          right: getPadding(screenWidth, false),
          bottom: screenWidth >= 1000
              ? 20
              : screenWidth >= 700
                  ? 15
                  : 8,
          top: 10,
        ),
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
                        shaderCallback: (bounds) => const LinearGradient(
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
                            // Add these properties for multiline support
                            maxLines: 3,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              hintText: 'Ask Your Guru..',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: isDesktop ? 16 : 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: isDesktop ? 10 : 10,
                                horizontal: 5,
                              ),
                              // Add this to prevent overflow issues
                              isCollapsed: false,
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isDesktop ? 16 : 16,
                            ),

                            onEditingComplete: () {},
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => _isListening ? _stopListening() : _startListening(),
              child: SizedBox(
                height: isDesktop ? 35 : 35,
                width: isDesktop ? 35 : 35,
                child: Image.asset('assets/voice_light.png'),
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: _sendMessage,
              child: SizedBox(
                height: isDesktop ? 40 : 40,
                width: isDesktop ? 40 : 40,
                child: Image.asset('assets/send_light.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    final guruNames = getGuruNames();
    final guruId = getGuruId();
    final authState = ref.watch(authStateProvider);

    bool isDesktop = _isDesktop(context);
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            ChatNavBar(
              guruId: guruId,
              selectedUsers: selectedGuruName,
              gurus: guruNames,
              onUserSelected: onGuruSelected,
              isDesktop: isDesktop,
              onMenuTap: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchChatMessages,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 50 : 2,
                      vertical: isDesktop ? 20 : 10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                        message: messages[index], isDesktop: isDesktop);
                  },
                ),
              ),
            ),
            _buildChatInput(isDesktop: isDesktop),
          ],
        ),
        if (_showScrollButton)
          Positioned(
            right: isDesktop ? 100 : 10,
            bottom: isDesktop ? 100 : 80,
            child: FloatingActionButton(
              mini: !isDesktop,
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  side: const BorderSide(color: Colors.white30)),
              onPressed: _scrollToBottom,
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      endDrawer: CustomDrawer(
          onNewChat: () {
            final authState = ref.read(authStateProvider);

            // Check if user and selected guru are available
            if (authState.user != null && authState.selectedGuru != null) {
              try {
                // Call the startNewChatSession method from ApiCommunicator
                ApiCommunicator.startNewChatSession(
                  userId: authState.user!.id,
                  chatbotId: authState.selectedGuru!.id,
                  createNewSession: true,
                ).then((newChatSession) {
                  // Assuming newChatSession is a map and contains a 'chatId' field
                  String newChatId = newChatSession['chatId'];
                  print('New chat session created with chatId: $newChatId');

                  final String navigateUrl =
                      '/${authState.selectedGuru!.name}/c/$newChatId';
                  Navigator.pushNamed(
                    context,
                    navigateUrl,
                  );

                  print(
                      'New chat session created: ${newChatSession['chatId']}');
                }).catchError((error) {
                  // Handle any errors that occur during chat session creation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to create new chat: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error creating new chat: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select a guru first'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          },
          onModelSelected: (newValue) =>
              setState(() => selectedVersion = newValue),
          onHistorySelected: (newValue) =>
              setState(() => selectedChatHistory = newValue),
          selectedVersion: selectedVersion,
          selectedChatHistory: selectedChatHistory,
          Models: Models),
      onEndDrawerChanged: (isOpen) => setState(() => _isDrawerOpen = isOpen),
      body: Stack(
        children: [
          if (_isDrawerOpen)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(),
              ),
            ),
          _isDrawerOpen
              ? Opacity(
                  opacity: 0.1,
                  child: IgnorePointer(
                    ignoring: true,
                    child: _buildMainContent(),
                  ),
                )
              : _buildMainContent(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _silenceTimer?.cancel();
    _textEditingController.dispose();
    _scrollController.removeListener(_scrollListener); // Remove scroll listener
    _scrollController.dispose();
    super.dispose();
  }
}
