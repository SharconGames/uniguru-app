class User {
  final String id;
  final String name;
  final String email;
  final String? chatId;
  final String? chatbotId;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.chatId,
    this.chatbotId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      chatId: json['chatId'],
      chatbotId: json['chatbotId'],
    );
  }

  // Convert User object back to a Map for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'chatbotid': chatbotId,
    };
  }

  // Add equality and hashCode for proper comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Guru {
  String id;
  String name;
  String description;
  String subject;
  String userid;
  List<IChat> chats;
  List<String> chatIds;

  // Constructor
  Guru({
    required this.id,
    required this.name,
    required this.description,
    required this.subject,
    required this.userid,
    required this.chats,
    required this.chatIds,
  });

  factory Guru.fromJson(Map<String, dynamic> json) {
    var chatsFromJson = json['chats'] as List? ?? [];
    List<IChat> chatList =
        chatsFromJson.map((chatJson) => IChat.fromJson(chatJson)).toList();
    return Guru(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      subject: json['subject'] ?? '',
      userid: json['userid'] ?? '',
      chats: chatList,
      chatIds: List<String>.from(json['chatIds'] ?? []),
    );
  }

  // Method to convert Guru object back to a Map for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'subject': subject,
      'userid': userid,
      'chats': chats.map((chat) => chat.toJson()).toList(),
      'chatIds': chatIds,
    };
  }

  // Method to update the chat title within the guru
  void updateChatTitle(String chatId, String newTitle) {
    for (var chat in chats) {
      if (chat.id == chatId) {
        chat.title = newTitle;
      }
    }
  }
}

class IChat {
  String id; // Changed '_id' to 'id' for the public parameter
  String title;
  String user;
  String chatbot;
  List<IMessage> messages;
  DateTime createdAt;
  DateTime updatedAt;

  IChat({
    required this.id, // Changed '_id' to 'id'
    required this.title,
    required this.user,
    required this.chatbot,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IChat.fromJson(Map<String, dynamic> json) {
    return IChat(
      id: json['_id'] ?? '', // '_id' field in the API response
      title: json['title'] ?? '',
      user: json['user'] ?? '',
      chatbot: json['chatbot'] ?? '',
      messages: (json['messages'] as List?)
              ?.map((messageJson) => IMessage.fromJson(messageJson))
              .toList() ??
          [],
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Convert IChat object to Map for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'user': user,
      'chatbot': chatbot,
      'messages': messages.map((message) => message.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class IMessage {
  String sender; // "user" or "guru"
  String content;
  DateTime timestamp;

  IMessage({
    required this.sender,
    required this.content,
    required this.timestamp,
  });

  factory IMessage.fromJson(Map<String, dynamic> json) {
    return IMessage(
      sender: json['sender'] ?? '',
      content: json['content'] ?? '',
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Convert IMessage object to Map for serialization
  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
