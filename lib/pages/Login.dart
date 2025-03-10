import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  _GoogleSignInScreenState createState() => _GoogleSignInScreenState(); 
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  // Create an instance of FlutterSecureStorage to save the token securely
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  GoogleSignInAccount? _user;

  // Login using Google
  Future<void> _login() async {
    try {
      // Sign in to Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return; // User canceled the login
      }

      // Get Google authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Check if idToken is null and handle it
      final String? idToken = googleAuth.idToken;
      if (idToken == null) {
        print('Google authentication failed: idToken is null');
        return; // Token is null, so we can't continue the login process
      }

      // Send the token to your backend for verification
      final response = await http.post(
        Uri.parse(
            'YOUR_BACKEND_URL/google/token'), // Replace with your backend URL
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'token': idToken,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Successfully authenticated
        print('Authentication successful');
        print('Token: ${data['token']}');
        print('User: ${data['user']['name']}');

        // Save token securely using FlutterSecureStorage
        await _storage.write(
            key: 'auth_token', value: data['token']); // Save the token
        await _storage.write(
            key: 'user_name',
            value: data['user']['name']); // Optionally save user details

        // Optionally navigate to another screen
        // Navigator.pushReplacementNamed(context, '/home');
      } else {
        print('Error: ${response.body}');
      }
    } catch (error) {
      print('Google Sign-In failed: $error');
    }
  }

  // Function to check if the user is logged in by reading the token
  Future<void> _checkLoginStatus() async {
    final String? token = await _storage.read(key: 'auth_token');
    if (token != null) {
      print('User is logged in');
      // You can navigate to a new screen here, like a home screen.
      // Navigator.pushReplacementNamed(context, '/home');
    } else {
      print('User is not logged in');
    }
  }

  // Function to handle user logout
  Future<void> _logout() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_name');
    print('Logged out');
    // Optionally navigate to the login screen after logout
    // Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();
    // Check login status when the app starts
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _login,
              child: Text('Login with Google'),
            ),
            ElevatedButton(
              onPressed: _logout,
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
