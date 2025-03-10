import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:uniguru/context/AuthNotifier.dart';
import 'package:uniguru/widgets/chatItems/chat_message.dart';
import 'package:intl/intl.dart'; // Import for formatting time

// Create a provider to manage TTS state globally
final ttsStateProvider =
    StateNotifierProvider<TTSStateNotifier, TTSState>((ref) {
  return TTSStateNotifier();
});

// TTS State class
class TTSState {
  final String? playingMessageId;
  final FlutterTts flutterTts;

  TTSState({this.playingMessageId, required this.flutterTts});

  TTSState copyWith({String? playingMessageId}) {
    return TTSState(
      playingMessageId: playingMessageId,
      flutterTts: flutterTts,
    );
  }
}

// TTS State Notifier
class TTSStateNotifier extends StateNotifier<TTSState> {
  TTSStateNotifier() : super(TTSState(flutterTts: FlutterTts())) {
    _initTTS();
  }

  Future<void> _initTTS() async {
    await state.flutterTts.setLanguage("en-US");
    await state.flutterTts.setPitch(1.0);
  }

  Future<void> toggleSpeak(String messageId, String text) async {
    if (state.playingMessageId == messageId) {
      await state.flutterTts.stop();
      state = state.copyWith(playingMessageId: null);
    } else {
      if (state.playingMessageId != null) {
        await state.flutterTts.stop();
      }
      await state.flutterTts.speak(text);
      state = state.copyWith(playingMessageId: messageId);
    }
  }

  @override
  void dispose() {
    state.flutterTts.stop();
    super.dispose();
  }
}

class ChatMessagesList extends ConsumerWidget {
  final List<ChatMessage> messages;

  const ChatMessagesList({
    super.key,
    required this.messages,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDesktop = MediaQuery.of(context).size.width >= 1024;

    return ListView.builder(
      padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 30 : 20, vertical: isDesktop ? 20 : 10),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return MessageBubble(message: messages[index], isDesktop: isDesktop);
      },
    );
  }
}

class MessageBubble extends ConsumerStatefulWidget {
  final ChatMessage message;
  final bool isDesktop;

  const MessageBubble({
    super.key,
    required this.message,
    this.isDesktop = false,
  });

