import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uniguru/dbHelper/mongodb.dart';
import 'package:uniguru/screens/Changepassword.dart';
import 'package:uniguru/screens/chat.dart';
import 'package:uniguru/screens/createguru.dart';
import 'package:uniguru/screens/home.dart';
import 'package:uniguru/screens/login.dart';
import 'package:uniguru/screens/preference.dart';
import 'package:uniguru/screens/signup.dart';
import 'package:uniguru/screens/splash.dart';
import 'package:uniguru/screens/welcome.dart';
import 'package:uniguru/theme/gradient_theme.dart';
import 'package:uniguru/widgets/stars_screen.dart';
import 'package:uniguru/screens/profilepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(const ProviderScope(child: MyApp())); //wrap the app in provider scope
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
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/welcome': (context) => WelcomePage(
            user: ModalRoute.of(context)!.settings.arguments
                as GoogleSignInAccount),
        '/home': (context) => const HomePage(),
        '/createguru': (context) => const Createguru(),
        '/preference': (context) => const PreferenceScreen(),
        '/chat': (context) => const ChatScreen(),
        '/change-password': (context) => const ChangePasswordScreen(),
        '/profilepage': (context) => const ProfilePage(
              userName: "Rishit",
              userSurname: 'Trivedi',
            ),
      },
    );
  }
}
