import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniguru/context/user_model.dart';
import 'package:uniguru/widgets/login/error_model.dart';
import 'package:uniguru/widgets/login/local_storage.dart';

import '../widgets/login/constants.dart';

// Provider for API Communicator
final apiCommunicatorProvider = Provider<ApiCommunicator>((ref) {
  return ApiCommunicator(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorage: LocalStorage(),
  );
});

class ApiCommunicator {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorage _localStorage;

  ApiCommunicator({
    required GoogleSignIn googleSignIn,
    required Client client,
    required LocalStorage localStorage,
  })  : _googleSignIn = googleSignIn,
        _client = client,
        _localStorage = localStorage;

  // static const String BASE_URL = 'https://api.uni-guru.in/api/v1';
  // static const String BASE_URL = 'http://192.168.0.91/api/v1';
  static const String BASE_URL = 'https://api.uni-guru.in/api/v1';
  // Helper function to get the JWT token
  static Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .remove('jwtToken'); // Or whatever key you use to store the token
  }

  // User API Communicator Functions
  static Future<Map<String, dynamic>?> loginUser(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      print("Login Response Status: ${response.statusCode}");
      print("Login Response Body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception('Unable to login, Status: ${response.statusCode}');
      }

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      // Save token to shared preferences
      final prefs = await SharedPreferences.getInstance();
      if (responseData['token'] != null) {
        await prefs.setString('jwtToken', responseData['token']);
        print("Token saved: ${responseData['token']}"); // Add this debug line
      }
      return responseData;
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> signupUser(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/user/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );

      print("Signup Response Status: ${response.statusCode}");
      print("Signup Response Body: ${response.body}");

      if (response.statusCode != 201) {
        throw Exception('Unable to signup, Status: ${response.statusCode}');
      }

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      // Save token to shared preferences (optional, depending on your app's logic)
      final prefs = await SharedPreferences.getInstance();
      if (responseData['token'] != null) {
        await prefs.setString('jwtToken', responseData['token']);
        print("Token saved: ${responseData['token']}"); // Add this debug line
      }

      return responseData;
    } catch (e) {
      print("Error during signup: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>> checkAuthStatus() async {
    final response = await http.get(
      Uri.parse('$BASE_URL/user/auth-status'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Unable to authenticate');
    }
    return json.decode(response.body);
  }

  //Google Login
  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(error: 'Some unexpected error', data: null);
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
          email: user.email,
          name: user.displayName ?? 'Unknown User',
          profilePic: user.photoUrl ?? 'https://placeholder.com/user.png',
          uid: '',
          token: '',
        );

        var res = await _client.post(
          Uri.parse('$host/api/signup'),
          body: jsonEncode(userAcc.toJson()),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
        );

        final responseData = jsonDecode(res.body);
        print('Full Server Response: $responseData'); // Enhanced logging

        if (res.statusCode == 200) {
          if (responseData != null && responseData['user'] != null) {
            final newUser = userAcc.copyWith(
              uid: responseData['user']['_id'] ?? '',
              token: responseData['token'] ?? '',
              chatId: responseData['chatId'] ?? '', // Add these lines
              chatbotId: responseData['chatbotId'] ?? '', // Add these lines
            );

            error = ErrorModel(error: null, data: newUser);

            _localStorage.setToken(newUser.token);
          }
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel(error: 'Some unexpected error', data: null);
    try {
      String? token = await _localStorage.getToken();

      print(token);

      if (token != null) {
        var res = await _client.get(
          Uri.parse('$host/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        switch (res.statusCode) {
          case 200:
            final newUser = UserModel.fromJson(
                    jsonEncode(jsonDecode(res.body)['user'])
                        as Map<String, dynamic>)
                .copyWith(token: token);
            error = ErrorModel(error: null, data: newUser);
            _localStorage.setToken(newUser.token);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  //google signout
  Future<ErrorModel> signOutWithGoogle() async {
    ErrorModel error = ErrorModel(error: 'Some unexpected error', data: null);
    try {
      // First, call the server-side logout endpoint
      String? token = await _localStorage.getToken();

      if (token != null) {
        var logoutResponse = await _client.post(
          Uri.parse('$host/'), // Use your server logout endpoint
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        // Check if logout was successful on the server
        if (logoutResponse.statusCode != 200) {
          print(
              'Server logout failed with status: ${logoutResponse.statusCode}');
        }
      }

      // Sign out from Google
      await _googleSignIn.signOut();

      // Clear local token
      await _localStorage.clearToken();

      error = ErrorModel(error: null, data: 'Successfully logged out');
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
      print('Google sign out error: $e');
    }
    return error;
  }

  // logout
  static Future<Map<String, dynamic>> logoutUser() async {
    try {
      final token = await _getToken(); // Retrieve stored token
      print("Token before logout: $token");
      if (token == null) {
        return {'success': false, 'message': 'No authentication token found'};
      }

      final response = await http.post(
        Uri.parse('$BASE_URL/user/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Cookie': 'jwt=$token'
        },
      );

      print('Logout Response Status: ${response.statusCode}');
      print('Logout Response Body: ${response.body}');

      // Handle different response scenarios
      if (response.statusCode == 200) {
        await clearToken();
        try {
          final responseBody = json.decode(response.body);
          return {
            'success': true,
            'message': responseBody['message'] ?? 'Logout successful',
          };
        } catch (e) {
          return {
            'success': true,
            'message': 'Logout successful',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Logout failed with status: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Detailed Logout Error: $e');
      return {'success': false, 'message': 'Error during logout: $e'};
    }
  }

  // Chat API Communicator Functions
  static Future<Map<String, dynamic>> startNewChatSession({
    required String userId,
    required String chatbotId,
    required createNewSession,
  }) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/chat/start'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'userId': userId,
        'chatbotId': chatbotId,
        'createNewSession': createNewSession,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Unable to start new chat session');
    }
    return json.decode(response.body);
  }

//Generate chat completion
  static Future<Stream<String>> generateChatCompletion({
    required String message,
    required String chatbotId,
    required String userId,
    required String model,
    required String chatId,
  }) async {
    final token = await _getToken();
    final controller = StreamController<String>.broadcast();

    try {
      final request = http.Request('POST', Uri.parse('$BASE_URL/chat/new'));

      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.body = json.encode({
        'message': message,
        'chatbotId': chatbotId,
        'userId': userId,
        'model': model,
        'activeConversation': chatId,
      });

      final response = await request.send();

      // Handle HTTP error responses
      if (response.statusCode != 200) {
        final errorResponse = await response.stream.bytesToString();
        print('HTTP Error ${response.statusCode}: $errorResponse');
        controller.addError('HTTP Error ${response.statusCode}');
        return controller.stream;
      }

      String responseBuffer = ''; // Buffer to store partial JSON responses

      response.stream.transform(utf8.decoder).listen((chunk) {
        print('Raw API Chunk: $chunk'); // Debugging log

        responseBuffer += chunk; // Accumulate response chunks

        try {
          final jsonData = json.decode(responseBuffer); // Parse full response

          if (jsonData['type'] == 'stream') {
            controller.add(jsonData['content']);
          } else if (jsonData['type'] == 'end') {
            controller.close();
          } else if (jsonData['error'] != null) {
            controller.addError(jsonData['error']);
          } else {
            final aiMessage = jsonData['latestMessage']?['content'] ?? '';
            if (aiMessage.isNotEmpty) {
              controller.add(aiMessage);
              controller.close();
            }
          }

          responseBuffer = ''; // Clear buffer after successful parse
        } catch (e) {
          print('Waiting for more data, JSON incomplete: $e');
        }
      }, onError: (error) {
        print('Stream Error: $error');
        controller.addError('Stream Error: $error');
      }, onDone: () {
        controller.close();
      });
    } catch (e) {
      print('Request Error: $e');
      controller.addError('Failed to initiate chat stream: $e');
    }

    return controller.stream;
  }

  static Future<Map<String, dynamic>> getUserChats(String userId) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/chat/users/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Unable to fetch user chats');
    }
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getAllChats() async {
    final response = await http.get(
      Uri.parse('$BASE_URL/chat/all'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Unable to fetch all chats');
    }
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> clearChatMessages(String chatId) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/chat/$chatId/clear'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Unable to clear chat messages');
    }
    return json.decode(response.body);
  }

  //Delete chat History
  static Future<Map<String, dynamic>> deleteChatSession(
      String chatId, String userId) async {
    try {
      final uri = Uri.parse('$BASE_URL/chat/$chatId');
      final request = http.Request('DELETE', uri)
        ..headers.addAll({'Content-Type': 'application/json'})
        ..body = json.encode({'userId': userId});

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        throw Exception('Failed to delete chat session: ${response.body}');
      }

      return json.decode(response.body);
    } catch (e) {
      throw Exception('Error deleting chat session: $e');
    }
  }

  // Guru (Chatbot) API Communicator Functions
  static Future<Map<String, dynamic>> createNewGuru(
      Map<String, dynamic> data, String userId) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/guru/n-g/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    // Log the response for debugging
    print("Create Guru Response Status: ${response.statusCode}");
    print("Create Guru Response Body: ${response.body}");

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      // Parse the error response
      final errorBody = json.decode(response.body);
      final errorMessage = errorBody['message'] ?? 'Unable to create new Guru';

      throw Exception('Unable to create new Guru');
    }
  }

  Future<Map<String, dynamic>> createChat(
    String userId,
    String chatbotId,
    bool createNewSession,
  ) async {
    final String apiUrl =
        '$BASE_URL/chat/start'; // Replace with your backend URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'chatbotId': chatbotId,
          'createNewSession': createNewSession,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(
            'Backend Response: $data'); // Log the response to check if chatId is returned
        return data; // { chatId, title }
      } else {
        throw Exception('Unable to create new chat');
      }
    } catch (error) {
      print('Error creating new chat: $error');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getChatSession(String chatId) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/chat/$chatId/${await getUserId()}'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Unable to fetch chat session');
    }

    return json.decode(response.body);
  }

  // Helper method to get current user ID
  static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? '';
  }

  static Future<Map<String, dynamic>> fetchUserGurus(
      {required String userId}) async {
    print(userId);

    // Include the userId directly in the URL path
    final Uri url = Uri.parse('$BASE_URL/guru/g-g/$userId');

    // Use GET request since the backend expects it
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Unable to fetch user gurus');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> getChatWithGuru(String chatId) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/guru/g-c/$chatId'),
        headers: {'Content-Type': 'application/json'},
      );

      // Log the response body for debugging
      print("Response body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception(
            'Unable to fetch chat from Guru. Status Code: ${response.statusCode}');
      }

      // Parse and return the chat data
      return json.decode(response.body);
    } catch (e) {
      print("Error fetching chat with Guru: $e");
      throw Exception('An error occurred while fetching chat: $e');
    }
  }

  static Future<Map<String, dynamic>> deleteGuru(String chatbotId) async {
    final response = await http.delete(
      Uri.parse('$BASE_URL/guru/g-d/$chatbotId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Unable to delete chatbot');
    }
    return json.decode(response.body);
  }

  // Fetch chats from a specific Guru
  static Future<Map<String, dynamic>> fetchChatFromGurus(
      String chatbotid) async {
    final url = Uri.parse('$BASE_URL/guru/g-chats/$chatbotid');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Unable to fetch chats from Guru');
    }

    return json.decode(response.body);
  }

  // Additional Features (PDF/Image)
  static Future<Map<String, dynamic>> readPdf(String filePath) async {
    final request =
        http.MultipartRequest('POST', Uri.parse('$BASE_URL/feature/pdf/r'));
    request.files.add(await http.MultipartFile.fromPath('pdf', filePath));
    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Unable to read PDF');
    }
    return json.decode(await response.stream.bytesToString());
  }

  static Future<Map<String, dynamic>> scanImageText(String filePath) async {
    final request =
        http.MultipartRequest('POST', Uri.parse('$BASE_URL/feature/image/s'));
    request.files.add(await http.MultipartFile.fromPath('image', filePath));
    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Unable to scan image');
    }
    return json.decode(await response.stream.bytesToString());
  }

  static Future<Map<String, dynamic>> updateTitleOfTheChat(
      String chatId, String newTitle) async {
    final url =
        Uri.parse('$BASE_URL/chat/u-t'); // Replace with your backend URL
    final headers = {'Content-Type': 'application/json'};

    final body = json.encode({
      'chatId': chatId,
      'newTitle': newTitle,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode != 200) {
        throw Exception('Unable to update chat title');
      }

      return json.decode(response.body);
    } catch (e) {
      throw Exception('Error updating chat title: $e');
    }
  }
}