  @override
  ConsumerState<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends ConsumerState<MessageBubble> {
  bool _isTimestampVisible = false;

  bool isCodeBlock(String text) {
    const codeIndicators = ['=', ';', '[', ']', '{', '}', '#', '//'];
    return codeIndicators.any((indicator) => text.contains(indicator));
  }

  void copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard!')),
    );
  }

  String _getInitial(WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    if (authState.user != null && authState.user!.name.isNotEmpty) {
      return authState.user!.name[0].toUpperCase();
    }
    return 'U';
  }

  void _handleTap() {
    setState(() {
      _isTimestampVisible = !_isTimestampVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ttsState = ref.watch(ttsStateProvider);
    final isPlaying = ttsState.playingMessageId == widget.message.messageId;
    final userInitial = _getInitial(ref);
    final formattedTime =
        DateFormat('hh:mm a').format(widget.message.timestamp);

    bool isLDesktop = MediaQuery.of(context).size.width >= 1200;
    bool isXLDesktop = MediaQuery.of(context).size.width >= 1390;
    bool isDesktop = MediaQuery.of(context).size.width >= 960 &&
        MediaQuery.of(context).size.shortestSide < 1200;

    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    bool isMTablet = MediaQuery.of(context).size.shortestSide >= 880 &&
        MediaQuery.of(context).size.shortestSide < 960;

    return GestureDetector(
      onTap: _handleTap, // Show timestamp on tap
      child: Padding(
        padding: widget.isDesktop
            ? EdgeInsets.only(
                left: widget.message.isUser
                    ? MediaQuery.of(context).size.width *
                        0.1 // 30% of screen width
                    : MediaQuery.of(context).size.width *
                        0.16, // 35% of screen width
                right: widget.message.isUser
                    ? MediaQuery.of(context).size.width *
                        0.19 // 35% of screen width
                    : MediaQuery.of(context).size.width *
                        0.1, // 30% of screen width
                top: 15,
              )
            : isMTablet
                ? EdgeInsets.only(
                    left: widget.message.isUser
                        ? MediaQuery.of(context).size.width *
                            0.1 // 30% of screen width
                        : MediaQuery.of(context).size.width *
                            0.1, // 35% of screen width
                    right: widget.message.isUser
                        ? MediaQuery.of(context).size.width *
                            0.05 // 35% of screen width
                        : MediaQuery.of(context).size.width *
                            0.05, // 30% of screen width
                    top: 15,
                  )
                : isXLDesktop
                    ? EdgeInsets.only(
                        left: widget.message.isUser
                            ? MediaQuery.of(context).size.width *
                                0.1 // 30% of screen width
                            : MediaQuery.of(context).size.width *
                                0.18, // 35% of screen width
                        right: widget.message.isUser
                            ? MediaQuery.of(context).size.width *
                                0.19 // 35% of screen width
                            : MediaQuery.of(context).size.width *
                                0.1, // 30% of screen width
                        top: 15,
                      )
                    : isLDesktop
                        ? EdgeInsets.only(
                            left: widget.message.isUser
                                ? MediaQuery.of(context).size.width *
                                    0.1 // 30% of screen width
                                : MediaQuery.of(context).size.width *
                                    0.15, // 35% of screen width
                            right: widget.message.isUser
                                ? MediaQuery.of(context).size.width *
                                    0.19 // 35% of screen width
                                : MediaQuery.of(context).size.width *
                                    0.1, // 30% of screen width
                            top: 15,
                          )
                        : isTablet
                            ? EdgeInsets.only(
                                left: widget.message.isUser
                                    ? MediaQuery.of(context).size.width *
                                        0.1 // 30% of screen width
                                    : MediaQuery.of(context).size.width *
                                        0.08, // 35% of screen width
                                right: widget.message.isUser
                                    ? MediaQuery.of(context).size.width *
                                        0.1 // 35% of screen width
                                    : MediaQuery.of(context).size.width *
                                        0.1, // 30% of screen width
                                top: 15,
                              )
                            : widget.message.isUser
                                ? const EdgeInsets.only(
                                    left: 50, right: 1, top: 15)
                                : const EdgeInsets.only(right: 55, top: 15),
        child: Column(
          crossAxisAlignment: widget.message.isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: widget.message.isUser
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!widget.message.isUser)
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/splash_image.png',
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                const SizedBox(width: 10),
                IntrinsicWidth(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: widget.isDesktop
                          ? widget.message.isUser
                              ? MediaQuery.of(context).size.width *
                                  0.4 // 40% of screen width
                              : MediaQuery.of(context).size.width *
                                  0.4 // 40% of screen width
                          : widget.message.isUser
                              ? MediaQuery.of(context).size.width *
                                  0.5 // 50% of screen width
                              : MediaQuery.of(context).size.width *
                                  0.72, // 80% of screen width

                      minWidth:
                          10, // Set a minimum width to avoid overly shrinking
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.message.isUser
                            ? const [
                                Color(0xFF284675),
                                Color(0xFF44356F),
                                Color(0xFF4C316A),
                                Color(0xFF374564),
                                Color(0xFF00655D),
                              ]
                            : const [Color(0x00000000), Color(0x00000000)],
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                        color: Colors.white54,
                        width: 0.5,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: widget.isDesktop ? 15 : 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // isCodeBlock(widget.message.text)
                          //     ? Align(
                          //         alignment: widget.message.isGuru
                          //             ? Alignment
                          //                 .centerLeft // Align from left for guru
                          //             : Alignment
                          //                 .centerRight, // Align from right for user
                          //         child: Container(
                          //           padding: EdgeInsets.symmetric(
                          //             horizontal: widget.isDesktop
                          //                 ? 30
                          //                 : 8.0, // Add horizontal padding for desktop
                          //             vertical: widget.isDesktop
                          //                 ? 15
                          //                 : 8.0, // Add vertical padding for desktop
                          //           ),
                          //           decoration: BoxDecoration(
                          //             color: widget.message.isGuru
                          //                 ? const Color(0xFF1a202c)
                          //                 : const Color(0xFF2B1736),
                          //             borderRadius: BorderRadius.circular(8),
                          //           ),
                          //           child: SingleChildScrollView(
                          //             scrollDirection: Axis.horizontal,
                          //             child: Text(
                          //               widget.message.text,
                          //               style: const TextStyle(
                          //                 fontFamily: 'Courier',
                          //                 color: Colors.white,
                          //               ),
                          //             ),
                          //           ),
                          //         ))
                          Align(
                            alignment: widget.message.isGuru
                                ? Alignment
                                    .centerLeft // Align from left for guru
                                : Alignment
                                    .centerRight, // Align from right for user
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: widget.isDesktop
                                      ? 30
                                      : 8.0, // Add horizontal padding for desktop text

                                  vertical: widget.isDesktop ? 5 : .0),
                              child: Text(
                                widget.message.text,
                                style: TextStyle(
                                  fontFamily: 'Lexend',
                                  color: Colors.white,
                                  fontSize: widget.isDesktop ? 15 : 14,
                                ),
                              ),
                            ),
                          ),
                          if (widget.message.isGuru)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    ref
                                        .read(ttsStateProvider.notifier)
                                        .toggleSpeak(
                                          widget.message.messageId,
                                          widget.message.text,
                                        );
                                  },
                                  icon: Icon(
                                    isPlaying
                                        ? Icons.volume_up_sharp
                                        : Icons.volume_off_sharp,
                                    color: Colors.white54,
                                    size: 20,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.copy,
                                    color: Colors.white54,
                                    size: 16,
                                  ),
                                  onPressed: () => copyToClipboard(
                                      widget.message.text, context),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (widget.message.isUser) const SizedBox(width: 10),
                if (widget.message.isUser)
                  CircleAvatar(
                    backgroundColor: const Color.fromARGB(155, 241, 82, 255)
                        .withOpacity(0.5),
                    radius: widget.isDesktop ? 16 : 12,
                    child: Text(
                      userInitial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            if (_isTimestampVisible) // Show timestamp if it's visible
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 45, right: 45),
                child: Text(
                  formattedTime,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
