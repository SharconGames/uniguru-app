import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:uniguru/context/user_model.dart';
import 'package:uniguru/widgets/login/constants.dart';
import 'package:uniguru/widgets/login/error_model.dart';
import 'package:uniguru/widgets/login/local_storage.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
      googleSignIn: GoogleSignIn(),
      client: Client(),
      localstorage: LocalStorage(),
    ));

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorage _localStorage;
  AuthRepository(
      {required GoogleSignIn googleSignIn,
      required Client client,
      required LocalStorage localstorage})
      : _googleSignIn = googleSignIn,
        _client = client,
        _localStorage = localstorage;
//Google signin function
  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(error: 'Some unexpected error', data: null);
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        // Handle potentially null values
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

        print('Server Response: ${responseData['navigateurl']}');

        switch (res.statusCode) {
          case 200:
            final responseData = jsonDecode(res.body);
            if (responseData != null && responseData['user'] != null) {
              final newUser = userAcc.copyWith(
                  uid: responseData['user']['_id'] ?? '',
                  token: responseData['token'] ?? '');

              error = ErrorModel(error: null, data: newUser);
              _localStorage.setToken(newUser.token);
            } else {
              error = ErrorModel(error: 'Invalid server response', data: null);
            }
            break;
          default:
            error = ErrorModel(
                error: 'Server error: ${res.statusCode}', data: null);
            break;
        }
      } else {
        error = ErrorModel(error: 'Google sign in failed', data: null);
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
}
