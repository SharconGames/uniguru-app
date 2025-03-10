import 'dart:math';
import 'package:flutter/material.dart';
import 'point3d.dart';
import 'random_stars.dart';
import 'star_painter.dart';

class StarBackground extends StatefulWidget {
  const StarBackground({super.key});

  @override
  State<StarBackground> createState() => _StarBackgroundState();
}

class _StarBackgroundState extends State<StarBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Point3D> starPositions;

  @override
  void initState() {
    super.initState();

    final size = WidgetsBinding.instance.window.physicalSize /
        WidgetsBinding.instance.window.devicePixelRatio;

    // Generate initial star positions based on screen dimensions
    starPositions = generateRandomStarPositions(
        300, size.width, size.height); // Reduced star count

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 1),
    )..repeat(); // Infinite animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0513), // Black background for space
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: StarPainter(
              starPositions,
              _controller.value * 2 * pi, // Pass elapsed time (full circle)
              size.width,
              size.height,
            ),
            size: size,
          );
        },
      ),
    );
  }
}
