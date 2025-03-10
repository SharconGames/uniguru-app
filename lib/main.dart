// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uniguru/context/AuthNotifier.dart';
import 'package:uniguru/pages/route_config.dart' deferred as routes;

import 'package:uniguru/theme/gradient_theme.dart';
import 'package:uniguru/screens/splash.dart' deferred as splash;
import 'package:uniguru/screens/home.dart' deferred as home;
import 'package:uniguru/widgets/starScreen/StarBackgroundWrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load essential modules
  await Future.wait([
    routes.loadLibrary(),
    splash.loadLibrary(),
    home.loadLibrary(),
  ]);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniGuru',
      theme: appTheme.copyWith(
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: FutureBuilder(
        future:
            authState.isLoggedIn ? home.loadLibrary() : splash.loadLibrary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return StarBackgroundWrapper(
              child: authState.isLoggedIn
                  ? home.HomePage()
                  : splash.SplashScreen(),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      onGenerateRoute: (settings) =>
          routes.RouteConfig.generateRoute(settings, authState.isLoggedIn),
    );
  }
}
