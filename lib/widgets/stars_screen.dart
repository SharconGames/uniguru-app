import 'dart:math';
import 'package:flutter/material.dart';
import 'package:uniguru/widgets/random_stars.dart';
import 'package:uniguru/widgets/star_painter.dart';
import 'point3d.dart'; // Import the Point3D class

class StarsScreen extends StatefulWidget {
  const StarsScreen({super.key});

  @override
  State<StarsScreen> createState() => _StarsScreenState();
}

class _StarsScreenState extends State<StarsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Point3D> starPositions; // Now a list of Point3D objects
  late List<double> rotationSpeeds; // Unique speeds for each star

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 2),
    )..repeat(); // Infinite animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size inside the build method
    final size = MediaQuery.of(context).size;

    // Generate random star positions based on screen dimensions
    starPositions = generateRandomStarPositions(2000, size.width, size.height)
        .cast<Point3D>();

    // Assign random rotation speeds to each star
    final random = Random();
    rotationSpeeds =
        List.generate(starPositions.length, (_) => random.nextDouble() * 2 - 1);

    return Scaffold(
      backgroundColor: const Color(0xFF1B0725),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: StarPainter(
              starPositions,
              rotationSpeeds,
              _controller.value * 2 * pi, // Pass elapsed time for rotation
            ),
            size: size, // Use full screen size
          );
        },
      ),
    );
  }
}
