import 'package:flutter/material.dart';
import 'package:uniguru/pages/chatPage.dart';

class ChatScreen extends StatelessWidget {
  final String navigateUrl;
  final String chatId;
  final String chatbotId;
  final String? initialSelectedGuru;

  const ChatScreen(
      {super.key,
      required this.navigateUrl,
      required this.chatId,
      required this.chatbotId,
      this.initialSelectedGuru});

  @override
  Widget build(BuildContext context) {
    // Add null checks before passing values
    assert(navigateUrl.isNotEmpty, 'Navigate URL cannot be empty');
    assert(chatId.isNotEmpty, 'Chat ID cannot be empty');

    print('Navigating with chatId: $chatId, chatbotId: $chatbotId');

    return ChatPage(
      navigateUrl: navigateUrl,
      chatId: chatId,
      chatbotId: chatbotId,
      initialSelectedGuru: initialSelectedGuru,
    );
  }
}
