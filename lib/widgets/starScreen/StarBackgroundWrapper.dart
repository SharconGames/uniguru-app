import 'package:flutter/material.dart';
import 'package:uniguru/widgets/starScreen/star_background.dart';

class StarBackgroundWrapper extends StatelessWidget {
  final Widget child;
  const StarBackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const StarBackground(),
        child,
      ],
    );
  }
}
