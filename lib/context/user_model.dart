class UserModel {
  final String email;
  final String name;
  final String profilePic;
  final String uid;
  final String token;
  final String? chatId;
  final String? chatbotId;
  final String? navigateUrl;

  UserModel({
    required this.email,
    required this.name,
    required this.profilePic,
    required this.uid,
    required this.token,
    this.chatId = '',
    this.chatbotId = '',
    this.navigateUrl,
  });

  UserModel copyWith({
    String? email,
    String? name,
    String? profilePic,
    String? uid,
    String? token,
    String? chatId,
    String? chatbotId,
    String? navigateUrl,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      uid: uid ?? this.uid,
      token: token ?? this.token,
      chatId: chatId ?? this.chatId,
      chatbotId: chatbotId ?? this.chatbotId,
      navigateUrl: navigateUrl ?? this.navigateUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'profilePic': profilePic,
      'uid': uid,
      'token': token,
      'chatId': chatId,
      'chatbotId': chatbotId,
      'navigateUrl': navigateUrl,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      uid: map['uid'] ?? '',
      token: map['token'] ?? '',
      chatId: map['chatId'],
      chatbotId: map['chatbotId'],
      navigateUrl: map['navigateUrl'],
    );
  }
}