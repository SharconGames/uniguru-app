import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniguru/context/AppCommunicator.dart';
import 'package:uniguru/context/stateModels.dart';
import 'package:http/http.dart' as http;
import 'package:uniguru/screens/login.dart';
import 'package:uniguru/widgets/starScreen/StarBackgroundWrapper.dart';

// Define the provider for authentication state
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

// The AuthState class holds the user's state (logged in, user data, etc.)
class AuthState {
  final bool isLoggedIn;
  final User? user;
  final IChat? chat;
  final List<Guru> gurus;
  final Guru? selectedGuru;
  final String selectedModel;
  final String? navigateUrl;
  final String? error;

  AuthState({
    required this.isLoggedIn,
    this.user,
    this.chat,
    required this.gurus,
    this.selectedGuru,
    required this.selectedModel,
    this.navigateUrl,
    this.error,
  });

  factory AuthState.initial() {
    return AuthState(
      isLoggedIn: false,
      user: null,
      chat: null,
      gurus: [],
      selectedGuru: null,
      selectedModel: 'llama-3.3-70b-versatile',
      navigateUrl: null,
      error: null,
    );
  }

  AuthState copyWith({
    bool? isLoggedIn,
    User? user,
    IChat? chat,
    List<Guru>? gurus,
    Guru? selectedGuru,
    String? selectedModel,
    String? navigateUrl,
    String? error,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      chat: chat ?? this.chat,
      gurus: gurus ?? this.gurus,
      selectedGuru: selectedGuru ?? this.selectedGuru,
      selectedModel: selectedModel ?? this.selectedModel,
      navigateUrl: navigateUrl ?? this.navigateUrl,
      error: error ?? this.error,
    );
  }
}

// AuthNotifier is used to update the AuthState using Riverpod's StateNotifier
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(AuthState.initial());

  Future<void> initializeAuth() async {
    try {
      final data = await ApiCommunicator.checkAuthStatus();
      state = state.copyWith(
        isLoggedIn: true,
        user: User.fromJson(data),
      );

      await _fetchOrCreateGurus(); // Fetch or create default guru
    } catch (e) {
      print("Error checking auth status: $e");
      state = state.copyWith(
        error: 'Failed to initialize authentication. Please try again.',
      );
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final data = await ApiCommunicator.loginUser(email, password);

      if (data == null) {
        state = state.copyWith(
          error: 'Login failed. Please try again.',
          isLoggedIn: false,
        );
        return;
      }

      final user = User(
        id: data['id'] ?? '',
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        chatId: data['chatId'],
        chatbotId: data['chatbotId'],
      );

      state = state.copyWith(
        isLoggedIn: true,
        user: user,
        navigateUrl: data['navigateUrl'],
        error: null,
      );

      // Fetch or create default guru
      await _fetchOrCreateGurus();

      print(
          "Login successful: User=${user.name}, NavigateUrl=${state.navigateUrl}");
    } catch (e) {
      print("Error during login: $e");
      state = state.copyWith(
        error: 'Login failed. Please try again.',
        isLoggedIn: false,
      );
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      final data = await ApiCommunicator.signupUser(name, email, password);

      if (data == null) {
        state = state.copyWith(
          error: 'Signup failed. Please try again.',
          isLoggedIn: false,
        );
        return;
      }

      // Create User object from the response data
      final user = User(
        id: data['id'] ?? '',
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        chatId: data['navigateUrl']?.split('/').last ?? '', // Extract chatId
        chatbotId: data['chatbotId'] ?? '',
      );

      // Check if user data is incomplete
      if (user.id.isEmpty || user.chatbotId!.isEmpty) {
        state = state.copyWith(
          error: 'Incomplete user data received from server.',
          isLoggedIn: false,
        );
        return;
      }

      // Update state with necessary data after successful signup
      state = state.copyWith(
        isLoggedIn: true,
        user: user,
        navigateUrl: data['navigateUrl'],
        error: null,
      );

      // Fetch or create gurus
      await _fetchOrCreateGurus();

      print(
          "Signup successful: User=${user.name}, NavigateUrl=${state.navigateUrl}");
    } catch (e) {
      print("Error during signup: $e");
      state = state.copyWith(
        error: 'Signup failed. Please try again.',
        isLoggedIn: false,
      );
    }
  }

