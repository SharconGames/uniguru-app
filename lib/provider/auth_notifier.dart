import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uniguru/screens/home.dart';
import 'package:uniguru/services/auth_services.dart';

final authNotifierProvider = StateNotifierProvider<AuthNotifier, bool>(
    (ref) => AuthNotifier(ref.watch(authServiceprovider)));

class AuthNotifier extends StateNotifier<bool> {
  final AuthServices _authServices;
  AuthNotifier(this._authServices) : super(false);

  login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      state = true;

      await _authServices.login(email: email, password: password).then((value) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomePage()));
      });
      state = false;
    } catch (e) {
      state = false;
    }
  }
}
