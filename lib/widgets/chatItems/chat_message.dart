class ChatMessage {
  final String text;
  final bool isGuru;
  final bool isUser;
  final String messageId;
  final DateTime timestamp; // Add this field

  ChatMessage(
      {required this.text,
      required this.isGuru,
      required this.isUser,
      String? messageId,
      required this.timestamp})
      : messageId =
            messageId ?? DateTime.now().millisecondsSinceEpoch.toString();
}