//Google Login
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        "907212592664-a7pglfqqa2evt0tn27tm2qupcg6us8d5.apps.googleusercontent.com",
    scopes: [
      'email',
      'profile',
      'openid',
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  bool _isProcessing = false; // Add this flag to prevent multiple calls

  Future<void> signInWithGoogle(BuildContext context) async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      if (kIsWeb) {
        // Start Google Sign-In process
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          _isProcessing = false;
          return;
        }

        // Get authentication details
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final String? accessToken = googleAuth.accessToken;

        if (accessToken == null) {
          throw Exception('Failed to get access token');
        }

        // Fetch user info using the access token
        final userInfoResponse = await http.get(
          Uri.parse('https://www.googleapis.com/oauth2/v2/userinfo'),
          headers: {'Authorization': 'Bearer $accessToken'},
        );

        if (userInfoResponse.statusCode != 200) {
          throw Exception('Failed to get user info from Google');
        }

        final userInfo = json.decode(userInfoResponse.body);

        // Send data to your backend
        final response = await http.post(
          Uri.parse('https://api.uni-guru.in/auth/google/token'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'token': accessToken,
            'email': userInfo['email'],
            'name': userInfo['name'],
            'picture': userInfo['picture'],
          }),
        );

        print('Google Sign-In Response Status: ${response.statusCode}');
        print('Google Sign-In Response Body: ${response.body}');

        if (response.statusCode != 200) {
          throw Exception('Backend authentication failed: ${response.body}');
        }

        final responseData = json.decode(response.body);

        // Save token to shared preferences
        final prefs = await SharedPreferences.getInstance();
        if (responseData['token'] != null) {
          await prefs.setString('jwtToken', responseData['token']);
        }

        // Create User object from response
        final user = User(
          id: responseData['user']['id'],
          name: responseData['user']['name'],
          email: responseData['user']['email'],
          chatId: '',
          chatbotId: '',
        );

        // Update state with user data and navigation URL
        state = state.copyWith(
          isLoggedIn: true,
          user: user,
          navigateUrl: responseData['navigateUrl'],
          error: null,
        );

        // Fetch or create gurus after successful login
        await _fetchOrCreateGurus();
      } else {
        // Android platform sign-in code
        final apiCommunicator = ref.read(apiCommunicatorProvider);
        final result = await apiCommunicator.signInWithGoogle();

        if (result.error == null && result.data != null) {
          final user = User(
            id: result.data.uid,
            name: result.data.name,
            email: result.data.email,
            chatId: result.data.chatId ?? '', // Use chatId from server response
            chatbotId: result.data.chatbotId ??
                '', // Use chatbotId from server response
          );

          state = state.copyWith(
            isLoggedIn: true,
            user: user,
            error: null,
          );

          // Fetch or create default guru
          await _fetchOrCreateGurus();

          print("Google sign-in successful: User=${user.name}");
          print("Login chatId: ${user.chatId}");
          print("Login chatbotId: ${user.chatbotId}");
        } else {
          state = state.copyWith(
            error: result.error ?? 'Google sign-in failed.',
            isLoggedIn: false,
          );
        }
      }
    } catch (e) {
      print("Error during Google sign-in: $e");
      state = state.copyWith(
        error: 'Google sign-in failed. Please try again.',
        isLoggedIn: false,
      );
    } finally {
      _isProcessing = false;
    }
  }

  //google signout function
  Future<void> signOutWithGoogle(BuildContext context) async {
    try {
      final apiCommunicator = ref.read(apiCommunicatorProvider);
      final result = await apiCommunicator.signOutWithGoogle();

      if (result.error == null) {
        // Reset the entire state
        state = AuthState.initial();

        // Clear all stored preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        // Navigate to login screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: Color(0xFF2B1736),
            content: Text(
              'Successfully logged out',
              style: TextStyle(color: Colors.white),
            )));
        print("Google sign-out successful");
      } else {
        state = state.copyWith(
          error: result.error ?? 'Google sign-out failed',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xFF2B1736),
              content: Text(
                result.error ?? 'Logout failed',
                style: TextStyle(color: Colors.white),
              )),
        );
      }
    } catch (e) {
      print("Error during Google sign-out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: Color(0xFF2B1736),
            content: Text(
              'Error: ${e.toString()}',
              style: TextStyle(color: Colors.white),
            )),
      );
    }
  }

  // final GoogleSignIn _googleSignIn = GoogleSignIn()

  Future<Map<String, dynamic>> logout(BuildContext context) async {
    if (kIsWeb) {
      try {
        // Get shared preferences
        final prefs = await SharedPreferences.getInstance();

        // Handle Google Sign-In cleanup for web
        try {
          await _googleSignIn.signOut();
          await _googleSignIn.disconnect();
        } catch (e) {
          print('Google Sign-In cleanup error (non-critical): $e');
        }

        // Clear all stored data
        await prefs.clear();

        // Reset auth state
        state = AuthState.initial();

        // Wait for cleanup to complete
        await Future.delayed(const Duration(milliseconds: 500));

        // Navigate to login screen safely
        if (context.mounted) {
          await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => StarBackgroundWrapper(
                child: LoginScreen(),
              ),
            ),
            (route) => false,
          );
        }

        return {'success': true, 'message': 'Logged out successfully'};
      } catch (e) {
        print('Logout Error: $e');
        return {'success': false, 'message': 'Unable to complete logout'};
      }
    } else {
      try {
        // Android: Call the logoutUser function
        final result = await ApiCommunicator.logoutUser();

        if (result['success']) {
          // Reset the state
          state = AuthState.initial();

          // Clear stored credentials
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();

          // Navigate to login screen
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          }

          return {'success': true, 'redirect': result['redirect'] ?? '/login'};
        } else {
          return {'success': false, 'message': result['message']};
        }
      } catch (error) {
        print('Error during logout: $error');
        return {'success': false, 'message': error.toString()};
      }
    }
  }

  // Keep the forced logout method for web
  Future<Map<String, dynamic>> performForcedLogout(BuildContext context) async {
    if (!kIsWeb)
      return {'success': false, 'message': 'Not supported on this platform'};

    try {
      // Clear Google Sign-In session
      await _googleSignIn.signOut();

      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Reset authentication state
      state = AuthState.initial();

      // Navigate to login screen safely
      if (context.mounted) {
        await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => StarBackgroundWrapper(
              child: LoginScreen(),
            ),
          ),
          (route) => false,
        );
      }

      return {'success': true, 'message': 'Logged out successfully'};
    } catch (e) {
      print('Forced Logout Error: $e');
      return {'success': false, 'message': 'Unable to complete logout'};
    }
  }

  Future<void> removeGuru(String guruId) async {
    try {
      // Call the API to delete the guru
      await ApiCommunicator.deleteGuru(guruId);

      // Update the local state to remove the guru
      final updatedGurus =
          state.gurus.where((guru) => guru.id != guruId).toList();

      // Determine the new selected guru
      Guru? newSelectedGuru;
      if (updatedGurus.isNotEmpty) {
        // If the current selected guru was deleted, select the first guru
        if (state.selectedGuru?.id == guruId) {
          newSelectedGuru = updatedGurus.first;
        } else {
          // Maintain the current selected guru if it wasn't deleted
          newSelectedGuru = state.selectedGuru;
        }
      }

      // Update the state with the filtered gurus and potentially new selected guru
      state = state.copyWith(
        gurus: updatedGurus,
        selectedGuru: newSelectedGuru,
      );

      // Optional: Save updated gurus to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final guruJsonList =
          updatedGurus.map((guru) => json.encode(guru.toJson())).toList();
      await prefs.setStringList('savedGurus', guruJsonList);
    } catch (e) {
      print("Error deleting guru: $e");
      state = state.copyWith(
        error: 'Failed to remove guru. Please try again.',
      );
      rethrow; // Rethrow to allow error handling in the UI
    }
  }

  Future<void> _refreshChatSession(Guru guru) async {
    try {
      // Fetch chats for the new selected guru
      final chatData = await ApiCommunicator.fetchChatFromGurus(guru.id);

      // Update the guru in the state with fetched chats
      final updatedGurus = state.gurus.map((existingGuru) {
        if (existingGuru.id == guru.id) {
          return guru.copyWith(chats: chatData['chats'] ?? []);
        }
        return existingGuru;
      }).toList();

      // Update the state with the updated gurus
      state = state.copyWith(
        gurus: updatedGurus,
        selectedGuru: updatedGurus.firstWhere((g) => g.id == guru.id),
      );
    } catch (e) {
      print("Error refreshing chat session: $e");
    }
  }

