import 'package:flutter/material.dart';
import 'package:uniguru/widgets/star_background.dart';


class ProfilePage extends StatelessWidget {
  final String userName; // Passed from the root code
  final String userSurname; // To be used for surname display

  const ProfilePage({
    super.key,
    required this.userName,
    required this.userSurname,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Star Background
          const StarBackground(), // Using the StarBackground widget

          // Profile content over the background
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the user's name
                  Text(
                    '$userName $userSurname',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Display additional profile information
                  Text(
                    'Email: example@uniguru.com', // Placeholder email
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Member since: January 2024', // Placeholder member since date
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Change password button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the Change Password screen (you need to define this screen)
                      Navigator.pushNamed(context, '/change-password');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple, // Button color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Change Password',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Additional settings or actions (optional)
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the preferences page
                      Navigator.pushNamed(context, '/preference');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Settings',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
