import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uniguru/dbHelper/login_api.dart';
import 'package:uniguru/screens/login.dart';

class LoggedInPage extends StatelessWidget {
  final GoogleSignInAccount user;

  const LoggedInPage({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logged In'),
        actions: [
          TextButton(
              onPressed: () async {
                await GoogleSignInApi.logout();

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text('Logout'))
        ],
      ),
      body: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: user.photoUrl != null
                ? NetworkImage(user.photoUrl!)
                : AssetImage('assets/spritual_light.png'),
          ),
          Text(
            'Name: ${user.displayName ?? "Unknown"}',
          ),
          Text('Email: ${user.email}')
        ],
      ),
    );
  }
}