// Add a method to load saved gurus from SharedPreferences
  Future<void> loadSavedGurus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedGuruJsonList = prefs.getStringList('savedGurus') ?? [];

      final savedGurus = savedGuruJsonList
          .map((guruJson) => Guru.fromJson(json.decode(guruJson)))
          .toList();

      // Update the state with saved gurus
      state = state.copyWith(
          gurus: savedGurus,
          selectedGuru: savedGurus.isNotEmpty ? savedGurus.first : null);
    } catch (e) {
      print("Error loading saved gurus: $e");
    }
  }

  Future<void> _fetchOrCreateGurus() async {
    try {
      // First, try to load saved gurus from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final savedGuruJsonList = prefs.getStringList('savedGurus') ?? [];

      if (savedGuruJsonList.isNotEmpty) {
        final savedGurus = savedGuruJsonList
            .map((guruJson) => Guru.fromJson(json.decode(guruJson)))
            .toList();

        state = state.copyWith(
            gurus: savedGurus,
            selectedGuru: savedGurus.isNotEmpty ? savedGurus.first : null);

        return; // Exit if saved gurus are found
      }

      // If no saved gurus, fetch from the backend
      final userGurusData =
          await ApiCommunicator.fetchUserGurus(userId: state.user!.id);

      if (userGurusData['chatbots'] != null &&
          userGurusData['chatbots'] is List) {
        List<Guru> gurus = [];
        for (var chatbotJson in userGurusData['chatbots']) {
          if (chatbotJson is Map<String, dynamic>) {
            var guru = Guru.fromJson(chatbotJson);
            gurus.add(guru);
          }
        }

        // Update the state with fetched gurus
        state = state.copyWith(
            gurus: gurus, selectedGuru: gurus.isNotEmpty ? gurus[0] : null);

        // Save fetched gurus to SharedPreferences
        final guruJsonList =
            gurus.map((guru) => json.encode(guru.toJson())).toList();
        await prefs.setStringList('savedGurus', guruJsonList);
      } else {
        state = state.copyWith(
          error:
              'No gurus found for this user or the data structure is invalid.',
        );
      }
    } catch (e) {
      print("Error fetching or creating gurus: $e");
      state = state.copyWith(
        error: 'Failed to fetch or create gurus. Please try again.',
      );
    }
  }

  Future<void> addGuru(Guru newGuru, dynamic state) async {
    try {
      final userId = state.user.id;

      final createdGuruData =
          await ApiCommunicator.createNewGuru(newGuru.toJson(), userId);
      final createdGuru = Guru.fromJson(createdGuruData);

      state = state.copyWith(
        gurus: [...state.gurus, createdGuru],
        selectedGuru: createdGuru,
      );
    } catch (e) {
      print("Error creating guru: $e");
      state =
          state.copyWith(error: 'Failed to add new guru. Please try again.');
    }
  } 

