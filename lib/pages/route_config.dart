// lib/route_config.dart
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uniguru/screens/chat.dart';
import 'package:uniguru/screens/createguru.dart';
import 'package:uniguru/screens/home.dart';
import 'package:uniguru/screens/login.dart';
import 'package:uniguru/screens/splash.dart';
import 'package:uniguru/screens/welcome.dart';
import 'package:uniguru/widgets/starScreen/StarBackgroundWrapper.dart';

class RouteConfig {
  static Route<dynamic> generateRoute(RouteSettings settings, bool isLoggedIn) {
    final uri = Uri.parse(settings.name!);

    if (uri.pathSegments.length == 3 && uri.pathSegments[1] == 'c') {
      final guruName = uri.pathSegments[0];
      final chatId = uri.pathSegments[2];
      return MaterialPageRoute(
        builder: (context) => StarBackgroundWrapper(
          child: ChatScreen(
            navigateUrl: settings.name!,
            initialSelectedGuru: guruName,
            chatId: chatId,
            chatbotId: '',
          ),
        ),
      );
    }

    final publicRoutes = ['/splash', '/login'];

    if (!isLoggedIn && !publicRoutes.contains(settings.name)) {
      return MaterialPageRoute(
        builder: (_) => StarBackgroundWrapper(child: LoginScreen()),
      );
    }

    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(
          builder: (_) => StarBackgroundWrapper(child: SplashScreen()),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => StarBackgroundWrapper(child: LoginScreen()),
        );
      case '/welcome':
        final args = settings.arguments as GoogleSignInAccount;
        return MaterialPageRoute(
          builder: (_) => StarBackgroundWrapper(
            child: WelcomePage(user: args),
          ),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => StarBackgroundWrapper(child: HomePage()),
        );
      case '/createguru':
        return MaterialPageRoute(
          builder: (_) => StarBackgroundWrapper(child: Createguru()),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => StarBackgroundWrapper(child: SplashScreen()),
        );
    }
  }
}
