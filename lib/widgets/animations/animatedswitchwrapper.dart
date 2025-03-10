import 'package:flutter/material.dart';

class AnimatedSwitchScrapper extends StatelessWidget {
  final bool isLogin;
  final Widget loginForm;
  final Widget signupForm;

  const AnimatedSwitchScrapper({
    super.key,
    required this.isLogin,
    required this.loginForm,
    required this.signupForm,
  });
  //Animation for the toggle between login and signup
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 350),
      crossFadeState:
          isLogin ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: loginForm,
      secondChild: signupForm,
      layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              key: bottomChildKey,
              child: bottomChild,
            ),
            Positioned(
              key: topChildKey,
              child: topChild,
            ),
          ],
        );
      },
    );
  }
}