// Add this method in AuthNotifier class

  Future<void> updateChatTitle(
      String chatId, String userId, String newTitle, dynamic state) async {
    try {
      await ApiCommunicator.updateTitleOfTheChat(chatId, newTitle);

      final updatedGurus = state.gurus.map((guru) {
        if (guru.id == state.selectedGuru?.id) {
          final updatedChats = guru.chats.map((chat) {
            if (chat.id == chatId) {
              chat.title = newTitle;
            }
            return chat;
          }).toList();

          return guru.copyWith(chats: updatedChats);
        }
        return guru;
      }).toList();

      state = state.copyWith(gurus: updatedGurus);
    } catch (e) {
      print("Error updating chat title: $e");
      state = state.copyWith(
          error: 'Failed to update chat title. Please try again.');
    }
  }
}

extension AuthStateCopyWith on AuthState {
  AuthState copyWith({
    bool? isLoggedIn,
    User? user,
    IChat? chat,
    List<Guru>? gurus,
    Guru? selectedGuru,
    String? selectedModel,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      chat: chat ?? this.chat,
      gurus: gurus ?? this.gurus,
      selectedGuru: selectedGuru ?? this.selectedGuru,
      selectedModel: selectedModel ?? this.selectedModel,
    );
  }
}

class Guru {
  final String name;
  final String description;
  final String subject;
  final String id;
  final String userId;
  final List<dynamic> chats;

  Guru({
    required this.name,
    required this.description,
    required this.subject,
    required this.id,
    required this.userId,
    this.chats = const [], // Ensure the chats field is properly initialized
  });

  factory Guru.fromJson(Map<String, dynamic> json) {
    return Guru(
      id: json['_id'] ?? json['id'] ?? '', // Handle different key names
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      subject: json['subject'] ?? '',
      userId: json['user'] ?? '', // Assuming 'user' is the key for userId
      chats: json['chats'] is List
          ? List<dynamic>.from(json['chats'])
          : [], // Safely convert chats to a list
    );
  }

  // Add the toJson method to serialize Guru to a Map

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'subject': subject,
      'user': userId,
      'chats': chats,
    };
  }

  // CopyWith for Guru
  Guru copyWith({
    String? name,
    String? description,
    String? subject,
    String? id,
    String? userId,
    List<dynamic>? chats,
  }) {
    return Guru(
      name: name ?? this.name,
      description: description ?? this.description,
      subject: subject ?? this.subject,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      chats: chats ?? this.chats,
    );
  }
}

class IChat {
  final String id;
  String title;
  String user;
  String chatbot;
  List<Message> messages;
  DateTime createdAt;
  DateTime updatedAt;

  IChat({
    required this.id,
    required this.title,
    required this.user,
    required this.chatbot,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IChat.fromJson(Map<String, dynamic> json) {
    return IChat(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      user: json['user'] ?? '',
      chatbot: json['chatbot'] ?? '',
      messages: (json['messages'] as List?)
              ?.map((messageJson) => Message.fromJson(messageJson))
              .toList() ??
          [],
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Add the toJson method to serialize IChat to a Map
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

class Message {
  final String user;
  final String content;
  final DateTime timestamp;

  Message({
    required this.user,
    required this.content,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      user: json['user'] ?? '',
      content: json['content'] ?? '',
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Add the toJson method to serialize Message to a Map
  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
