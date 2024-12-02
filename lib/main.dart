import 'package:flutter/material.dart';
import 'package:uniguru/dbHelper/mongodb.dart';
import 'package:uniguru/theme/gradient_theme.dart';
import 'package:uniguru/widgets/stars_screen.dart'; // Import your theme.dart file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniGuru',
      theme: appTheme, // Use the appTheme defined in theme.dart
      initialRoute: '/',
      routes: {
        '/': (context) => const StarsScreen(),
        // '/': (context) => const SplashScreen(),
        // '/login': (context) => const LoginScreen(),
        // '/signup': (context) => const SignUpScreen(),
        // '/welcome': (context) => const WelcomePage(userName: "John Smith"),
        // '/home': (context) => const HomePage(),
        // '/createguru': (context) => const Createguru(),
        // '/preference': (context) => const PreferenceScreen(),
        // '/chat': (context) => const ChatScreen(),
      },
    );
  }
}
