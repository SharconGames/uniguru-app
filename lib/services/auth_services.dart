import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceprovider = Provider<AuthServices>((ref) => AuthServices());

class AuthServices {
  bool isLoggin = false;

  Future<bool> login({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 3), () {
      isLoggin = true;
    });
    return isLoggin;
  }
}
