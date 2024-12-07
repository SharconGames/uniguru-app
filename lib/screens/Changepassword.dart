import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Old Password', style: TextStyle(color: Colors.white)),
            TextField(controller: _oldPasswordController),
            const SizedBox(height: 20),
            const Text('New Password', style: TextStyle(color: Colors.white)),
            TextField(controller: _newPasswordController),
            const SizedBox(height: 20),
            const Text('Confirm New Password', style: TextStyle(color: Colors.white)),
            TextField(controller: _confirmPasswordController),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Add your password change logic here
                if (_newPasswordController.text == _confirmPasswordController.text) {
                  // Perform password change
                } else {
                  // Show error message
                }
              },
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
